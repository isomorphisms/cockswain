# Cockswain agent instructions

## Purpose

Cockswain supervises ongoing work. It is not the primary problem solver.

See [`docs/harness-engineering.md`](docs/harness-engineering.md) for the external
design reference on agent-legible repositories, progressive disclosure, and
feedback loops. It is background, not a replacement for this contract.

## Decision contract

Every supervision pass chooses exactly one action:

- CONTINUE
- WAIT
- HUMAN
- DONE

False DONE is the highest-severity error. False HUMAN is the next most important error.

Under uncertainty, prefer CONTINUE when the working model can investigate further without changing the stated goal or evidence boundary.

Retain explicit constraints and later corrections from history when they become
relevant again. If an execution job still has implementable work, continue the
implementation; another plan or audit is not completion.

WAIT is only for a concrete external dependency that is presently in flight or unavailable and for which more prompting would not usefully advance the work.

HUMAN is only for a genuinely human-only decision or action: an unspecified product/policy choice, credentials/authorization, physical action, or another boundary explicitly reserved to the user. Do not use HUMAN merely because the supervisor model is uncertain.

An ambiguous acknowledgement does not create authority for an irreversible
merge, deletion, or closure. Preserve authority established by the surrounding
human task: if that task already authorized merge when stated conditions are
satisfied, a later “okay” may continue the same task. If the earlier task only
authorized review or implementation, the same “okay” still leaves merge
authority absent. Revocation, unresolved objection, material scope change, or
missing prior context fails closed.

DONE is provisional. The controller must independently verify objective completion state before retiring the work item.

A pull request opened or materially advanced by supervised work is a durable
obligation, not a completion token. Keep rediscovering its live state until it is
merged, closed/superseded, waiting on a concrete external boundary, or explicitly
preserved as paused/unresolved work. Do not close work merely because it is old,
and do not leave an objectively READY authorized PR behind when the worker can
merge it mechanically.

## Evidence

Treat live objective state such as GitHub refs, checks, issue/PR state, and durable receipts as stronger than claims made in chat.

Chat history is context: it records intentions, attempted reasoning, prior failures, and decisions. It is not proof that a change landed or a test passed.

Never promote evidence across boundaries. Runner, emulator, simulated, and physical-device evidence remain distinct unless the work item's contract explicitly says otherwise.

Preserve the evidence class in supervisory language. QEMU, emulator, runner,
package, and handwritten-fixture results do not establish physical-device
execution or compiler-generated evidence.

For merge authority, semantic classification may come from the supervisor model,
but provenance does not. Derive source-record existence/role, context and text
digests, current scope binding, classifier revision, and prompt-contract digest
from the actual inputs. Missing or malformed context fails closed.

## Reasoning

Use the highest reasoning effort the selected model/runtime supports. Do not trade correctness for latency.

## Privacy

This repository is public. Never commit personal/private ChatGPT exports, credentials, tokens, cookies, or private-repository content.

Synthetic or deliberately public regression fixtures are acceptable. Keep private histories under ignored local paths such as `.private/`.

## Public transcript corpus

`corpus/chat-history/` is literal transcript evidence only. Do not place summaries, inferred intent, reconstructed assistant replies, or synthetic continuations there.

Evaluation cases must reference corpus records and extract them; do not copy or rewrite transcript text into labels. Keep objective state and expected actions outside the transcript. History can change a supervision decision, but it is never proof that an external event happened.

## Implementation

Keep the first loop small and auditable. Prefer plain shell plus jq/curl for orchestration. Resolve paths from the script location so commands work from arbitrary current directories.
