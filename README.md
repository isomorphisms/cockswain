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
Contextual merge cases cover merge-if-clean followed by “okay,” review-only
followed by the same acknowledgement, revocation, material scope change,
repository-state refresh, long context, explicit human correction, and missing
prior context. Turn checkpoints exercise the decision before and after the
authority-changing record instead of grading only the final thread.

`bin/cockswain-authority-receipt DECISION TARGET OUTPUT` renders the private
conversation classifier's result as the public-safe plain-text receipt consumed
by ai-ci. It preserves the original human source record, context and text
digests, classifier revision/contract, authorized task scope, revocation, and
objection state. It emits no GitHub head, base, check, diff, or evidence claim;
those remain ai-ci's boundary.

`bin/cockswain-authority-collect CONTEXT_REF CONTEXT_TSV STATE_TSV INTENT_FILE
CHANGED_PATHS OUTPUT` is the ordinary live path from recovered private task
context to that receipt. `CONTEXT_TSV` has the plain-text header
`record_id<TAB>role<TAB>text`. Cockswain validates the current ai-ci intent and
changed-path digests, asks the configured classifier only for semantic fields,
then derives the authority text hash, whole-context hash, latest record, exact
classifier revision, and prompt-contract hash itself. A nominated source must
exist in the recovered context and be human; acknowledgement-only sources and
assistant sources cannot authorize a merge. Missing context emits `UNKNOWN`
without reconstructing an earlier task. Private message text is not copied into
the public receipt.

Merge supervision is deterministic when ai-ci has already produced its blocker
table. `bin/cockswain-merge-state MERGE-STATE.tsv` maps mechanical work to
`CONTINUE`, a sole running-CI blocker to `WAIT`, and a sole physical or authority
boundary to `HUMAN`. `READY` means `CONTINUE` with the recorded merge action;
the work is not `DONE` until refreshed objective state says the PR actually
merged. If a physical blocker and a mechanical blocker coexist, Cockswain does
the mechanical work first instead of summoning the human prematurely.
Draft routing follows the declared promotion action: `mark-ready` continues,
`wait`/`hold-draft` waits, and an unrecognized owner decision escalates. A green
draft therefore does not remain stuck after its promotion condition is met,
while an intentional evaluation draft is not churned as repair work.

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