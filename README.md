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

## Verbatim corpus evaluation

`tests/corpus/` contains eight labeled real-history cases: two each for `CONTINUE`, `WAIT`, `HUMAN`, and `DONE`. The case files contain objective state and labels, but no copied transcript text. Each `history_record` line points to a literal record in `corpus/chat-history/`, and `bin/cockswain-corpus-cases` extracts those messages into temporary work items.

Two cases deliberately have different expected actions after history is removed. This makes history ablation test a decision boundary instead of merely testing that tokens were deleted.

Run one configured supervisor model against both history modes:

```sh
COCKSWAIN_MODEL='openai/gpt-oss-20b' \
COCKSWAIN_BASE_URL='http://127.0.0.1:8000/v1' \
COCKSWAIN_SEND_REASONING_EFFORT=1 \
bin/cockswain-corpus-eval
```

The deterministic CI test does not claim model quality. It verifies corpus provenance, action coverage, history-sensitive labels, label isolation, and with/without-history plumbing.

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
