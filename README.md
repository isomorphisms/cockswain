# Cockswain

Cockswain is a supervisory loop for ongoing AI-assisted work. It does not try to replace the problem-solving model. It decides what should happen next:

- `CONTINUE`: send the next useful prompt to the working ChatGPT thread.
- `WAIT`: an external result is genuinely pending.
- `HUMAN`: progress requires a human decision or action.
- `DONE`: the stated goal appears satisfied and is ready for independent completion verification.

The main failure to avoid is false `DONE`. The next is false `HUMAN`: Cockswain should not summon a person merely because the supervisor model is uncertain.

## First executable boundary

The initial harness compares local/open-weight supervisor models against labeled work states containing:

- the work goal;
- GitHub or other objective state;
- unresolved items and completion conditions;
- recent chat history.

It does not drive the ChatGPT UI yet. Browser/UI automation is a later adapter once the supervisor decision boundary is reliable.

## Candidate models

See `models/models.json`. The initial comparison set is:

- `openai/gpt-oss-20b`
- `Qwen/Qwen3-4B-Instruct-2507`
- `mistralai/Ministral-3-8B-Instruct-2512`
- `microsoft/Phi-4-reasoning-plus`

Reasoning should be as deep as the model/runtime permits. Cockswain does not optimize for latency.

## Run one case

Cockswain expects an OpenAI-compatible local chat-completions endpoint.

```sh
COCKSWAIN_MODEL='openai/gpt-oss-20b' \
COCKSWAIN_BASE_URL='http://127.0.0.1:8000/v1' \
bin/cockswain-supervise tests/cases/continue.json
```

For runtimes that accept the OpenAI `reasoning_effort` field, set:

```sh
COCKSWAIN_SEND_REASONING_EFFORT=1
```

The value is always `high`.

## Evaluate a model

```sh
COCKSWAIN_MODEL='openai/gpt-oss-20b' \
COCKSWAIN_BASE_URL='http://127.0.0.1:8000/v1' \
COCKSWAIN_SEND_REASONING_EFFORT=1 \
bin/cockswain-eval tests/cases
```

The report calls out false `DONE` and false `HUMAN` separately. Set `COCKSWAIN_HISTORY_MODE=without` to run the same cases after removing the transcript and transcript-derived `source.history` metadata in a temporary copy.

## Recent private history

Normalize a ChatGPT export locally:

```sh
umask 077
mkdir -p .private
bin/import-chatgpt-export ~/Downloads/conversations.json > .private/chat-history.json
```

List the most recently updated active branches without creating repository files:

```sh
sh bin/cockswain-recent-cases list .private/chat-history.json 25
```

Create `.private/recent-cases.json` with independently labeled work-state metadata. The transcript is joined by `conversation_id`; it is not used to invent objective state or the expected action:

```json
{
  "cases": [
    {
      "conversation_id": "CONVERSATION_ID_FROM_LIST",
      "case_id": "short-local-case-id",
      "expected_action": "CONTINUE",
      "goal": "The goal being supervised.",
      "state": {"objective": "current independently checked state"},
      "unresolved": ["What remains."],
      "done_when": ["Concrete completion condition."]
    }
  ]
}
```

Build private evaluation work items with the latest 12 active-branch messages by default:

```sh
sh bin/cockswain-recent-cases build \
  .private/chat-history.json \
  .private/recent-cases.json \
  .private/cases/recent
```

Set `COCKSWAIN_HISTORY_MESSAGES` to change the default window, or set `history_messages` on an individual case. Generated history-bearing cases inside this checkout are refused unless the output directory is under `.private/`.

## Model matrix and history ablation

With an OpenAI-compatible local endpoint able to serve the model ids in `models/models.json`:

```sh
COCKSWAIN_BASE_URL='http://127.0.0.1:8000/v1' \
COCKSWAIN_RUN_ID='recent-history-1' \
sh bin/cockswain-eval-matrix .private/cases/recent
```

Each model is run twice: once with the private recent history and once with history removed. Per-run logs, `summary.tsv`, and `history-ablation.tsv` stay under ignored `eval/results/` by default.

The importer follows each exported conversation's active/current branch when that information is present and preserves message ids and parent ids. See `docs/chat-history.md` and `docs/model-evaluation.md`.

Private or personal chat history, case specs, generated cases, and evaluation logs must never be committed to this public repository.
