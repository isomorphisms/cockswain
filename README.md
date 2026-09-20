# Cockswain

Cockswain supervises ongoing AI-assisted work and decides whether to continue, wait, involve a human, or verify completion.

Canonical supervisory states:

- `CONTINUE` — useful work remains and can proceed without human intervention.
- `WAIT` — the next useful step depends on an external condition or still-running work.
- `HUMAN` — human judgment, a credential, a physical action, or another genuinely human-only step is required.
- `DONE` — the stated work is complete, including required cleanup and durable tracking for anything deferred.

## OpenAI developer API mirror

The complete OpenAPI repository published by `openai/openai-openapi` is pinned
under `vendor/openai-api/upstream`. It contains the machine-readable OpenAI
REST API contract in YAML and JSON. `vendor/openai-api/UPSTREAM` records the
exact source revision; `sh bin/update-openai-api-mirror` advances the pinned
mirror deliberately.

## Chat-history corpus

The first curated seed is in `corpus/chat-history/2026-09-17--19.jsonl`.

This repository is public. Commit project/workflow history that is useful for supervising AI-assisted work, but do not commit personal/private chat history, credentials, secrets, or incidental personal conversation.

Verbatim excerpts and summarized context must be marked distinctly. Reconstructed text must never be presented as a verbatim transcript.
