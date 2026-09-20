#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)
dispatch="$repo_dir/bin/cockswain-dispatch"

[ -x "$dispatch" ] || {
    printf 'FAIL: bin/cockswain-dispatch is not implemented yet\n' >&2
    exit 1
}

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT HUP INT TERM
worker_log="$work/worker.log"
worker="$work/worker"

cat > "$worker" <<'WORKER'
#!/bin/sh
set -eu
: "${COCKSWAIN_TEST_WORKER_LOG:?}"
printf '%s\n' "$1" >> "$COCKSWAIN_TEST_WORKER_LOG"
WORKER
chmod +x "$worker"

cat > "$work/continue.json" <<'JSON'
{"action":"CONTINUE","rationale":"Existing worker can advance the task.","next_prompt":"Inspect the existing work and continue it.","human_question":null,"evidence_gaps":[]}
JSON
COCKSWAIN_WORKER_CMD="$worker" COCKSWAIN_TEST_WORKER_LOG="$worker_log" \
    "$dispatch" "$work/continue.json" > "$work/continue.out"
[ "$(cat "$worker_log")" = 'Inspect the existing work and continue it.' ] || {
    printf 'FAIL: CONTINUE was not dispatched to the worker unchanged\n' >&2
    exit 1
}

: > "$worker_log"
for action in WAIT DONE; do
    lower=$(printf '%s' "$action" | tr 'A-Z' 'a-z')
    cat > "$work/$lower.json" <<JSON
{"action":"$action","rationale":"No worker prompt should be sent.","next_prompt":null,"human_question":null,"evidence_gaps":[]}
JSON
    COCKSWAIN_WORKER_CMD="$worker" COCKSWAIN_TEST_WORKER_LOG="$worker_log" \
        "$dispatch" "$work/$lower.json" > "$work/$lower.out"
done
[ ! -s "$worker_log" ] || {
    printf 'FAIL: WAIT or DONE dispatched work to the worker\n' >&2
    exit 1
}

cat > "$work/human.json" <<'JSON'
{"action":"HUMAN","rationale":"A physical action is required.","next_prompt":null,"human_question":"Run the retained tablet probe and return its receipt.","evidence_gaps":["physical tablet receipt"]}
JSON
COCKSWAIN_WORKER_CMD="$worker" COCKSWAIN_TEST_WORKER_LOG="$worker_log" \
    "$dispatch" "$work/human.json" > "$work/human.out"
[ ! -s "$worker_log" ] || {
    printf 'FAIL: HUMAN dispatched work to the worker\n' >&2
    exit 1
}
grep -F 'Run the retained tablet probe and return its receipt.' "$work/human.out" >/dev/null || {
    printf 'FAIL: HUMAN question was not surfaced\n' >&2
    exit 1
}

printf 'PASS: dispatch contract\n'
