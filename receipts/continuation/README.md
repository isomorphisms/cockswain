# Continuation investigation receipts

Observed 2026-09-28. These files preserve actual output and bounded claims.

| Receipt | What ran | Result |
| --- | --- | --- |
| `baseline-tests.txt` | Seven existing deterministic suites plus the existing dispatch test at main `023b9395d477a4986e858e7a2196ea584653f449` | Seven suites pass; dispatch exits 1 because executable is absent. Stubs are not a selected model. |
| `historical-model-evaluation.txt` | Fetched log from historical Actions job 106088924028, exact evaluation checkout `0e951eb7a3e1c4cd95e464ef07801f52cfa4269a` | Green job, all four suites FAIL, 64 invalid outputs. No rerun or reinterpretation. |
| `adversarial-loading.txt` | Existing evaluator loads 14 new cases with `/bin/false` | All load, all outputs INVALID, expected failure. Not semantic acceptance. |
| `incomplete-discovery.txt` | Main and proposed consumer receive identical incomplete header-only fixture | Main wrongly emits DONE; proposal rejects with exit 66. |

## Continuation experiment disposition

- Live dispatch: NOT_RUN.
- Instruction issued to a coding worker: NONE.
- Autonomous task completion: NOT_VERIFIED.
- Concurrent worker/lease test: NOT_RUN.
- Current model acceptance on the new corpus: NOT_RUN.
- Historical routine-intervention savings: UNKNOWN.

No configured, accepted existing-session dispatcher was recovered. The historical
candidate did not satisfy its output contract. Issuing an unguarded prompt or
using a canned worker would not demonstrate the requested practical behavior.
The investigation therefore leaves an explicit negative promotion decision and
a follow-up acceptance boundary, not an invented successful continuation receipt.
