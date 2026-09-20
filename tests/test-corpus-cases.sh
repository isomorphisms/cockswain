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
mkdir -p "$work/base" "$work/prefixes" "$work/all"

"$repo_dir/bin/cockswain-corpus-cases" "$repo_dir/tests/corpus" "$work/base"
"$repo_dir/bin/cockswain-corpus-prefixes" "$repo_dir/tests/corpus" "$work/prefixes"

base_count=$(find "$work/base" -type f -name '*.json' | wc -l | tr -d ' ')
[ "$base_count" -eq 10 ] || {
    printf 'FAIL: expected 10 base corpus cases, got %s\n' "$base_count" >&2
    exit 1
}

prefix_count=$(find "$work/prefixes" -type f -name '*.json' | wc -l | tr -d ' ')
[ "$prefix_count" -eq 10 ] || {
    printf 'FAIL: expected 10 turn-prefix checkpoints, got %s\n' "$prefix_count" >&2
    exit 1
}

cp "$work/base"/*.json "$work/all/"
cp "$work/prefixes"/*.json "$work/all/"

for action in CONTINUE WAIT HUMAN DONE; do
    with_count=$(jq -s --arg action "$action" '[.[] | select(.expected_action_with_history == $action)] | length' "$work"/base/*.json)
    without_count=$(jq -s --arg action "$action" '[.[] | select(.expected_action_without_history == $action)] | length' "$work"/base/*.json)
    [ "$with_count" -ge 2 ] || {
        printf 'FAIL: with-history base corpus has fewer than two %s cases\n' "$action" >&2
        exit 1
    }
    [ "$without_count" -ge 2 ] || {
        printf 'FAIL: without-history base corpus has fewer than two %s cases\n' "$action" >&2
        exit 1
    }
done

sensitive=$(jq -s '[.[] | select(.expected_action_with_history != .expected_action_without_history)] | length' "$work"/base/*.json)
[ "$sensitive" -ge 3 ] || {
    printf 'FAIL: expected at least three history-sensitive base cases\n' >&2
    exit 1
}

two_sided=$(jq -s '[.[] | select(( [.chat_history[].role] | index("user")) != null and ([.chat_history[].role] | index("assistant")) != null)] | length' "$work"/base/*.json)
[ "$two_sided" -ge 2 ] || {
    printf 'FAIL: expected at least two two-sided user/assistant cases\n' >&2
    exit 1
}

for case_id in continue-cockswain-no-bookkeeping human-arm-thumb-reserved; do
    for turn in 1 2 3; do
        path="$work/prefixes/$case_id--turn-$turn.json"
        [ -f "$path" ] || {
            printf 'FAIL: missing prefix checkpoint %s turn %s\n' "$case_id" "$turn" >&2
            exit 1
        }
    done
done
for turn in 2 4 6 9; do
    path="$work/prefixes/continue-verbatim-corpus-correction--turn-$turn.json"
    [ -f "$path" ] || {
        printf 'FAIL: missing two-sided corpus-correction prefix turn %s\n' "$turn" >&2
        exit 1
    }
done

for path in "$work"/prefixes/*.json; do
    turn=$(printf '%s' "$path" | sed 's/.*--turn-//; s/.json$//')
    [ "$(jq -r '.chat_history | length' "$path")" -eq "$turn" ] || {
        printf 'FAIL: %s has wrong history length\n' "$path" >&2
        exit 1
    }
    [ "$(jq -r '.source.history.records | length' "$path")" -eq "$turn" ] || {
        printf 'FAIL: %s has wrong provenance length\n' "$path" >&2
        exit 1
    }
done

if grep -R -n '^history[[:space:]]' "$repo_dir/tests/corpus" >/dev/null 2>&1; then
    printf 'FAIL: corpus labels must reference history_record entries, not copied transcript text\n' >&2
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
    continue-cockswain-no-bookkeeping*:0) action=HUMAN ;;
    continue-cockswain-no-bookkeeping*:*) action=CONTINUE ;;
    continue-verbatim-corpus-correction*:0) action=HUMAN ;;
    continue-verbatim-corpus-correction*:*) action=CONTINUE ;;
    human-arm-thumb-reserved*:0) action=CONTINUE ;;
    human-arm-thumb-reserved*:*) action=HUMAN ;;
    continue-dont-give-up:*|continue-batch-physical-failures:*) action=CONTINUE ;;
    wait-grease-current-head-ci:*|wait-merge-ci:*) action=WAIT ;;
    human-tablet-physical:*) action=HUMAN ;;
    done-close-thread:*|done-oils-thread:*) action=DONE ;;
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
        "$repo_dir/bin/cockswain-eval" "$work/all" > "$log"
    grep -F 'total	20' "$log" >/dev/null
    grep -F 'correct	20' "$log" >/dev/null
    grep -F 'false_done	0' "$log" >/dev/null
    grep -F 'false_human	0' "$log" >/dev/null
    grep -F 'invalid_output	0' "$log" >/dev/null
done

if ! COCKSWAIN_SUPERVISOR_CMD="$stub" "$repo_dir/bin/cockswain-ablation" "$work/all" > "$work/paired.tsv"; then
    printf 'FAIL: paired ablation runner failed\n' >&2
    cat "$work/paired.tsv" >&2
    exit 1
fi
cat "$work/paired.tsv"
grep -F 'total	20' "$work/paired.tsv" >/dev/null
grep -F 'required_action_changes_total	13' "$work/paired.tsv" >/dev/null
grep -F 'required_action_changes_correct	13' "$work/paired.tsv" >/dev/null
grep -F 'missed_required_action_changes	0' "$work/paired.tsv" >/dev/null
grep -F 'stable_action_total	7' "$work/paired.tsv" >/dev/null
grep -F 'stable_action_correct	7' "$work/paired.tsv" >/dev/null
grep -F 'spurious_action_changes	0' "$work/paired.tsv" >/dev/null

printf 'PASS: verbatim corpus, two-sided history, turn prefixes, and paired ablation contract\n'
