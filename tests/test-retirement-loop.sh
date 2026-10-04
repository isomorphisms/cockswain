#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
controller=${1:-"$root/bin/cockswain-retirement-loop"}
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT HUP INT TERM

H1=1111111111111111111111111111111111111111

assert_field() {
    file=$1
    key=$2
    value=$3
    awk -F '\t' -v key="$key" -v value="$value" '$1==key && $2==value {found=1} END {exit !found}' "$file"
}

receipt_count() {
    directory=$1
    count=0
    for receipt in "$directory"/*.tsv; do
        [ -f "$receipt" ] || continue
        count=$((count + 1))
    done
    printf '%s\n' "$count"
}

cat > "$work/collector" <<'COLLECTOR'
#!/bin/sh
set -eu

output=$1
: "${LOOP_TEST_STATE:?}"
mkdir -p "$output/managed"
printf 'repository\tpr\tresult\n' > "$output/managed/results.tsv"
printf 'repository\tpr\ttitle\treason\n' > "$output/unmanaged.tsv"

count=0
while IFS= read -r pr; do
    [ -n "$pr" ] || continue
    [ -f "$LOOP_TEST_STATE/done-$pr" ] && continue
    head=$(cat "$LOOP_TEST_STATE/head-$pr")
    slug=isomorphisms-example-$pr
    snapshot=$output/managed/$slug
    mkdir -p "$snapshot"
    printf '%b\n' \
        'schema\taici-pr-observation-v1' \
        'repository\tisomorphisms/example' \
        "pr\t$pr" \
        "head_sha\t$head" > "$snapshot/pr.tsv"
    printf '%b\n' \
        'schema\taici-merge-authorization-observation-v1' \
        'state\tvalid' \
        "head_sha\t$head" \
        'authority_kind\ttask-context' \
        'scope_state\tsame' \
        "receipt_ref\tfixture-authority-$pr" \
        'action\trefresh-authorization' > "$snapshot/authorization.tsv"
    printf 'isomorphisms/example\t%s\tREADY\n' "$pr" >> "$output/managed/results.tsv"
    count=$((count + 1))
done < "$LOOP_TEST_STATE/prs"

unmanaged_count=$(cat "$LOOP_TEST_STATE/unmanaged-count")
number=1
while [ "$number" -le "$unmanaged_count" ]; do
    printf 'isomorphisms/unmanaged\t%s\tOpen work\tno-retirement-policy\n' "$number" >> "$output/unmanaged.tsv"
    count=$((count + 1))
    number=$((number + 1))
done

managed_digest=$(sha256sum "$output/managed/results.tsv" | awk '{print $1}')
unmanaged_digest=$(sha256sum "$output/unmanaged.tsv" | awk '{print $1}')
printf '%s\t%s\n' \
    schema aici-account-collection-v2 \
    status COMPLETE \
    scope owner-authored-visible-repositories \
    owner isomorphisms \
    expected_prs "$count" \
    discovered_prs "$count" \
    managed_sha256 "$managed_digest" \
    unmanaged_sha256 "$unmanaged_digest" > "$output/collection.tsv"
COLLECTOR
chmod +x "$work/collector"

cat > "$work/action" <<'ACTION'
#!/bin/sh
set -eu

request=$1
: "${LOOP_TEST_STATE:?}"

value() {
    awk -F '\t' -v key="$2" '$1==key {print $2; found=1} END {exit !found}' "$1"
}

repository=$(value "$request" repository)
pr=$(value "$request" pr)
head=$(value "$request" expected_head)
action=$(value "$request" action)
printf '%s\t%s\n' "$pr" "$head" >> "$LOOP_TEST_STATE/actions.log"
mode=$(cat "$LOOP_TEST_STATE/mode")

if [ "$mode" = retry-once ] && [ "$pr" = 1 ] && [ ! -f "$LOOP_TEST_STATE/failed-once" ]; then
    : > "$LOOP_TEST_STATE/failed-once"
    printf '%b\n' \
        'schema\tcockswain-retirement-action-result-v1' \
        'status\tFAILED' \
        "repository\t$repository" \
        "pr\t$pr" \
        "expected_head\t$head" \
        "observed_head\t$head" \
        "action\t$action" \
        'pre_action_state\tREADY' \
        'result\tNOT_APPLIED' \
        'retryable\tyes' \
        'error_class\tTRANSIENT_WRITE' \
        'error_message\ttemporary-write-path-failure'
    exit 75
fi

if [ "$mode" = head-changes ] && [ ! -f "$LOOP_TEST_STATE/failed-once" ]; then
    : > "$LOOP_TEST_STATE/failed-once"
    printf '%s\n' 2222222222222222222222222222222222222222 > "$LOOP_TEST_STATE/head-$pr"
    printf '%b\n' \
        'schema\tcockswain-retirement-action-result-v1' \
        'status\tFAILED' \
        "repository\t$repository" \
        "pr\t$pr" \
        "expected_head\t$head" \
        "observed_head\t$head" \
        "action\t$action" \
        'pre_action_state\tREADY' \
        'result\tNOT_APPLIED' \
        'retryable\tyes' \
        'error_class\tTRANSIENT_WRITE' \
        'error_message\twrite-path-failed-before-head-moved'
    exit 75
fi

if [ "$mode" != success-still-open ]; then
    : > "$LOOP_TEST_STATE/done-$pr"
fi
printf '%b\n' \
    'schema\tcockswain-retirement-action-result-v1' \
    'status\tSUCCEEDED' \
    "repository\t$repository" \
    "pr\t$pr" \
    "expected_head\t$head" \
    "observed_head\t$head" \
    "action\t$action" \
    'pre_action_state\tREADY' \
    'result\tMERGED' \
    'retryable\tno' \
    'error_class\t-' \
    'error_message\t-'
ACTION
chmod +x "$work/action"

setup_case() {
    name=$1
    mode=$2
    prs=$3
    unmanaged=$4
    state=$work/$name-state
    run=$work/$name-run
    mkdir -p "$state"
    printf '%s\n' "$mode" > "$state/mode"
    printf '%s\n' "$unmanaged" > "$state/unmanaged-count"
    : > "$state/actions.log"
    for pr in $prs; do
        printf '%s\n' "$pr" >> "$state/prs"
        printf '%s\n' "$H1" > "$state/head-$pr"
    done
}

run_controller() {
    state=$1
    run=$2
    output=$3
    LOOP_TEST_STATE=$state \
        COCKSWAIN_RETIREMENT_COLLECT_CMD=$work/collector \
        COCKSWAIN_RETIREMENT_ACTION_CMD=$work/action \
        COCKSWAIN_RETIREMENT_RETRY_LIMIT=2 \
        "$controller" --apply "$run" > "$output"
}

# The selector plans exactly one action.  The controller is what drains the
# three READY rows, recollecting after each successful mutation.
setup_case multi-ready success '1 2 3' 0
run_controller "$state" "$run" "$work/multi-ready.out"
assert_field "$work/multi-ready.out" state DONE
test "$(receipt_count "$run/actions")" -eq 3
test "$(receipt_count "$run/collection-receipts")" -eq 4
awk -F '\t' 'NR==1 && $1==1 && NR+0 { first=1 } NR==2 && $1==2 { second=1 } NR==3 && $1==3 { third=1 } END {exit !(first && second && third && NR==3)}' "$state/actions.log"

# A first failed write remains durable state.  The next pass recollects the
# same exact head, retries it, then continues to the independent READY row.
setup_case retry retry-once '1 2' 0
run_controller "$state" "$run" "$work/retry.out"
assert_field "$work/retry.out" state DONE
test "$(receipt_count "$run/actions")" -eq 3
grep -F 'write_status	FAILED' "$run/actions/1.tsv" >/dev/null
grep -F 'error_class	TRANSIENT_WRITE' "$run/actions/1.tsv" >/dev/null
awk -F '\t' 'NR==1 && $1==1 {first=1} NR==2 && $1==1 {second=1} NR==3 && $1==2 {third=1} END {exit !(first && second && third && NR==3)}' "$state/actions.log"

# A retry is never replayed after its head moves.  The stale receipt preserves
# both heads and the original failure, and the mutation command runs once.
setup_case stale-head head-changes '1' 0
run_controller "$state" "$run" "$work/stale-head.out"
assert_field "$work/stale-head.out" state BLOCKED
assert_field "$work/stale-head.out" reason_code RETIREMENT_ACTION_STALE
test "$(receipt_count "$run/actions")" -eq 2
grep -F 'error_class	HEAD_CHANGED_BEFORE_RETRY' "$run/actions/2.tsv" >/dev/null
test "$(wc -l < "$state/actions.log")" -eq 1

# A reported merge is not enough.  The following complete collection must show
# the PR retired before another action can be attempted for that same head.
setup_case post-action success-still-open '1' 0
run_controller "$state" "$run" "$work/post-action.out"
assert_field "$work/post-action.out" state BLOCKED
assert_field "$work/post-action.out" reason_code RETIREMENT_ACTION_UNCONFIRMED
test "$(receipt_count "$run/actions")" -eq 2
assert_field "$run/actions/2.tsv" error_class POST_ACTION_RECOLLECTION_FAILED
test "$(wc -l < "$state/actions.log")" -eq 1

# A complete 101-PR collection produces an over-budget receipt before the
# queue-reducing merge.  After that merge, unmanaged work remains visible
# rather than being silently closed to satisfy the budget.
setup_case over-budget success '1' 100
run_controller "$state" "$run" "$work/over-budget.out"
assert_field "$work/over-budget.out" state CONTINUE
assert_field "$work/over-budget.out" reason_code UNMANAGED_PR
assert_field "$run/collection-receipts/1.tsv" queue_count 101
assert_field "$run/collection-receipts/1.tsv" queue_state OVER_BUDGET
awk -F '\t' '$1=="above_budget_since" && $2!="-" {found=1} END {exit !found}' "$run/collection-receipts/1.tsv"
test "$(wc -l < "$state/actions.log")" -eq 1

printf '%s\n' 'PASS: retirement loop drains READY work and preserves failed write state'
