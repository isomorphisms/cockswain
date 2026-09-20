# OpenAI developer API mirror

This directory vendors the complete OpenAPI 3.1 contract published by
[openai/openai-openapi](https://github.com/openai/openai-openapi).

The upstream project describes this specification as the machine-readable
OpenAI REST API contract: endpoints, authentication, parameters, and request
and response schemas.

Files:

- `openapi.yaml` — generated mirror of the upstream OpenAPI document.
- `UPSTREAM` — exact upstream Git revision plus SHA-256 receipts.
- `LICENSE` — the upstream MIT license notice.

Do not hand-edit the generated files. Refresh them with:

```sh
bin/update-openai-api-mirror
```

The mirror intentionally follows the published API contract rather than
reconstructing it from human-readable documentation. Guides, examples, SDK
documentation, and ChatGPT product/account UI behavior are not invented as
API endpoints here.
