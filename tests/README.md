# Cockswain tests

Cockswain stays paused until both kinds of acceptance evidence below are green.

## Dispatch contract

`tests/test-dispatch.sh` is deterministic. It defines the controller boundary that matters most:

- `CONTINUE` sends the supervisor's next prompt to the existing worker/ChatGPT adapter.
- `WAIT` sends no new work.
- `HUMAN` sends no worker prompt and surfaces the human-only question.
- `DONE` sends no new work.
- The dispatcher does not itself become a GitHub worker.

This test is intentionally red until `bin/cockswain-dispatch` exists. Do not resume the recurring Cockswain job merely because the supervisor model classifies synthetic cases correctly.

## Supervisor behavior

The cases under `tests/behavior/` are plain tab-delimited files, not hand-authored JSON. `bin/cockswain-behavior-eval` converts them to the current JSON work-item boundary in a temporary directory and runs the ordinary evaluator.

The public behavior suite covers the first automated-loop failure modes:

- keep an existing worker thread moving instead of inventing a new bookkeeping work item;
- do not pile another prompt onto a worker that is already running;
- investigate resolvable uncertainty instead of prematurely asking a human;
- ask for a human only at a genuinely human-only physical boundary;
- do not call emulator/runner evidence physical-device evidence;
- do not trust stale-head or chat-only completion claims;
- stop when the real task is complete instead of creating a status-only PR or issue.

Run the behavior suite against the intended supervisor endpoint:

```sh
COCKSWAIN_MODEL='openai/gpt-oss-20b' \
COCKSWAIN_BASE_URL='http://127.0.0.1:8000/v1' \
COCKSWAIN_SEND_REASONING_EFFORT=1 \
bin/cockswain-behavior-eval
```

By default every behavior case is run once with history and once with history removed.

Synthetic cases are necessary but not sufficient. Promotion still requires the private recent-history matrix described in `docs/model-evaluation.md`, with independently checked objective state and labels.
