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

`bin/cockswain-eval-matrix CASE_DIR` runs every manifest model through one configured OpenAI-compatible local endpoint. The manifest's `send_reasoning_effort` flag controls whether `reasoning_effort: high` is sent for each model.

The matrix runner does not stop on the first bad candidate. It records every with-history and without-history run before returning failure if any strict evaluation failed. The default output directory is `eval/results/latest`; use `COCKSWAIN_RUN_ID` or `COCKSWAIN_RESULTS_DIR` to keep multiple local runs.

The result directory contains:

- one evaluator log per model/history mode;
- `summary.tsv` with total, correct, false-DONE, false-HUMAN, and invalid-output counts;
- `history-ablation.tsv` with the with-history and without-history counts side by side.

These results are ignored because real-history case ids and local serving diagnostics may themselves be private.

## History ablation

Every real evaluation case is run twice:

- with its recent/normalized chat history;
- with `chat_history` emptied and transcript-derived `source.history` metadata removed in a temporary copy.

The original case is never rewritten. This measures whether history improves triage rather than merely adding tokens.

A later corpus can compare short recent-history windows with the full active branch by building otherwise identical private case sets with different `history_messages` values.

## Promotion evidence

Running only the synthetic/public fixtures checks the harness but does not satisfy the real-history promotion condition. Promotion evidence should include a local private recent-history case set and the complete initial model matrix/history ablation on the intended serving path. Do not commit the transcripts, generated private cases, or local result logs merely to prove that the run occurred; summarize non-sensitive aggregate evidence in the PR instead.
