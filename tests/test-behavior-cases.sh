#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT HUP INT TERM

stub="$work/supervisor-stub"
cat > "$stub" <<'STUB'
#!/bin/sh
set -eu

case_file=$1
jq -e '
  (has("expected_action") | not) and
  (has("expected_required_output") | not) and
  (has("expected_forbidden_output") | not)
' "$case_file" >/dev/null || {
    printf 'stub: evaluator leaked oracle fields\n' >&2
    exit 65
}

case_id=$(jq -r '.case_id' "$case_file")
action=CONTINUE
text='Continue the existing work.'
question=null

case "$case_id" in
    done-no-status-work) action=DONE; text='The verified work is complete.' ;;
    human-physical-action) action=HUMAN; text='Physical action is required.'; question='"Run the retained physical command."' ;;
    wait-worker-running) action=WAIT; text='The worker is still running.' ;;
    human-ambiguous-merge-authorization) action=HUMAN; text='Explicit merge authorization is missing.'; question='"Please provide explicit merge authorization for this exact pull request."' ;;
    continue-retain-no-clang) text='Continue the hosted cross-build without Clang on the phone.' ;;
    continue-execution-not-plan) text='Implement and test the highest-value control now.' ;;
    continue-correction-persists) text='Continue the independent DEX backend and its structural test.' ;;
    continue-qemu-language-boundary) text='Retain the QEMU pass as QEMU evidence and prepare the physical-phone command.' ;;
esac

if [ "$action" = CONTINUE ]; then
    next=$(printf '%s' "$text" | jq -Rs .)
else
    next=null
fi

printf '{"action":"%s","rationale":%s,"next_prompt":%s,"human_question":%s,"evidence_gaps":[]}\n' \
    "$action" "$(printf '%s' "$text" | jq -Rs .)" "$next" "$question"
STUB
chmod +x "$stub"

COCKSWAIN_SUPERVISOR_CMD="$stub" "$repo_dir/bin/cockswain-behavior-eval" > "$work/good.log"
for mode in with without; do
    grep -F "behavior_history_mode	$mode" "$work/good.log" >/dev/null
done
[ "$(grep -c 'total	12' "$work/good.log")" -eq 2 ]
[ "$(grep -c 'correct	12' "$work/good.log")" -eq 2 ]
[ "$(grep -c 'semantic_contract_failures	0' "$work/good.log")" -eq 2 ]

mkdir "$work/bad-case"
cp "$repo_dir/tests/behavior/continue-qemu-language-boundary.case" "$work/bad-case/"
bad_stub="$work/bad-stub"
cat > "$bad_stub" <<'BAD'
#!/bin/sh
printf '%s\n' '{"action":"CONTINUE","rationale":"QEMU passed, so it works on the phone.","next_prompt":"Record the QEMU result.","human_question":null,"evidence_gaps":[]}'
BAD
chmod +x "$bad_stub"

if COCKSWAIN_SUPERVISOR_CMD="$bad_stub" "$repo_dir/bin/cockswain-behavior-eval" "$work/bad-case" > "$work/bad.log"; then
    printf 'FAIL: forbidden evidence promotion passed semantic grading\n' >&2
    exit 1
fi
grep -F 'semantic_contract_failures	1' "$work/bad.log" >/dev/null

printf 'PASS: privacy-reduced behavior cases and output-language grading\n'
