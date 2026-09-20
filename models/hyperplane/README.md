# Hyperplane experiment models

These checkpoints are the first representation-space ladder for Cockswain's
CONTINUE / WAIT / HUMAN / DONE experiment.

The tracked file `models` is deliberately plain text. Each non-comment row is
a Hugging Face model repository followed by the exact immutable revision that
successfully downloaded on GitHub-hosted CI. Raw model weights live under
`.models/hyperplane/` and are ignored by Git. Multi-gigabyte checkpoints do
not belong in ordinary Git history.

The initial set is:

- EleutherAI/pythia-410m
- Qwen/Qwen3-0.6B
- allenai/OLMo-2-0425-1B
- allenai/OLMo-2-0425-1B-SFT
- allenai/OLMo-2-0425-1B-DPO
- allenai/OLMo-2-0425-1B-Instruct
- HuggingFaceTB/SmolLM3-3B

The four OLMo checkpoints intentionally preserve the base -> SFT -> DPO ->
final-instruct progression so the same probes can be compared across
post-training stages.

## Download

Install `huggingface_hub` so its `hf` command is available, then fetch one
or more checkpoints:

```sh
sh bin/cockswain-fetch-hyperplane-model Qwen/Qwen3-0.6B
sh bin/cockswain-fetch-hyperplane-model \
    allenai/OLMo-2-0425-1B \
    allenai/OLMo-2-0425-1B-SFT
```

To retain all seven locally on a machine with enough disk space:

```sh
sh bin/cockswain-fetch-hyperplane-model --all
```

The downloader refuses model IDs that are not in the tracked manifest and
downloads only the manifest's pinned revision. Each successful download writes
a receipt under `.models/hyperplane/receipts/` containing the model ID,
revision, byte count, and local path.

## GitHub runner acceptance

`.github/workflows/hyperplane-model-downloads.yml` runs the seven downloads as
separate matrix jobs. No job needs all checkpoints on disk at once. Each job
requires `config.json` plus at least one `.safetensors` or `.bin` weight
file and uploads only the small exact-revision receipt as a workflow artifact.

The initial unpinned acceptance run completed all seven downloads successfully;
the revisions recorded by that run are now the tracked pins. Subsequent runs
therefore verify those exact upstream snapshots rather than whatever happens to
be at an upstream `main` ref.

This workflow establishes downloadability on a GitHub-hosted runner. It does
not establish Cockswain model quality or hyperplane separability.
