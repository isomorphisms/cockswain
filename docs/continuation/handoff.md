# Follow-up allocation

## Decision and evidence

- Preserve the four actions and AICI separation. Implement a bounded controller
  only after worker transport and fresh-spec observation are demonstrated.
- Current main `023b9395d477a4986e858e7a2196ea584653f449` lacks dispatch.
- Historical run 35514843745 at `0e951eb7a3e1c4cd95e464ef07801f52cfa4269a`
  records 64 invalid outputs and FAIL status while the workflow succeeds.
- Existing authority-provenance and collection repairs must not be duplicated.
- This investigation gives no merge, cleanup, paid-capacity or publication authority.

## Recommended allocation

- Sun: one remaining judgment-bearing task—verify the actual worker/session and
  correction-observation adapter, then choose the bounded live trial. No wholesale
  orchestration redesign.
- Earth: repair evaluation status propagation and metrics; after Sun establishes
  the adapter, implement one guarded dispatch/reobserve path.
- Moon: none ready immediately. Propagate only an exact verified Earth interface
  into the remaining fixtures/docs and the three or four registrations. Do not
  ask Moon to infer authority, choose transport, or resolve semantic surprises.

## Earth follow-up: make evaluation failures observable

Work in `isomorphisms/cockswain`. Read `docs/continuation/` on this investigation
branch, current AGENTS.md, and inspect current main plus both evaluation drafts
before editing. Preserve ongoing work and use a dedicated branch. The diagnosis
is a missing terminal failure status in the historical evaluation workflow,
not proof that the classifier's semantic decisions were correct.

Make failed/invalid corpus or behavior results fail the evaluation job while
still retaining its artifacts. Reproduce the four failed suites and `overall=1`
from job 106088924028; do not relabel them PASS. Add false-continuation and false-
stopping measurements with explicit denominators and invalid-output accounting.
Keep current four-action compatibility and oracle isolation. A format adapter,
if chosen, must be strict and independently tested; do not silently accept
arbitrary prose or weaken the JSON contract to make old outputs green.

Required evidence: a deliberately failing child evaluation makes the wrapper
nonzero while its receipt survives; valid controls remain successful; malformed
output cannot execute work; labels do not reach the classifier. Add input support
for the new continuation corpus without pretending phrase matching proves safe
execution. Do not enable recurrence, drive threads, merge, or run paid models.
Return any incompatible transport/model requirements for Sun.

## Sun follow-up: prove the actual worker adapter

Work from the current `isomorphisms/cockswain` state and this investigation.
Determine what supported interface can resume the user's *existing* coding job
while observing worker identity, idle/running state, context watermark, new human
corrections, cancellation and dispatch acknowledgment. Do not substitute a new
unrelated API conversation and call it continuation of the existing thread.
Do not conclude from API documentation alone: demonstrate the identity and
observation boundary on a registered test job within existing allocation.

Use the smallest available adapter. If it cannot see corrections in linked
threads, state exactly what it misses and do not claim fresh mutating dispatch.
Resolve whether a repository-side spec revision can be updated automatically
from the original job's trusted events. Do not make the user maintain two copies
of their intent. Test an acknowledgment lost after delivery and a still-running
worker during controller restart. If the interface cannot safely distinguish
these, return a concrete capability blocker rather than a UI-clicking loop.

Stop once the supported adapter, identity/authority boundaries and executable
acceptance path are established. Hand Earth exact interfaces and a registered
test job; leave broader rollout to Moon after verification.

## Conditional Earth follow-up: one continuation end to end

Prerequisites: Sun's actual adapter receipt and exact source revision; corrected
evaluation status; accepted classifier results; independently derived authority
identity and relevant AICI collection/freshness repairs. Refresh those mutable
states first. If a prerequisite is absent, do the safe preparatory work and name
the concrete missing boundary; do not implement a fake adapter as completion.

Extend current work items and implement one explicit registration, durable attempt
record, atomic ownership/generation, fresh-state comparison, bounded packet,
idempotent delivery, and independent after-state verification as specified in
`design.md`. Keep public/private records separated. Start with one routine
translation/implementation criterion, no merge or external actions. Execute
the stale-head, duplicate, lost-ack, changed-spec and omitted-criterion cases
against actual intervening state changes. The receipt must contain the real
instruction, expected state, delivery acknowledgment and independently observed
result. Then demonstrate separate concurrent registered jobs without duplicate
delivery. Do not claim unattended readiness from only the old dispatch stub test.

## Conditional Moon follow-up

NONE until the preceding Earth receipt supplies an exact passing source head,
settled registration/packet fields and tested adapter. Then extend the same
mechanical mapping to the remaining acceptance cases and explicitly registered
jobs. Verify every source/target identity, preserve interrupted attempts, run
the settled tests and report coverage. Any new architecture choice, authority
ambiguity or interface divergence returns to Sun/Earth. No autonomous activation
of unregistered work.
