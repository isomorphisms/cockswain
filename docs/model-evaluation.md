# Model evaluation

Generic leaderboards are not the acceptance criterion for Cockswain. Evaluate supervisors on the actual decision boundary and keep objective state separate from conversation history.

## Primary metrics

- false_done: model returned DONE when the mode-specific label was not DONE;
- false_human: model returned HUMAN when the mode-specific label was not HUMAN;
- action_accuracy;
- invalid_output: response did not match the supervisor result contract.

Latency is diagnostic only.

## Verbatim public corpus

Current main contains 148 literal messages: 88 user and 60 assistant. Evaluation fixtures reference those messages by file and record number; they never rewrite transcript text.

The base suite currently has ten real-history cases. Every action has at least two base cases. At least two cases contain both literal user and assistant messages from the same project thread.

A multi-record case may contain:

`checkpoint<TAB>N<TAB>WITH_ACTION<TAB>WITHOUT_ACTION`

`bin/cockswain-corpus-prefixes` turns the first N literal messages into a separate work item. The current suite adds ten turn-prefix states to the ten base cases, giving 20 public real-history evaluations.

This is the intended chunk test: ask the supervisor again as literal history grows, rather than evaluating only the final excerpt.

## History ablation

The evaluator supports `expected_action`, `expected_action_with_history`, and `expected_action_without_history`.

Before invoking the supervisor it removes every expected-action field. Without-history mode also empties `chat_history` and removes transcript-derived `source.history`.

Most cases keep the same action under ablation because objective state is authoritative. Three current base cases deliberately change action because the removed conversation contains a material user policy or ownership constraint that is not present in objective state.

## Initial model matrix

The model manifest is `models/models.json`. Every model should use the deepest reasoning mode its runtime exposes.

`bin/cockswain-eval-matrix CASE_DIR` runs every manifest model in both history modes, records false-DONE, false-HUMAN, accuracy, and invalid output, and writes ignored results under `eval/results/`.

## Promotion boundaries

The harness can be promoted when deterministic tests prove that literal records are extracted, roles and order are preserved, all four actions recur, turn-prefix checkpoints work, history-sensitive ablation is real, labels never reach the model, and ablation removes transcript data and provenance.

That is a software-harness claim, not a model-quality claim.

Promoting a supervisor model for unattended use still requires live runs on the public corpus and a fuller private recent-history set with independently checked objective state. The recurring Cockswain controller remains paused until a selected model and the dispatch boundary have their own acceptance evidence.
