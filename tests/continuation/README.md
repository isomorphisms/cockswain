# Continuation adversaries

Fourteen synthetic cases for the existing `bin/cockswain-behavior-eval` interface.
The first twelve correspond to the requested failure scenarios; two add lost
delivery acknowledgment and incomplete discovery. These are desired-behavior
oracles, not implementation evidence or recovered chat transcripts.

See `docs/continuation/acceptance.md` for required live state mutations and
execution assertions. A phrase-match PASS alone cannot establish those.

Input-loading was exercised using `/bin/false` as the supervisor command: every
case loads, every output is INVALID, and evaluation fails as expected. No model
was evaluated on these cases in this investigation.

The neighboring `continuation-negative/incomplete-account` directory deliberately
has only two headers and no completion record. Main's retirement consumer
incorrectly emits DONE for it; the pending complete-discovery consumer rejects it.
