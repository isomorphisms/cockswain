# Existing-thread connection inspection, 2026-09-28

The installed client reports `codex-cli 0.154.0-alpha.3`. Its own help exposes
`agents`, `queue --thread ... --message ...`, and app-server lifecycle commands.
Those describe local/remote app-server sessions; help does not prove access to
the user's existing ChatGPT Work conversations.

Read-only `codex app-server daemon version` failed with exit 1:

    failed to connect to /root/.codex/app-server-control/app-server-control.sock
    Operation not permitted (os error 1)

No attempt was made to alter socket permissions, enable remote control, start a
replacement daemon, extract credentials, or queue work through another route.
The current boundary is inaccessible session control, not proof that the product
has no continuation capability. No existing Work thread ID was resolved to an
accessible worker. Identity, correction visibility, idle state, lost-ack behavior
and deduplicated delivery therefore remain NOT_VERIFIED.

## Relevant official interfaces

The [App Server documentation](https://learn.chatgpt.com/docs/app-server), fetched
on the inspection date, documents stored-thread reading/listing, resumption by
thread ID and turn start/steering. Thread reads include runtime status; steering
requires the expected active turn ID. This suggests an adapter surface if an
authorized server actually hosts the intended jobs. It does not establish that
this workspace can reach the server hosting the user's Work threads.

The [Goals documentation](https://developers.openai.com/cookbook/examples/codex/using_goals_in_codex),
also fetched, describes persistent thread objectives and continuation at idle
boundaries, with interruption and budget controls. Before building Coxswain's
own within-thread scheduler, verify whether that existing mechanism is available
for the target jobs. Coxswain may then only need cross-job supervision and
independent evidence checks. Availability in these actual threads is unverified.

## Next concrete prerequisite

Obtain a supported, authorized connection to the service holding the intended
existing jobs, with read-only identity/state/correction inspection first. Once
that works, test one registered idle job and the lost-ack/duplicate boundaries.
Do not manufacture an equivalent-looking new conversation as the experiment.
No user permission question is raised merely to repeat this denied local call;
the missing connection is a capability boundary, not an inferred lack of user
authorization for the requested investigation.
