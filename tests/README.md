# Cockswain tests

The evaluation harness and the unattended controller have separate promotion boundaries.

## Verbatim corpus contract

`tests/test-corpus-cases.sh` is deterministic and runs in CI. It verifies eight real-history cases built from `corpus/chat-history/`:

- two CONTINUE cases;
- two WAIT cases;
- two HUMAN cases;
- two DONE cases.

It also requires at least two multi-record history chunks and at least two cases whose expected action changes under history ablation. A deterministic supervisor stub checks that the evaluator removes oracle labels before invocation and removes both transcript content and transcript provenance in without-history mode.

This test proves the harness plumbing and corpus provenance. It does not claim that an open-weight model passes the corpus.

## Live supervisor behavior

Run the public corpus against a configured endpoint with:

```sh
COCKSWAIN_MODEL='openai/gpt-oss-20b' \
COCKSWAIN_BASE_URL='http://127.0.0.1:8000/v1' \
COCKSWAIN_SEND_REASONING_EFFORT=1 \
bin/cockswain-corpus-eval
```

The older synthetic cases under `tests/behavior/` remain useful for targeted failure modes.
They are privacy-reduced rather than transcript evidence. Cases may declare
`required_output` and `forbidden_output` rows; the evaluator removes those
oracle fields before model invocation and grades the complete returned
rationale/prompt/question/evidence text. Current cases cover retained
constraints, ambiguous merge authorization, execution-versus-planning,
correction persistence, and QEMU-versus-physical language.

## Dispatch contract

`tests/test-dispatch.sh` defines the controller boundary:

- CONTINUE sends the next prompt to the existing worker;
- WAIT sends no new work;
- HUMAN sends no worker prompt and surfaces the human-only question;
- DONE sends no new work.

That test remains intentionally red until `bin/cockswain-dispatch` exists. The recurring Cockswain job must stay paused until the dispatch boundary and a selected live supervisor model are accepted.
