# Model evaluation

Generic leaderboards are not the acceptance criterion for Cockswain. Evaluate supervisors on the actual decision boundary and keep objective state separate from conversation history.

## Primary metrics

- false_done: model returned DONE when the mode-specific label was not DONE;
- false_human: model returned HUMAN when the mode-specific label was not HUMAN;
- action_accuracy;
- invalid_output: response did not match the supervisor result contract.

Latency is diagnostic only.

## Verbatim public corpus

`tests/corpus/` is the first real-history regression set. The labels are plain tab-delimited files. They do not contain copied transcript text; each `history_record` points into the strictly verbatim files under `corpus/chat-history/`.

`bin/cockswain-corpus-cases` builds temporary JSON work items for the existing supervisor boundary. The current set contains eight cases, two for each action with history. It also retains at least two cases where the correct action changes when history is removed, so ablation tests whether conversation context changes the decision in a justified way.

`bin/cockswain-corpus-eval` runs a configured model over both modes.

## History ablation

The evaluator supports three label fields:

- `expected_action` for legacy cases;
- `expected_action_with_history`;
- `expected_action_without_history`.

For without-history runs it empties `chat_history`, removes transcript-derived `source.history`, and removes every expected-action label before invoking the supervisor. With-history runs also remove the labels before invocation. The model therefore never sees its oracle.

Most cases should keep the same expected action under ablation because objective state is authoritative. A different without-history label is appropriate only when the missing conversation contains a policy, intention, or human-loop reservation that materially changes the decision.

## Initial model matrix

The model manifest is `models/models.json`. Every model should use the deepest reasoning mode its runtime exposes.

`bin/cockswain-eval-matrix CASE_DIR` runs every manifest model in both history modes, records false-DONE, false-HUMAN, accuracy, and invalid output, and writes local ignored results under `eval/results/`.

## Promotion boundaries

The harness itself can be promoted when deterministic tests prove that:

- real verbatim records are extracted rather than rewritten into fixtures;
- CONTINUE, WAIT, HUMAN, and DONE are each represented repeatedly;
- history chunks and history-sensitive ablation cases are represented;
- expected labels are never sent to the supervisor;
- without-history runs actually remove transcript content and transcript provenance.

That is a software-harness claim, not a model-quality claim.

Promoting a supervisor model for unattended use requires live runs on this corpus and a fuller private recent-history set, with independently checked objective state. The recurring Cockswain controller remains paused until a selected model and the dispatch boundary have their own acceptance evidence.
