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
bin/cockswain-eval
```

The report calls out false `DONE` and false `HUMAN` separately.

## Chat history

A ChatGPT data export can be normalized locally without committing it:

```sh
mkdir -p .private
bin/import-chatgpt-export ~/Downloads/conversations.json > .private/chat-history.json
```

The importer follows each exported conversation's active/current branch when that information is present and preserves message ids and parent ids. See `docs/chat-history.md`.

Private or personal chat history must never be committed to this public repository.
