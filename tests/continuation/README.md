# Continuation adversaries

Fourteen synthetic cases for the existing `bin/cockswain-behavior-eval` interface.
The first twelve correspond to the requested failure scenarios; two add lost
delivery acknowledgment and incomplete discovery. These are desired-behavior
oracles, not implementation evidence or recovered chat transcripts.

See the [investigation acceptance design](https://github.com/isomorphisms/cockswain/blob/09f387c20378c8d322d4502fe47452a4397fc70e/docs/continuation/acceptance.md) for required live state mutations and
execution assertions. A phrase-match PASS alone cannot establish those.

Input-loading was exercised using `/bin/false` as the supervisor command: every
case loads, every output is INVALID, and evaluation fails as expected. No model
was evaluated on these cases in this investigation.

The investigation branch also retains the incomplete-account counterexample;
this evaluation repair does not duplicate the separate retirement repair.
