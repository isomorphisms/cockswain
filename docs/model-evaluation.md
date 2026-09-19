# Model evaluation

Generic leaderboards are not the acceptance criterion for Cockswain.

Evaluate candidate models on supervision states drawn from the actual work pattern, with private material kept outside this public repository.

## Primary metrics

- false_done: model returned DONE when the label was not DONE;
- false_human: model returned HUMAN when the label was not HUMAN;
- action_accuracy;
- invalid_output: response did not match the JSON result contract.

Latency is recorded only for diagnosis and is not an optimization target.

## Initial model matrix

The model manifest is `models/models.json`.

Every model is instructed to reason as deeply as it can. If the serving runtime exposes an explicit reasoning-effort control, use its highest setting.

## History ablation

Each real evaluation case should eventually be run twice:

- with recent/normalized chat history;
- with chat history removed.

This measures whether history actually improves triage rather than merely adding tokens.

A later corpus should also compare short recent-history windows with the full active branch.
