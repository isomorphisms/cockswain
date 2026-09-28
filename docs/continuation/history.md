# Labeled manual-supervision transitions

This is a derived analysis outside `corpus/chat-history/`. It adds no transcript
text and invents no assistant turns. References below resolve at inspected main
`023b9395d477a4986e858e7a2196ea584653f449`.

File aliases:

- U: `corpus/chat-history/2026-08-29--09-19-verbatim-more.txt`
- C: `corpus/chat-history/2026-09-19--20-assistant-verbatim-cockswain-thread.txt`
- R: `corpus/chat-history/2026-09-14--19-verbatim.txt`
- A: `corpus/chat-history/2026-09-17--18-assistant-verbatim-recovered.txt`

Record numbers are local to a file. Chronological links in the ingestion thread
are supported by the existing ordered multi-record evaluation case and the
literal assistant/user sequence, but the corpus has day-level timestamps and
does not certify absence of omitted turns. Assistant reports of merges remain
reports; they are not independently captured historical GitHub snapshots.

## Transition ledger

| ID/date | State before → user message → resulting work | Could the action be inferred before the message? | Label and limit |
| --- | --- | --- | --- |
| H1, Sept 19 | C010: reports 13 curated records, identifies another useful pass → U029: “That's not a lot” → C011–017: expansion, reported 64 records | More collection was possible, but original U028 requested “some” recent history and supplied no numerical minimum. The user's dissatisfaction with quantity was not established by the count alone. | NEW_JUDGMENT about sufficiency; not an automatic 64-record target. Three sides recovered, no contemporaneous objective snapshot. |
| H2, Sept 19 | C017: reports 64 records and a completed expansion → U030: “More” → C018: begins broader extraction | U029 had already asked for more, but C017 claims to satisfy that request. Whether 64 was still insufficient was not independently specified. | SHORT_MESSAGE_NEW_JUDGMENT; at most continued inspection was inferable. New required volume was not. |
| H3, Sept 19 | C017–018: corpus includes 28 summaries → U031: “No we need verbatim messages…” → C019–025: separates summaries and reports strictly literal corpus | Literal-only quality was not explicit in U028–030. The current repo's later literal-only rule must not be projected backward. | CORRECTION; new governing constraint at this cutoff. Once supplied it must persist automatically. |
| H4, Sept 18 | Before stopping turn missing → R004: “Okay don't give up please” → adjacent resulting work missing from literal corpus | The existing `continue-dont-give-up.case` supplies “repair incomplete, logs available, no human boundary.” Those are authored case conditions, not a recovered before-state witness. | ROUTINE_CANDIDATE / INSUFFICIENT_EVIDENCE. Conditional CONTINUE is sensible; historical safe-dispatch label is unknown. |
| H5, Sept 17 | Exact prior stopping point missing → R003: “Can I close this” → adjacent resulting work missing | Read-only completion verification could be requested under a registered job. Nothing in this single message proves all original obligations satisfied. | VERIFY_CANDIDATE / INSUFFICIENT_EVIDENCE; not DONE. |
| H6, Sept 18 | Exact prior state missing → R008: “All right anything else we need to do on this thread” → adjacent resulting work missing | The source metadata identifies shader closeout, but not the governing pre-message branch/base or outstanding work. | VERIFY_CANDIDATE / INSUFFICIENT_EVIDENCE. Do not pair unrelated same-date replies to fill the gap. |
| H7, Sept 19 | U004: asks for a cron job to push work along; U005: asks what inputs/output mean → U006: rejects more PRs and asks to have ChatGPT work → resulting implementation not in this literal sequence | The rejected mechanism cannot be selected from the previous open-ended wording alone. | MECHANISM_CORRECTION. Later proposals must preserve existing-worker continuation rather than revive the retired queue. |
| H8, Aug 29 | Prior stopping point missing → U018: explicitly reserves ARM/Thumb work to the human; U019 allows x86 work; U020 asks for durable notes → adjacent resulting work missing | The reservation is actual user judgment. A model cannot infer blanket ARM/Thumb authority from technically implementable work. | HUMAN_OWNERSHIP_BOUNDARY; other authorized work may still CONTINUE. |

H1–H3 are the strongest recovered before/message/after sequences, and all are
counterexamples to classifying short messages as routine on wording alone.
H4–H6 identify the intended opportunity but lack enough pre-message evidence to
measure automation coverage. H7–H8 are contrasting corrections/reservations.
The latest visible issh “Continue” messages and packed-memory omission complaint
are additional discovery leads; this report does not convert that truncated
history into scored triples or public transcript additions.

## Historical stopping-point controls

These are real assistant stopping points, not invented user transitions:

| Record | Reported stopping state | Valid inference if freshly verified |
| --- | --- | --- |
| A006, Sept 18 17:17:02Z | append-FAT exact head clean, all five workflows passed, watch stopped, not merged | Refresh completion and authority. Continue an already-authorized merge only through AICI; cannot infer merge permission from “clean.” |
| A008, Sept 17 09:32:51Z | Idriç compiler gate actively running; other work finished | WAIT while that exact job genuinely runs; failed or completed job requires a new decision. |
| A009 then A010 | Remaining branches reported; later says both absent | Historical leftovers must not cause duplicate cleanup. The later statement itself still needs live verification. |

These support concrete design boundaries: dependency wakeup, independent
verification, and supersession. They do not show unattended continuation success.

## Recovery method and exclusions

Inspected all existing corpus case references, the two-sided ingestion thread,
and relevant literal user/assistant files. Two targeted history searches sought
adjacent turns and Coxswain/Looking Glass ownership. Search results mixed
summaries, inconsistent chronology, and isolated excerpts. Those were discovery
leads only, excluded from scored transcript evidence and from public quotations.
No complete private export was available in the checked-out repository.

Existing labels answer “what action follows **this supplied state**?” That is
different from “could a controller have collected enough state **before this
user intervention**?” Do not reinterpret the 20 passing stub evaluations as 20
historically automatable messages. Their repeated prefixes also are not 20
independent jobs.

## Required prospective corpus

For the next registered jobs, capture the exact job/spec, all applicable human
corrections through a recorded cutoff, last worker message, worker idle/running
state, heads/base/dependencies, raw collection receipts, and unresolved acceptance
items *before* a continuation decision. Seal those inputs before reading a later
human intervention. Preserve the intervention and ensuing work separately.

Grade two questions independently: which safe action was inferable then, and
whether the actual continuation stayed within it. Permit an UNKNOWN evidence
label without treating it as a human decision. Hold out whole projects and
thread families. Do not let a revised prompt train and test on the same corrected
case, and do not let future fixes leak into the pre-intervention snapshot.

Current measured fraction of historical interventions safely replaceable:
**unknown**. The evidence does not justify a numerical savings estimate.
