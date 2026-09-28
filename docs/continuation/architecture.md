# Recovered architecture and live-state inspection

All local source findings below refer to Cockswain
`023b9395d477a4986e858e7a2196ea584653f449` and AICI
`b3af13b3ab2bac9dd7c72bf9dd855ed5a17609b5`, unless a different revision is named.
Git clones, repository tree, branch listing, open PR/issue searches, and selected
Actions jobs/logs were inspected on 2026-09-28. This is not a continuing watch.

## What actually exists

| Surface | Implemented behavior | Important limit |
| --- | --- | --- |
| `AGENTS.md`, `docs/contract.md`, `prompts/supervisor.md` | Four actions; preserve corrections; avoid false DONE and needless HUMAN; provisional completion | Natural-language contract is not a dispatch interlock |
| `schemas/work-item.schema.json` | Goal, state, done_when, history, optional unresolved/source fields | No mandatory job identity, expected head, worker ownership, specification revision, or dispatch generation |
| `bin/cockswain-supervise` | Sends supplied state to configured completion endpoint; parses action/rationale/prompt/question/gaps | Does not collect live repository state or resume a worker; does not establish that a supplied observation is current |
| `bin/import-chatgpt-export`, `bin/cockswain-recent-cases` | Private export normalization and joins to independently supplied objective state/labels | Not live chat observation; cannot see unexported corrections |
| `corpus/chat-history`, `tests/corpus` | 148 literal messages; ten base cases plus ten prefix states; history ablation | Many records are isolated; case objective state is authored separately, not a captured pre-message snapshot |
| `bin/cockswain-eval`, behavior/corpus tests | Label isolation, action and phrase grading, false-DONE/HUMAN and invalid-output counts | Deterministic stub passes establish plumbing; no false-continuation metric or semantic execution proof |
| `bin/cockswain-authority-decision` | Model classifies semantic authority; collector checks actual record role/existence and derives text/context/scope digests | Revision override and dirty-source identity are not independently established |
| `bin/cockswain-authority-collect`, `...-receipt` | Public-safe authority receipt for AICI | Collector copies decision revision into target revision, so equality is circular |
| `bin/cockswain-merge-state` | Maps AICI seven-column blocker table to four actions, preferring mechanical work before human boundaries | Table consumer, not live collector or permission to execute arbitrary `next_action` |
| `bin/cockswain-pr-retirement` | Picks a next action across managed/unmanaged open PRs | Main can return DONE for header-only inputs without collection completeness proof; PR queue cannot observe all jobs |
| `tests/test-dispatch.sh` | Intended unchanged prompt delivery to existing worker, no delivery for other actions | Executed and fails: dispatcher absent; test lacks head, spec, lease and duplicate guards |
| `bin/cockswain-v1` | Retained old GitHub report generator | Scheduled queue retired in commit `bdff505`; do not revive as a substitute for worker continuation |

No separate executable named supervisor-state was found. The relevant machinery
is the supplied work-item schema, model result, and AICI `merge/state.sh` blocker
table. No existing durable general-purpose worker lifecycle controller was found
in this inspected tree. That finding is bounded to this source and recovered
history, not a claim about every possible external service.

## AICI has two related interfaces, not one universal proof

`merge/verify.sh` / `merge/collect-verdict.sh` use the documented ten-input
`aici-merge-state-v4` verification path. The contextual authority collector
consumes this schema. The operational `merge/state.sh` consumes six files:
`pr.tsv`, `checks.tsv`, `evidence.tsv`, `dependencies.tsv`, `followers.tsv`, and
`authorization.tsv`, and emits the seven-column blocker table consumed by
Cockswain. Do not silently treat these paths as equivalent verification.

The operational state machinery distinguishes CI pending/stale/failed,
infrastructure/upstream failure, missing evidence, physical evidence, followers,
draft promotion, conflicts, and authority. This is substantial reusable work.
Its supplied fields still need trusted collection and current source validation.
The inspected `merge/retire-ready.sh` reruns `state.sh` on a saved directory;
that is revalidation of saved input, not recollection of live head/base/spec.
The expected-head merge parameter protects one race, not all changed assumptions.

Relevant audit issues remain dependencies: AICI
[#167](https://github.com/isomorphisms/ai-ci/issues/167) for operational
authority/follower obligations and
[#170](https://github.com/isomorphisms/ai-ci/issues/170) for live refresh before
retirement. These identifiers were recovered from audit history; this report's
source findings above are independently inspected. The current task does not
repair or merge that separate work.

## Open Cockswain work observed

| Object | Inspected state and implication |
| --- | --- |
| [isomorphisms/cockswain PR #29, “Require complete account discovery before reporting DONE”](https://github.com/isomorphisms/cockswain/pull/29) | Open; head `91ecea554fd34713a3d59df500fdbb6a8c0974be`; source inspected. Requires `aici-account-collection-v2`, complete counts, headers, uniqueness and table hashes. Pair with producer before consumption. Completeness within visible authored-repository scope does not prove freshness or visibility of all work. |
| [isomorphisms/cockswain PR #27, “Make Idriç language changes follow all consumers”](https://github.com/isomorphisms/cockswain/pull/27) | Open; head `ef622d76e3ad8e7e7e91a77a9ab77795e3cc71a6`; extends follower obligations, leaves canonical inventory in AICI. Metadata inspected; not accepted here. |
| [isomorphisms/cockswain PR #11, “Evaluate first live supervisor candidates”](https://github.com/isomorphisms/cockswain/pull/11) | Evaluation draft, head `a14853edd4b445d3ce12f490bff1fb5007a839ff`; live evaluation run failed. Do not merge an evaluation draft merely because harness CI passes. |
| [isomorphisms/cockswain PR #12, “Retry Ministral supervisor evaluation at Q4_K_M”](https://github.com/isomorphisms/cockswain/pull/12) | Evaluation draft, head `6519a89a2595ddc31f077ad25d2d6504d249f4de`; latest model run cancelled. Earlier run at `0e951eb7a3e1c4cd95e464ef07801f52cfa4269a` completed green but all evaluated outputs were invalid. |

Open issues observed: #17 representation contracts; #18 information-preserving
cleanup; #19 conflict semantics; #20 exact-head preservation; #21 branches versus
PR storage; #22 fast-forward detection; #23 repository initialization; #24 stale
draft metadata; #25 CI that never ran; #30 classifier identity. These are
existing obligations, not fresh authority to merge, close, or delete anything.
The historical cleanup examples in #18–#25 are retrospective reports and must not
be counted as timestamped pre-intervention decision evidence.

## The green evaluation counterexample

[Run 35514843745](https://github.com/isomorphisms/cockswain/actions/runs/35514843745),
job 106088924028, evaluated Ministral Q4_K_M at exact checkout
`0e951eb7a3e1c4cd95e464ef07801f52cfa4269a` on 2026-09-20. Both the job and
the evaluation step report success. The fetched job log reports:

| Suite | Total | Correct | Invalid |
| --- | ---: | ---: | ---: |
| Corpus with history | 20 | 0 | 20 |
| Corpus without history | 20 | 0 | 20 |
| Behavior with history | 12 | 0 | 12 |
| Behavior without history | 12 | 0 | 12 |

The log records `overall=1` and FAIL for all four suites. The workflow catches
evaluation failures, sets `overall`, prints reports, but never exits with that
status. This explains the green wrapper result. Many responses use Markdown code
fences and violate the JSON-only contract. Some also contain malformed JSON.
Do not strip fences retroactively and claim the run passed: semantic prompts
and authority boundaries would still require evaluation. Zero false-DONE/HUMAN
counts alongside 64 invalid outputs do not establish safety or usefulness.

Raw selected log lines and exact run identity are retained in
`receipts/continuation/historical-model-evaluation.txt`. This newly recovered
failure directly falsifies promotion based on green CI. It does not establish
that every candidate model is incapable of this task.

## Looking Glass / stewardship

No Looking Glass or stewardship integration appeared in Cockswain's inspected
tree, branch-history search, or issue search. Recovered history supplied no
public, verified worker-resumption implementation owned by that work. Private
project details are deliberately not copied into this public repository.
Therefore this investigation cannot assign dispatch to it or claim it solves
intent capture. Keep worker transport as an adapter pending direct verification.
Repository curation and preservation are relevant stewardship responsibilities;
they do not demonstrate a live conversational controller.
