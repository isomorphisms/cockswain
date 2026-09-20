#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)

command -v jq >/dev/null 2>&1 || {
    printf 'FAIL: jq is required\n' >&2
    exit 1
}

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work/cases"

"$repo_dir/bin/cockswain-corpus-cases" "$repo_dir/tests/corpus" "$work/cases"

count=$(find "$work/cases" -type f -name '*.json' | wc -l | tr -d ' ')
[ "$count" -eq 8 ] || {
    printf 'FAIL: expected 8 corpus cases, got %s\n' "$count" >&2
    exit 1
}

for action in CONTINUE WAIT HUMAN DONE; do
    with_count=$(jq -s --arg action "$action" '[.[] | select(.expected_action_with_history == $action)] | length' "$work"/cases/*.json)
    without_count=$(jq -s --arg action "$action" '[.[] | select(.expected_action_without_history == $action)] | length' "$work"/cases/*.json)
    [ "$with_count" -ge 2 ] || {
        printf 'FAIL: with-history corpus has fewer than two %s cases\n' "$action" >&2
        exit 1
    }
    [ "$without_count" -ge 2 ] || {
        printf 'FAIL: without-history corpus has fewer than two %s cases\n' "$action" >&2
        exit 1
    }
done

sensitive=$(jq -s '[.[] | select(.expected_action_with_history != .expected_action_without_history)] | length' "$work"/cases/*.json)
[ "$sensitive" -ge 2 ] || {
    printf 'FAIL: expected at least two history-sensitive cases\n' >&2
    exit 1
}

chunked=$(jq -s '[.[] | select((.source.history.records | length) >= 2)] | length' "$work"/cases/*.json)
[ "$chunked" -ge 2 ] || {
    printf 'FAIL: expected at least two multi-record history chunks\n' >&2
    exit 1
}

if grep -R -n '^history[[:space:]]' "$repo_dir/tests/corpus" >/dev/null 2>&1; then
    printf 'FAIL: corpus case labels must reference history_record entries, not copied transcript text\n' >&2
    exit 1
fi

stub="$work/supervisor-stub"
cat > "$stub" <<'STUB'
#!/bin/sh
set -eu

case_file=$1
jq -e '
  (has("expected_action") | not) and
  (has("expected_action_with_history") | not) and
  (has("expected_action_without_history") | not)
' "$case_file" >/dev/null || {
    printf 'stub: evaluator leaked expected labels to supervisor\n' >&2
    exit 65
}

case_id=$(jq -r '.case_id' "$case_file")
history_count=$(jq -r '.chat_history | length' "$case_file")

if [ "$history_count" -eq 0 ]; then
    jq -e '(.source.history? == null)' "$case_file" >/dev/null || {
        printf 'stub: without-history case retained source.history\n' >&2
        exit 65
    }
else
    jq -e '(.source.history.kind == "public_verbatim_corpus")' "$case_file" >/dev/null || {
        printf 'stub: with-history case lost corpus provenance\n' >&2
        exit 65
    }
fi

case "$case_id:$history_count" in
    continue-cockswain-no-bookkeeping:0) action=HUMAN ;;
    continue-cockswain-no-bookkeeping:*) action=CONTINUE ;;
    human-arm-thumb-reserved:0) action=CONTINUE ;;
    human-arm-thumb-reserved:*) action=HUMAN ;;
    continue-dont-give-up:*) action=CONTINUE ;;
    wait-grease-current-head-ci:*) action=WAIT ;;
    wait-merge-ci:*) action=WAIT ;;
    human-tablet-physical:*) action=HUMAN ;;
    done-close-thread:*) action=DONE ;;
    done-oils-thread:*) action=DONE ;;
    *)
        printf 'stub: unknown case %s\n' "$case_id" >&2
        exit 65
        ;;
esac

case "$action" in
    CONTINUE)
        next_prompt='"Continue the existing work."'
        human_question=null
        ;;
    HUMAN)
        next_prompt=null
        human_question='"Human input is required."'
        ;;
    WAIT|DONE)
        next_prompt=null
        human_question=null
        ;;
esac

printf '{"action":"%s","rationale":"deterministic evaluator plumbing test","next_prompt":%s,"human_question":%s,"evidence_gaps":[]}\n' \
    "$action" "$next_prompt" "$human_question"
STUB
chmod +x "$stub"

for mode in with without; do
    log="$work/$mode.log"
    COCKSWAIN_SUPERVISOR_CMD="$stub" COCKSWAIN_HISTORY_MODE="$mode" \
        "$repo_dir/bin/cockswain-eval" "$work/cases" > "$log"
    grep -F 'total	8' "$log" >/dev/null
    grep -F 'correct	8' "$log" >/dev/null
    grep -F 'false_done	0' "$log" >/dev/null
    grep -F 'false_human	0' "$log" >/dev/null
    grep -F 'invalid_output	0' "$log" >/dev/null
done

printf 'PASS: verbatim corpus coverage and history ablation contract\n'
