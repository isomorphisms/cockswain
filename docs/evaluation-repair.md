# Evaluation evidence repair, 2026-09-28

Based on the evaluation draft at
`6519a89a2595ddc31f077ad25d2d6504d249f4de`, on separate branch
`fix/evaluation-evidence`. Main and both existing evaluation drafts were refreshed
before editing and remained at the heads recorded by the investigation.

The [investigation](https://github.com/isomorphisms/cockswain/tree/09f387c20378c8d322d4502fe47452a4397fc70e/docs/continuation)
found a historical green workflow whose four suites all failed. This repair
changes the retained workflow's shell boundary and existing shell/jq evaluator;
it does not introduce a new orchestration language or migrate the program.

## Changes

- The critical evaluation step exits with its accumulated failure status. Setup
  also fails immediately instead of continuing after a broken case-generation
  command. Existing `always()` cleanup/upload steps remain intact.
- The evaluator validates custom-command results as well as ordinary model
  results. Both paths reject missing/extra keys, multiple JSON values, fenced or
  malformed JSON, blank prompts, contradictory action fields and nonstring gaps.
  No permissive fence-stripping adapter was introduced.
- Existing action and semantic grading remain. Added raw continuation and
  stopping counters with explicit denominators.
- The deterministic CI checkout is bound to the actual head, matching current
  main's evidence rule. The model-evaluation workflow is still an evaluation
  draft; this branch is not unattended-controller approval.

## Metric meanings

`expected_continue_total`: cases labeled CONTINUE for this history mode.
`returned_continue_total`: contract-valid CONTINUE results.
`false_continue`: returned CONTINUE when another action was expected, or when
the required/forbidden output screen failed. This is a screening count, not a
measurement of actual dispatched execution safety.
`false_stopping`: expected CONTINUE opportunities that did not pass, including
invalid output and a CONTINUE whose output screen failed. An unsafe prompt can
contribute to both counters: it proposes the wrong work and fails to advance the
required work. These overlapping counts must not be added into an error rate.

No rate is emitted without its denominator. Invalid outputs remain in total and
invalid counts. A run with no valid CONTINUE outputs has no measured precision;
zero false_continue alone cannot establish safety. These checks do not detect
all semantic drift, hidden stale state or duplicate execution.

## Focused verification

`tests/test-behavior-cases.sh` exercises actual evaluator and model-response
parsers with synthetic replies. It extracts and executes the actual workflow
evaluation step, replacing only child evaluators with `/bin/false` or
`/bin/true`. Failing children must fail the wrapper and preserve report files;
successful controls must pass. Deleting the terminal exit from a temporary copy
reproduces the old false green. This is a mutation control, not a real model run
or a live artifact-upload claim.

The existing 20-state corpus/ablation contract still passes. The 14 continuation
inputs remain desired-behavior cases, not accepted model judgments. An intentional
always-invalid run now reports 14 invalid outputs and 11 failed continuation
opportunities, rather than only misleading zero false-DONE/HUMAN counters.

No model was downloaded or evaluated, no thread was resumed, and no recurring
controller was enabled. The original failed historical evaluation remains failed.

## Follow-up: retain failed attempts and exercise continuation inputs

The evaluator previously removed each response after grading. Set
`COCKSWAIN_EVAL_RECEIPTS` to a private directory to preserve evidence. Every
invocation creates a fresh `evaluation.*` directory with mode 0700; repeat runs
never reuse or overwrite an earlier attempt. Case directories use numeric
ordinals, not fixture-controlled paths. Code/prompt digests and command identity
accompany the run. Each case retains the original oracle separately from the
label-stripped input, output, stderr, command exit status and grade. The ordinary
model path also retains the actual model request, raw response and transport
exit status. These are evaluation records, not continuation dispatch receipts.

Output is written directly into the attempt before grading. `PREPARED` without
`FINISHED` means an incomplete evaluation, including a killed evaluator; it must
not be treated as success or silently replaced. `FINISHED` means grading ended,
not that it passed. Grades and the process exit status remain authoritative for
the screen result. A transport error remains invalid even if a response body
contains a valid-looking answer. An unavailable backend's partial output stays
available for diagnosis. These files are not an fsync-backed crash journal and
do not guarantee survival of filesystem/host loss.

Receipts can contain private source context. Keep private evaluations under
`.private/`; never commit or upload them automatically. The retained live-model
workflow now enables receipts under its artifact directory only for its public
fixtures. Its continuation screen runs all 14 adversaries in each history mode,
and all six suite statuses affect the final exit. This changes future evaluation
coverage; no live evaluation was triggered by this repair.

Regression evidence includes two attempts preserving separate malformed replies,
absence of labels in the actual model request, a transport failure with retained
body, and a real SIGTERM between prepared and graded states with retained partial
output. Loading all 14 adversaries through an always-failing command produces
14 invalid results and 11 false stops. That result validates failure accounting,
not the classifier's judgment or a worker adapter. The session-control blocker
described in [worker adapter inspection](worker-adapter-inspection.md) remains;
this work does not bypass it or claim unattended supervision.
