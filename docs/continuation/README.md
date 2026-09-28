# Can Coxswain replace routine manual continuation?

Investigation date: 2026-09-28. Inspected Cockswain main:
`023b9395d477a4986e858e7a2196ea584653f449`.
Inspected AICI main: `b3af13b3ab2bac9dd7c72bf9dd855ed5a17609b5`.
This is an investigation and acceptance design, not an operating supervisor.

## Decision

The existing architecture can support a narrow continuation controller. Keep
CONTINUE / WAIT / HUMAN / DONE. Add explicit reasons, action bounds, observation
identity, and dispatch guards around those actions, rather than a second
project-state machine. Coxswain chooses the next work; AICI supplies independently
checkable acceptance evidence. Neither a green badge nor an agent's completion
statement establishes that the original job is complete.

**Unattended continuation is not accepted at the inspected revisions.** The
repository has no dispatcher, no accepted transport to an existing work thread,
and no demonstrated live decision-plus-dispatch-plus-verification loop. A
historical evaluation has a green workflow with 64 invalid model outputs. The
present historical corpus supports useful boundary analysis but does not
support a measured claim that 60%, or any substantial fraction, of the user's
interventions can safely disappear.

This is a partial negative result, not a conclusion that automation is
impossible. Routine implementation after an accidental stop, fresh acceptance
verification after a completion claim, and resumption after a named dependency
lands are plausible targets **when the job and current worker are registered**.
Discovering forgotten unregistered threads is a different, incomplete capability.

## Evidence and deliverables

| Document | Purpose |
| --- | --- |
| [Current architecture](architecture.md) | Source inventory, open work, defects, AICI boundary, exact revisions |
| [Historical transitions](history.md) | Real record references, before/message/after, inferability and missing evidence |
| [Minimal design](design.md) | State taxonomy, authority, concurrency, freshness, forgotten work, packet and receipts |
| [Adversarial acceptance](acceptance.md) | Twelve requested cases plus controls, measurement and release boundary |
| [Follow-up jobs](handoff.md) | Bounded implementation and judgment-bearing prerequisites |
| [Receipts](../../receipts/continuation/README.md) | Actual local checks and historical evaluation evidence |
| [Evaluation inputs](../../tests/continuation/) | Synthetic `.case` inputs for the existing behavior harness |

No agent continuation was issued during this investigation. No model was
promoted, recurring job enabled, merge performed, acceptance criterion removed,
or existing implementation replaced. The conditional prototype was withheld:
without a verified worker/session adapter and a usable supervisor, a canned
worker that merely logs a prompt would demonstrate transport plumbing while
leaving the practical question unanswered. The existing red dispatch test already
specifies that smaller plumbing boundary. A live end-to-end path remains an
explicit follow-up, not a claimed result.

## Smallest useful trial

Register three or four already-authorized jobs once. Each registration points
to the governing spec, acceptance obligations, existing worker/session, exact
repository identity, and permitted operations. Capture a real stopping point,
refresh it, issue at most one bounded continuation to that worker, and verify
the resulting work. Keep this within the existing allocation; registration must
not authorize new paid capacity. Start with observation-only decisions until
the transport's identity, cancellation, and duplicate-delivery behavior is known.

Do not make the user approve each predetermined step. Use HUMAN only after safe
investigation has reduced a problem to an actual human-only choice or action.
Missing evidence should usually trigger bounded collection, not a generic
permission question. Missing transport should stop dispatch with an explicit
infrastructure receipt, not fabricate progress.

## What remains unproven

- Reliable original-job recovery across incomplete histories.
- Detection of relevant corrections in other threads before dispatch.
- Live concurrent-worker ownership and safe restart after ambiguous delivery.
- Model ability to preserve the *substance* of the next instruction, not merely
  emit the right action token.
- False-continuation and false-stopping rates on a representative prospective
  sample, including actual reductions in human attention.

Until those are measured, the honest answer is: **Coxswain is a plausible home
for the decision loop, but today's system has not demonstrated that you can
leave several substantial coding threads under its unattended supervision.**
