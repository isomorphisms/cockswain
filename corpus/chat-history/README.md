# Chat-history corpus

This directory contains curated excerpts from AI-assisted project work.

## Provenance

The initial seed covers 2026-09-17 through 2026-09-19.

Each JSONL record may contain:

- `verbatim: true`: text preserved from the chat record available during corpus construction.
- `verbatim: false`: a compact summary of surrounding context or outcome. It is not a reconstructed quote.
- `supervision_cues`: why the exchange is useful for training or evaluating Cockswain.

This is intentionally not a complete export. The repository is public, so the seed excludes private-life conversation, credentials, secrets, and unrelated personal context.

## Intended use

These records emphasize the recurring supervisory questions that motivated Cockswain:

- Should the primary agent keep working?
- Is it actually waiting on an external condition?
- Is human judgment or a physical/user action required?
- Is the task truly done, including exact-head evidence, cleanup, and durable tracking for deferred work?

The canonical output vocabulary is:

`CONTINUE | WAIT | HUMAN | DONE`

Do not treat a passing CI check, a merge, or an assistant statement of completion as sufficient by itself. Evaluate the durable project state and the user's stated evidence boundary.
