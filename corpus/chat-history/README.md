# Chat-history corpus

This directory contains curated excerpts from AI-assisted project work.

## Provenance

The current public seed covers 2026-09-13 through 2026-09-19 and contains 64 records.

Files:

- `2026-09-13--16.jsonl`: mostly dated intent/state summaries recovered from durable conversation context, plus exact turns where available.
- `2026-09-17--19.jsonl`: first exact-turn-heavy supervision seed.
- `2026-09-17--19-more.jsonl`: broader project/thread coverage from the same period.

Each JSONL record may contain:

- `source_quality: "verbatim"`: the record is centered on text preserved exactly from the chat record available during corpus construction.
- `source_quality: "dated_summary"`: the surviving context supports the date, intent, constraint, or outcome, but not a complete exact transcript.
- `verbatim: true`: that individual message text is preserved exactly.
- `verbatim: false`: a compact summary of surrounding context, intent, or outcome. It is not a reconstructed quote.
- `supervision_cues`: why the exchange is useful for training or evaluating Cockswain.

Older recovered material is deliberately marked as summary rather than silently reconstructed into fake transcript text.

This is intentionally not a complete export. The repository is public, so the corpus excludes private-life conversation, credentials, secrets, private-repository content, and unrelated personal context.

The full ChatGPT Takeout path belongs in private/local evaluation data, not in this public corpus.

## Intended use

These records emphasize the recurring supervisory questions that motivated Cockswain:

- Should the primary agent keep working?
- Is it actually waiting on an external condition?
- Is human judgment or a physical/user action required?
- Is the task truly done, including exact-head evidence, cleanup, and durable tracking for deferred work?
- Did the agent preserve the user's architecture, scope, evidence boundary, and explicit exclusions?
- Did a thread expose a reusable process defect that belongs in tests, shared CI, or repository guidance?

The canonical output vocabulary is:

`CONTINUE | WAIT | HUMAN | DONE`

Do not treat a passing CI check, a merge, or an assistant statement of completion as sufficient by itself. Evaluate the durable project state and the user's stated evidence boundary.
