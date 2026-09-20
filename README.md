# Cockswain

Cockswain supervises ongoing AI-assisted work and chooses one next state:

- `CONTINUE`: useful work remains and the existing worker can advance it.
- `WAIT`: a concrete external result is in flight and more prompting would not help.
- `HUMAN`: a genuinely human-only decision or action is required.
- `DONE`: the stated goal appears satisfied and is ready for independent completion verification.

False `DONE` is the highest-severity error. False `HUMAN` is next: uncertainty by itself is not a reason to summon the user.

## Current boundary

This repository contains the first executable supervisor/evaluation harness. It does not resume the retired Cockswain v1 bookkeeping queue and it does not yet drive the ChatGPT UI.

The public chat corpus under `corpus/chat-history/` is strictly verbatim. Summaries and reconstructed context live under `corpus/derived-context/` and do not count as transcript evidence.

## OpenAI developer API mirror

The complete OpenAPI repository published by `openai/openai-openapi` is pinned under `vendor/openai-api/upstream`. `vendor/openai-api/UPSTREAM` records the exact source revision; `sh bin/update-openai-api-mirror` advances the pinned mirror deliberately.

## Verbatim corpus evaluation

Current `main` contains 148 literal public-safe messages: 88 user messages and 60 assistant messages.

`tests/corpus/` contains ten independently labeled real-history base cases. Every action has at least two base cases. Two cases explicitly combine literal user and assistant messages from the same project thread.

Three cases are history-sensitive: their correct supervisory action changes when the conversation policy/context is ablated. Multi-message cases may also carry `checkpoint` rows. `bin/cockswain-corpus-prefixes` expands those into explicit turn prefixes; the current suite adds ten prefix work states, for 20 public real-history evaluations total.

Run a configured supervisor over the base cases and turn prefixes:

```sh
COCKSWAIN_MODEL='openai/gpt-oss-20b' \
COCKSWAIN_BASE_URL='http://127.0.0.1:8000/v1' \
COCKSWAIN_SEND_REASONING_EFFORT=1 \
bin/cockswain-corpus-eval
```

The deterministic CI test does not claim model quality. It verifies corpus provenance, user/assistant role preservation, action coverage, prefix construction, history-sensitive labels, oracle-label isolation, and with/without-history plumbing.

Privacy-reduced cases under `tests/behavior/` cover interpretive failures that
repository checks cannot decide. Their contract grades both the supervisory
action and required/forbidden language, so preserving a QEMU evidence label or
a retained no-Clang constraint cannot pass on the action label alone.

## Candidate models

The initial matrix in `models/models.json` is:

- `openai/gpt-oss-20b`
- `Qwen/Qwen3-4B-Instruct-2507`
- `mistralai/Ministral-3-8B-Instruct-2512`
- `microsoft/Phi-4-reasoning-plus`

Reasoning should be as deep as the runtime permits; latency is not an optimization target.

## Private recent history

A full ChatGPT export remains local-only. Normalize it under `.private/` with `bin/import-chatgpt-export`, then use `bin/cockswain-recent-cases` to join selected active branches to independently checked objective state and labels. Private transcripts, generated cases, credentials, and detailed local logs must not be committed.

See `docs/chat-history.md` and `docs/model-evaluation.md` for the evidence and promotion boundaries.
