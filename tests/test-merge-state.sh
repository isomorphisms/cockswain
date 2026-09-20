#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
consumer=${1:-"$root/bin/cockswain-merge-state"}
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT HUP INT TERM
H=1111111111111111111111111111111111111111
header='status\tcode\tobject_kind\tobject_ref\thead\taction\tdetail'

run_case() {
    name=$1 expected_action=$2 expected_code=$3
    shift 3
    file=$work/$name.tsv
    printf '%b\n' "$header" "$@" > "$file"
    "$consumer" "$file" > "$work/$name.out"
    awk -F '\t' -v expected="$expected_action" '$1=="action" && $2==expected {found=1} END {exit !found}' "$work/$name.out"
    awk -F '\t' -v expected="$expected_code" '$1=="reason_code" && $2==expected {found=1} END {exit !found}' "$work/$name.out"
    printf 'PASS\t%s\t%s\t%s\n' "$name" "$expected_action" "$expected_code"
}

run_case ready CONTINUE READY \
    "READY\tREADY\tpr\tisomorphisms/example#17\t$H\tmerge\tall-required-conditions-satisfied"

run_case running-ci WAIT CI_PENDING \
    "BLOCKED\tCI_PENDING\tcheck\tverify\t$H\twait-check\trun=100"

run_case physical HUMAN PHYSICAL_EXECUTION_REQUIRED \
    "BLOCKED\tPHYSICAL_EXECUTION_REQUIRED\tclaim\tphone-runtime\t$H\trun-phone-command\tresult=NOT_VERIFIED"

run_case authorization HUMAN HUMAN_AUTHORIZATION_REQUIRED \
    "BLOCKED\tHUMAN_AUTHORIZATION_REQUIRED\tauthorization\tapproval.tsv\t$H\trecord-authorization\tstate=missing"

run_case promotable-draft CONTINUE DRAFT \
    "BLOCKED\tDRAFT\tpr\tisomorphisms/example#17\t$H\tmark-ready\tcondition=all-required-evidence"

run_case held-draft WAIT DRAFT \
    "BLOCKED\tDRAFT\tpromotion\texperiment-complete\t$H\thold-draft\tstate=HOLD"

run_case decision-draft HUMAN DRAFT \
    "BLOCKED\tDRAFT\tpromotion\tproduct-decision\t$H\task-owner\tstate=HOLD"

run_case stale-follower CONTINUE FOLLOWER_STALE \
    "BLOCKED\tFOLLOWER_STALE\tfollower\tcatfood#69-phone\t$H\tsupersede-or-reconcile\told-trigger=old"

run_case conflict-before-physical CONTINUE CONFLICT \
    "BLOCKED\tPHYSICAL_EXECUTION_REQUIRED\tclaim\tphone-runtime\t$H\trun-phone-command\tresult=NOT_VERIFIED" \
    "BLOCKED\tCONFLICT\tpr\tisomorphisms/example#17\t$H\tresolve-conflict\tpaths=src/a.c"

run_case ambiguity-investigated CONTINUE AMBIGUOUS \
    "BLOCKED\tAMBIGUOUS\tcheck\tverify\t$H\tcompare-target-branch\tfailure-class=unknown"

printf '%s\n' 'deterministic merge-state consumption passes'
