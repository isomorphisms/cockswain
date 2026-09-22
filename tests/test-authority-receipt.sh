#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
renderer=${1:-"$root/bin/cockswain-authority-receipt"}
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT HUP INT TERM

S=1111111111111111111111111111111111111111
S2=2222222222222222222222222222222222222222
A=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
C=cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
F=ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff

cat > "$work/target.tsv" <<EOF
schema	cockswain-merge-authority-target-v1
repository	isomorphisms/example
pr	17
title	Fixture PR
scope_sha256	$A
classifier_revision	$S
EOF

write_decision() {
    classification=$1 role=$2 context_state=$3 scope_state=$4 classified_scope=$5 revocation=$6 objections=$7
    cat > "$work/decision.tsv" <<EOF
schema	cockswain-merge-authority-decision-v1
classification	$classification
authorization_kind	task-context
authorized_by	human
authority_actor_kind	human
authority_source_kind	human-task
authority_source_id	turn-1
authority_source_role	$role
authority_text_sha256	$F
authority_context_ref	private-task-17
authority_context_sha256	$A
authority_context_state	$context_state
classifier_revision	$S
classifier_contract_sha256	$C
classified_scope_sha256	$classified_scope
scope_state	$scope_state
revocation_state	$revocation
unresolved_objections	$objections
latest_context_record_id	turn-3-okay
EOF
}

expect() {
    name=$1 expected=$2
    "$renderer" "$work/decision.tsv" "$work/target.tsv" "$work/$name.tsv"
    awk -F '\t' -v expected="$expected" '$1=="classification" && $2==expected {found=1} END {exit !found}' "$work/$name.tsv"
    if grep -E '^(head_sha|base_sha|checks|diff_sha)' "$work/$name.tsv" >/dev/null 2>&1; then
        printf 'authority receipt invented GitHub evidence: %s\n' "$name" >&2
        exit 1
    fi
    printf 'PASS\t%s\t%s\n' "$name" "$expected"
}

write_decision AUTHORIZED merge-authorizing-task recovered same "$A" none none
expect task-authority-with-later-okay AUTHORIZED

write_decision AUTHORIZED acknowledgement recovered same "$A" none none
expect acknowledgement-cannot-create-authority UNKNOWN

write_decision AUTHORIZED merge-authorizing-task recovered changed "$F" none none
expect material-scope-change UNKNOWN

write_decision AUTHORIZED merge-authorizing-task missing same "$A" none none
expect unrecoverable-context UNKNOWN

write_decision AUTHORIZED merge-authorizing-task recovered same "$A" revoked none
expect explicit-revocation UNKNOWN

write_decision AUTHORIZED merge-authorizing-task recovered same "$A" none review-thread-3
expect unresolved-objection UNKNOWN

write_decision NOT_AUTHORIZED acknowledgement recovered same "$A" none none
expect review-only-then-okay NOT_AUTHORIZED

write_decision AUTHORIZED merge-authorizing-task recovered same "$A" none none
awk -F '\t' -v OFS='\t' -v wrong="$S2" '$1=="classifier_revision" {$2=wrong} {print}' \
    "$work/decision.tsv" > "$work/x"
mv "$work/x" "$work/decision.tsv"
if "$renderer" "$work/decision.tsv" "$work/target.tsv" "$work/revision-mismatch.tsv" >/dev/null 2>&1; then
    echo 'authority receipt accepted mismatched classifier revision' >&2
    exit 1
fi
printf '%s\n' 'PASS	classifier-revision-mismatch	fail-closed'

printf '%s\n' 'contextual authority receipt boundary passes'
