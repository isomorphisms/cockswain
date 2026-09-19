# Cockswain agent instructions

## Purpose

Cockswain supervises ongoing work. It is not the primary problem solver.

## Decision contract

Every supervision pass chooses exactly one action:

- CONTINUE
- WAIT
- HUMAN
- DONE

False DONE is the highest-severity error. False HUMAN is the next most important error.

Under uncertainty, prefer CONTINUE when the working model can investigate further without changing the stated goal or evidence boundary.

WAIT is only for a concrete external dependency that is presently in flight or unavailable and for which more prompting would not usefully advance the work.

HUMAN is only for a genuinely human-only decision or action: an unspecified product/policy choice, credentials/authorization, physical action, or another boundary explicitly reserved to the user. Do not use HUMAN merely because the supervisor model is uncertain.

DONE is provisional. The controller must independently verify objective completion state before retiring the work item.

## Evidence

Treat live objective state such as GitHub refs, checks, issue/PR state, and durable receipts as stronger than claims made in chat.

Chat history is context: it records intentions, attempted reasoning, prior failures, and decisions. It is not proof that a change landed or a test passed.

Never promote evidence across boundaries. Runner, emulator, simulated, and physical-device evidence remain distinct unless the work item's contract explicitly says otherwise.

## Reasoning

Use the highest reasoning effort the selected model/runtime supports. Do not trade correctness for latency.

## Privacy

This repository is public. Never commit personal/private ChatGPT exports, credentials, tokens, cookies, or private-repository content.

Synthetic or deliberately public regression fixtures are acceptable. Keep private histories under ignored local paths such as `.private/`.

## Implementation

Keep the first loop small and auditable. Prefer plain shell plus jq/curl for orchestration. Resolve paths from the script location so commands work from arbitrary current directories.
