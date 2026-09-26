# Harness engineering and agent-legible repositories

Source: Ryan Lopopolo, “Harness engineering: leveraging Codex in an agent-first world,” OpenAI, 2026-02-11.
https://openai.com/index/harness-engineering/

This is a summary and design reference. It does not change Cockswain's current `CONTINUE / WAIT / HUMAN / DONE` contract, evidence boundaries, privacy rules, or merge-authority rules.

## What OpenAI reports

OpenAI describes an internal product built under an unusual constraint: humans did not directly write the repository's code. Codex produced application code, tests, CI, documentation, observability support, and repository tooling. The article reports roughly a million lines of code and about 1,500 pull requests over five months.

The interesting change is the human role. Instead of spending most effort entering code, the team concentrated on specifying intent, improving the environment available to agents, exposing objective state, and building feedback loops.

## Main lessons

### Fix missing capabilities rather than repeatedly re-prompting

When an agent cannot complete a task, the durable repair is often a missing tool, unclear interface, inaccessible state, weak test, absent constraint, or undiscoverable piece of knowledge. Rephrasing the same instruction does not repair those system defects.

### Make the running system visible to the agent

The article's agents can launch isolated application instances and inspect browser state, logs, metrics, and traces. That gives them a way to reproduce failures and validate results directly.

Source code is therefore only part of the context an effective worker needs. Objective runtime evidence should be available through a bounded, inspectable interface.

### Make the repository the durable source of working knowledge

Architecture, operating rules, plans, decisions, and known debt should be versioned and discoverable beside the code. Information that exists only in chat, private documents, or someone's memory is unavailable to a later unattended run unless it is deliberately recovered.

### Keep the entry point small

OpenAI reports that a giant `AGENTS.md` became noisy, stale, difficult to verify, and expensive in context. Their replacement is a short map into structured documentation.

This is progressive disclosure: give the worker enough information to find the relevant source of truth, not every fact that has ever mattered to the project.

### Optimize the repository for legibility

Predictable structure, explicit boundaries, stable abstractions, schemas, and inspectable behavior let an agent reconstruct what the system means instead of guessing from local patterns.

This is close to onboarding a new maintainer: the important domain model and constraints should be recoverable from the repository itself.

### Encode important rules mechanically

The article describes structural tests and custom linters for architectural boundaries and recurring engineering rules. Documentation explains why; executable checks stop drift.

A useful principle is to enforce invariants centrally while allowing local freedom where the exact implementation does not matter.

### Autonomy depends on feedback

An agent can drive longer tasks only when it can inspect the initial state, reproduce the problem, change the system, test the result, process review feedback, repair failures, and know what requires human judgment.

That loop is more important than nominal task length.

### Expect entropy and clean it continuously

Agents imitate patterns already present in a repository, including weak or obsolete ones. OpenAI describes recurring cleanup work that finds drift and converts repeated human corrections into durable rules.

Old plans, contradictory docs, duplicated mechanisms, and misleading examples therefore affect future behavior even when they are not executed directly.

### Their fast-merge policy is not a universal rule

The article's team accepts relatively light merge blocking because their particular environment has very high automated throughput and cheap correction. Cockswain must not generalize that into automatic merge authority.

Current authority, evidence, blocker, and independent completion rules remain controlling.

## Relevance to Cockswain

The article gives a useful frame for supervision:

- a worker that repeatedly lacks information may need a repository capability added, not another increasingly elaborate prompt;
- repository-local, versioned state is stronger operational context than a remembered chat claim;
- missing context should remain missing rather than being reconstructed plausibly;
- Cockswain should distinguish “the worker can continue by discovering or improving the environment” from a genuine `HUMAN` boundary;
- `DONE` should continue to require independent objective verification rather than a worker's narrative assertion;
- recurring supervisory corrections are candidates for tests, deterministic classifiers, or repository rules;
- a supervisor should prefer bounded pointers to authoritative documents over injecting a large undifferentiated history into every run.

A possible future evaluation target is repository legibility: given only the normal entry point, can a worker locate the authoritative build, test, acceptance, architecture, active-plan, and evidence paths without private conversation context? This note records the question; it does not define a new Cockswain action or acceptance gate.

## Limits of the article

The experiment is young, uses a particular internal product and tooling stack, and does not establish how a mostly agent-generated codebase behaves over many years. The authors explicitly leave long-term architectural coherence and the best placement of human judgment unresolved.

The transferable result is narrower: substantial agent work becomes more reliable when the surrounding repository and runtime are designed as an inspectable system with durable knowledge, mechanical constraints, and strong feedback loops.
