# OpenAI developer API mirror

`upstream/` is a pinned Git submodule of
[openai/openai-openapi](https://github.com/openai/openai-openapi), OpenAI's
official OpenAPI 3.1 repository.

The upstream project describes the specification as the machine-readable
OpenAI REST API contract: endpoints, authentication, parameters, and request
and response schemas. The submodule contains both `openapi.yaml` and
`openapi.json`, plus the upstream license and repository metadata.

`UPSTREAM` repeats the pinned source revision in a small text file so an
agent can establish provenance without parsing Git internals.

Initialize the mirror after cloning Cockswain:

```sh
git submodule update --init -- vendor/openai-api/upstream
```

Advance it to the current upstream `main` revision with:

```sh
sh bin/update-openai-api-mirror
```

Commit the changed submodule pointer and `UPSTREAM` together.

This mirror follows the published API contract rather than reconstructing
endpoints from prose. Human-readable guides, examples, SDK documentation, and
ChatGPT product/account UI behavior are not treated as additional API
endpoints.
