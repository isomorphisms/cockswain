#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
consumer=${1:-"$root/bin/cockswain-pr-retirement"}
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT HUP INT TERM
H=1111111111111111111111111111111111111111

make_account() {
    name=$1
    mkdir -p "$work/$name/managed"
    printf 'repository\tpr\tresult\n' > "$work/$name/managed/results.tsv"
    printf 'repository\tpr\ttitle\treason\n' > "$work/$name/unmanaged.tsv"
}

make_snapshot() {
    account=$1 repository=$2 pr=$3 result=$4 row=$5
    slug=$(printf '%s-%s' "$repository" "$pr" | tr '/' '-')
    mkdir -p "$work/$account/managed/$slug"
    printf '%b\n' \
      'schema\taici-pr-observation-v1' \
      "head_sha\t$H" > "$work/$account/managed/$slug/pr.tsv"
    printf '%b\n' \
      'status\tcode\tobject_kind\tobject_ref\thead\taction\tdetail' \
      "$row" > "$work/$account/managed/$slug/result.tsv"
    printf '%s\t%s\t%s\n' "$repository" "$pr" "$result" >> "$work/$account/managed/results.tsv"
}

assert_field() {
    file=$1 key=$2 value=$3
    awk -F '\t' -v key="$key" -v value="$value" '$1==key && $2==value {found=1} END {exit !found}' "$file"
}

complete_account() {
    account=$work/$1
    count=$(awk 'FNR > 1 { count++ } END { print count+0 }' "$account/managed/results.tsv" "$account/unmanaged.tsv")
    managed=$(sha256sum "$account/managed/results.tsv" | cut -d ' ' -f1)
    unmanaged=$(sha256sum "$account/unmanaged.tsv" | cut -d ' ' -f1)
    printf '%s\t%s\n' \
        schema aici-account-collection-v1 status COMPLETE \
        scope owner-authored-owner-repositories owner isomorphisms \
        expected_prs "$count" discovered_prs "$count" \
        managed_sha256 "$managed" unmanaged_sha256 "$unmanaged" > "$account/collection.tsv"
}

reject_account() {
    if "$consumer" "$work/$1" > "$work/rejected.out" 2> "$work/rejected.err"; then
        echo "FAIL: supervisor accepted $1" >&2
        exit 1
    fi
    test ! -s "$work/rejected.out"
}

make_account ready_first
make_snapshot ready_first isomorphisms/ready 7 READY \
  "READY\tREADY\tpr\tisomorphisms/ready#7\t$H\tmerge\tall-required-conditions-satisfied"
make_snapshot ready_first isomorphisms/physical 8 BLOCKED \
  "BLOCKED\tPHYSICAL_EXECUTION_REQUIRED\tclaim\tphone\t$H\trun-phone-command\tresult=NOT_VERIFIED"
complete_account ready_first
"$consumer" "$work/ready_first" > "$work/ready_first.out"
assert_field "$work/ready_first.out" action CONTINUE
assert_field "$work/ready_first.out" reason_code READY
assert_field "$work/ready_first.out" next_action merge

make_account physical
make_snapshot physical isomorphisms/physical 8 BLOCKED \
  "BLOCKED\tPHYSICAL_EXECUTION_REQUIRED\tclaim\tphone\t$H\trun-phone-command\tresult=NOT_VERIFIED"
complete_account physical
"$consumer" "$work/physical" > "$work/physical.out"
assert_field "$work/physical.out" action HUMAN
assert_field "$work/physical.out" reason_code PHYSICAL_EXECUTION_REQUIRED

make_account waiting
make_snapshot waiting isomorphisms/waiting 9 BLOCKED \
  "BLOCKED\tCI_PENDING\tcheck\tverify\t$H\twait-check\trun=9"
complete_account waiting
"$consumer" "$work/waiting" > "$work/waiting.out"
assert_field "$work/waiting.out" action WAIT
assert_field "$work/waiting.out" reason_code CI_PENDING

make_account unmanaged
printf '%s\t%s\t%s\t%s\n' isomorphisms/new 10 'New work' no-retirement-policy >> "$work/unmanaged/unmanaged.tsv"
complete_account unmanaged
"$consumer" "$work/unmanaged" > "$work/unmanaged.out"
assert_field "$work/unmanaged.out" action CONTINUE
assert_field "$work/unmanaged.out" reason_code UNMANAGED_PR
assert_field "$work/unmanaged.out" next_action add-retirement-policy

make_account empty
complete_account empty
"$consumer" "$work/empty" > "$work/empty.out"
assert_field "$work/empty.out" action DONE
assert_field "$work/empty.out" reason_code NO_OPEN_PRS

make_account uncollected
reject_account uncollected
printf 'schema\taici-account-collection-v1\nstatus\tINCOMPLETE\n' > "$work/uncollected/collection.tsv"
reject_account uncollected

cp -R "$work/unmanaged" "$work/truncated"
printf 'repository\tpr\ttitle\treason\n' > "$work/truncated/unmanaged.tsv"
reject_account truncated

make_account missing_headers
: > "$work/missing_headers/managed/results.tsv"
complete_account missing_headers
reject_account missing_headers

make_account wrong_count
complete_account wrong_count
sed 's/prs	0/prs	1/' "$work/wrong_count/collection.tsv" > "$work/wrong.tsv"
cp "$work/wrong.tsv" "$work/wrong_count/collection.tsv"
reject_account wrong_count

cp -R "$work/unmanaged" "$work/duplicate"
tail -n +2 "$work/unmanaged/unmanaged.tsv" >> "$work/duplicate/unmanaged.tsv"
complete_account duplicate
reject_account duplicate

make_account unknown_status
printf 'isomorphisms/example\t9\tUNKNOWN\n' >> "$work/unknown_status/managed/results.tsv"
complete_account unknown_status
reject_account unknown_status

printf '%s\n' 'PASS: PR retirement keeps open work in the supervisory loop'
