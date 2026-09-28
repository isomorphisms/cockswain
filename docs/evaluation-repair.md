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
