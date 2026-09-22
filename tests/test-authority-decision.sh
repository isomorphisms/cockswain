#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
collector=${1:-"$root/bin/cockswain-authority-decision"}
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT HUP INT TERM

H=1111111111111111111111111111111111111111
printf '%s\n' 'Repair the merge-authority collector only.' > "$work/intent.txt"
printf '%s\n' 'bin/cockswain-authority-decision' > "$work/changed-paths.txt"
intent_sha=$(sha256sum "$work/intent.txt" | awk '{print $1}')
paths_sha=$(sha256sum "$work/changed-paths.txt" | awk '{print $1}')
scope_sha=$(printf '%s\t%s\n' "$intent_sha" "$paths_sha" | sha256sum | awk '{print $1}')
cat > "$work/state.tsv" <<EOF
schema	aici-merge-state-v4
repository	isomorphisms/cockswain
pr	15
title	Collect merge authority from task context
intent_sha256	$intent_sha
changed_paths_sha256	$paths_sha
current_scope_sha256	$scope_sha
EOF

cat > "$work/stub" <<'STUB'
#!/bin/sh
set -eu
request=$1
if grep -F 'review-only-case' "$request" >/dev/null; then
    cat <<'EOF'
{"classification":"NOT_AUTHORIZED","authorization_kind":"task-context","authority_source_kind":"human-task","authority_source_id":"turn-1","authority_source_role":"implementation-instruction","scope_state":"same","revocation_state":"none","unresolved_objections":"none"}
EOF
elif grep -F 'scope-change-case' "$request" >/dev/null; then
    cat <<'EOF'
{"classification":"AUTHORIZED","authorization_kind":"task-context","authority_source_kind":"human-task","authority_source_id":"turn-1","authority_source_role":"merge-authorizing-task","scope_state":"changed","revocation_state":"none","unresolved_objections":"none"}
EOF
elif grep -F 'revoked-case' "$request" >/dev/null; then
    cat <<'EOF'
{"classification":"AUTHORIZED","authorization_kind":"task-context","authority_source_kind":"human-task","authority_source_id":"turn-1","authority_source_role":"merge-authorizing-task","scope_state":"same","revocation_state":"revoked","unresolved_objections":"none"}
EOF
elif grep -F 'objection-case' "$request" >/dev/null; then
    cat <<'EOF'
{"classification":"AUTHORIZED","authorization_kind":"task-context","authority_source_kind":"human-task","authority_source_id":"turn-1","authority_source_role":"merge-authorizing-task","scope_state":"same","revocation_state":"none","unresolved_objections":"turn-4"}
EOF
elif grep -F 'forged-okay-case' "$request" >/dev/null; then
    cat <<'EOF'
{"classification":"AUTHORIZED","authorization_kind":"task-context","authority_source_kind":"human-task","authority_source_id":"turn-3","authority_source_role":"merge-authorizing-task","scope_state":"same","revocation_state":"none","unresolved_objections":"none"}
EOF
elif grep -F 'assistant-source-case' "$request" >/dev/null; then
    cat <<'EOF'
{"classification":"AUTHORIZED","authorization_kind":"task-context","authority_source_kind":"human-task","authority_source_id":"turn-2","authority_source_role":"merge-authorizing-task","scope_state":"same","revocation_state":"none","unresolved_objections":"none"}
EOF
else
    cat <<'EOF'
{"classification":"AUTHORIZED","authorization_kind":"task-context","authority_source_kind":"human-task","authority_source_id":"turn-1","authority_source_role":"merge-authorizing-task","scope_state":"same","revocation_state":"none","unresolved_objections":"none"}
EOF
fi
STUB
chmod +x "$work/stub"

write_context() {
    marker=$1
    cat > "$work/context.tsv" <<EOF
record_id	role	text
turn-1	human	Review and merge this if clean. $marker
turn-2	assistant	I checked the current state.
turn-3	human	Okay.
EOF
}

run_case() {
    name=$1 expected=$2
    context=$3
    out=$work/$name.tsv
    COCKSWAIN_CLASSIFIER_REVISION=$H COCKSWAIN_AUTHORITY_CMD=$work/stub \
        "$collector" private-task-15 "$context" "$work/state.tsv" "$work/intent.txt" "$work/changed-paths.txt" "$out"
    awk -F '\t' -v expected="$expected" '$1=="classification" && $2==expected {found=1} END {exit !found}' "$out"
    printf 'PASS\t%s\t%s\n' "$name" "$expected"
}

write_context authority-later-okay
run_case authority-later-okay AUTHORIZED "$work/context.tsv"
grep -F 'authority_source_id	turn-1' "$work/authority-later-okay.tsv" >/dev/null
grep -F 'latest_context_record_id	turn-3' "$work/authority-later-okay.tsv" >/dev/null
if grep -F 'Review and merge this if clean' "$work/authority-later-okay.tsv" >/dev/null; then
    echo 'private context leaked into public decision' >&2
    exit 1
fi

write_context review-only-case
sed 's/Review and merge this if clean/Review this and tell me whether it is clean/' "$work/context.tsv" > "$work/x"
mv "$work/x" "$work/context.tsv"
run_case review-only-okay NOT_AUTHORIZED "$work/context.tsv"

write_context refresh-same-scope-case
run_case refreshed-same-scope AUTHORIZED "$work/context.tsv"
grep -F "classified_scope_sha256	$scope_sha" "$work/refreshed-same-scope.tsv" >/dev/null

write_context scope-change-case
run_case material-scope-change UNKNOWN "$work/context.tsv"

write_context revoked-case
run_case explicit-revocation UNKNOWN "$work/context.tsv"

write_context objection-case
run_case unresolved-objection UNKNOWN "$work/context.tsv"

write_context forged-okay-case
run_case acknowledgement-cannot-create-authority UNKNOWN "$work/context.tsv"

write_context assistant-source-case
run_case assistant-cannot-create-authority UNKNOWN "$work/context.tsv"

rm -f "$work/missing.tsv"
run_case unrecoverable-context UNKNOWN "$work/missing.tsv"
grep -F 'authority_context_state	missing' "$work/unrecoverable-context.tsv" >/dev/null

cp "$work/state.tsv" "$work/bad-state.tsv"
sed "s/intent_sha256	$intent_sha/intent_sha256	ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff/" \
    "$work/bad-state.tsv" > "$work/x"
mv "$work/x" "$work/bad-state.tsv"
write_context target-digest-mismatch
if COCKSWAIN_CLASSIFIER_REVISION=$H COCKSWAIN_AUTHORITY_CMD=$work/stub \
    "$collector" private-task-15 "$work/context.tsv" "$work/bad-state.tsv" "$work/intent.txt" "$work/changed-paths.txt" "$work/bad.tsv" >/dev/null 2>&1; then
    echo 'collector accepted an intent file that did not match ai-ci state' >&2
    exit 1
fi
printf '%s\n' 'PASS	target-digest-mismatch	fail-closed'

printf '%s\n' 'task-context authority collector acceptance passes'
