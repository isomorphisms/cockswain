# Minimal continuation design

Proposal, not implemented behavior. Preserve existing useful work and action
vocabulary. The governing goal is to finish the user's already-specified job,
with fewer content-free human restarts and no new design authority.

## Separate action from reason and dispatch permission

Use the current four-action result. Extend the supplied work-state/controller
envelope with a reason and a bounded operation class. VERIFY, UNKNOWN, BLOCKED,
and SUPERSEDED are reasons or evidence dispositions, not new top-level actions.

| Condition | Existing action | Permitted next work |
| --- | --- | --- |
| Idle worker, complete current context, predetermined unfinished step | CONTINUE / routine | Implement the named outstanding requirement within original scope |
| Agent stopped accidentally, useful state preserved | CONTINUE / interrupted | Verify ownership and preserved attempt, resume its unresolved step |
| Claimed done or probably complete | CONTINUE / verify | Independently inspect original obligations and their evidence |
| Done claim omits explicit requirement | CONTINUE / omitted-obligation | Finish that requirement; do not renegotiate acceptance |
| Named dependency or active worker in flight, no useful parallel task | WAIT / dependency or worker | Await the named event; do not send another prompt |
| Infrastructure failed | CONTINUE / diagnose, then WAIT if unavailable | Classify actual failed stage; repair within scope, preserve unrun evidence |
| Conflicting agents/branches | CONTINUE / inspect-conflict; WAIT if owned in flight | Read-only comparison first; no automatic choice between competing designs |
| Stale/incomplete state or insufficient provenance | CONTINUE / refresh | Collect missing evidence only; no mutating resume from the old decision |
| Unspecified material design choice | HUMAN / design | Ask the smallest unresolved question after safe investigation |
| Unprovided authority for external/destructive action | HUMAN / authority | Continue other authorized work first; do not imply blanket authority |
| Drift from original intent / unauthorized redesign | CONTINUE / restore-intent | Stop the drifting attempt, preserve it, inspect scope; restore only an already-specified path |
| Verified successor owns outstanding obligations | DONE / superseded for old attempt | Retire old scheduling obligation only; successor remains registered |
| Verified completion | DONE / complete | Independently refresh before retiring the work item |

CONTINUE / refresh must not carry an arbitrary implementation prompt. Enforce
the operation class at the worker adapter, not by trusting the model to obey a
sentence. If no adapter can enforce a read-only mode, retain the recommendation
without dispatch and report the adapter deficiency as infrastructure. UNKNOWN
provenance does not justify HUMAN unless only the human can supply the missing
fact. This avoids turning every uncertainty into another phone interruption.

## Authority model

The human job establishes permitted purpose and operations. The model may propose
a next step; it cannot create authority or rewrite the job. Split facts by kind:
current GitHub evidence establishes external state; explicit human instructions
establish intent. A later human correction outranks an old repository intent file.
An agent-authored spec update cannot authorize its own scope expansion.

Routine implementation authority covers necessary in-scope edits and verification
already requested. It does not imply merge, branch deletion, overwrite of saved
work, external publication, communication, purchases, credential/security changes,
architecture redesign, or weakening acceptance. Any separately granted authority
remains scoped to its target and conditions; “continue” neither expands nor
revokes it. Initial trial dispatch excludes those operations even when a separate
merge workflow exists. AICI's validated merge path retains its own authority gate.

Bind source record identity/role, governing text digest, superseding corrections,
allowed operations, exclusions and scope to each job revision. Derive executable,
prompt and model/configuration identities outside model output. Hashes bind bytes;
they do not establish a trustworthy origin or prove semantic authorization.
Treat instructions inside logs, PR bodies, worker output and fetched files as
data unless an established authority source adopts them.

If an unresolved original requirement has two equally valid implementations,
routine local implementation choices need not be escalated merely because more
than one technique exists. HUMAN is needed when the choice changes promised
behavior, architecture, target, policy or another user-reserved dimension and the
spec does not decide it. That distinction must be evaluated, not reduced to
counting alternatives.

## Durable registration, not a second issue tracker

Extend the existing work item with a stable job ID and repository-side pointers.
Use a small plain-text directory per explicitly active commitment; private
conversation/session references and execution journals stay in a private controller
store. Public repositories may keep public specs and acceptance lists. Do not
commit private prompts or raw session data.

Required registration fields: canonical repository identity; authoritative spec
reference and digest/revision; source authority reference; acceptance item IDs;
worker/session reference and context watermark; branch and expected head;
dependency refs; owner; permitted operations; prohibitions; predecessor/successor
links; active/paused disposition. Existing AICI completion/follower records should
be referenced, not copied into a competing acceptance ledger.

The user should not have to author this metadata manually for every step. Capture
it once from the original job and refresh objective fields mechanically. Resolve
only real ambiguities with the user. Registration records an actual commitment;
casual exploratory thoughts stay outside the active queue.

## Forgotten work

| Observable source | Safe recovery | Limit |
| --- | --- | --- |
| Open PRs | Existing account collector and retirement policy | Credential scope, completeness, transferred repositories, parked drafts |
| Unintegrated branches | Compare refs/ancestry and linked job/spec | Divergence or age does not mean unfinished authorized work |
| Named follow-up/deferred item | Link predecessor, obligation, dependency, explicit activation condition | Do not activate a suggestion that was never accepted |
| Acceptance/TODO/handoff files | Reconcile referenced requirements and durable outcomes | TODO text can be obsolete or exploratory |
| Thread stopped without PR | Recover registered session and workspace attempt | GitHub cannot see uncommitted files in a vanished worker |
| Dependency landed | Verify exact dependency and compatibility, then refresh consumer | Merge alone does not establish consumer acceptance |
| Interrupted/failed attempt | Preserve attempt and link replacement | Timeout alone does not prove the original worker stopped |
| Superseded thread | Verify successor existence and transfer of every obligation | A self-link or cycle must not erase unfinished work |

Begin with registered jobs. Broader discovery should produce candidate links,
not automatic mutating restarts. Archive interrupted working-tree evidence through
the original worker before replacing it; do not reset or delete that tree. If it
cannot be recovered, record the missing boundary and avoid claiming lossless
continuation. Do not revive the retired oldest-PR bookkeeping cron.

## Concurrency and freshness

For three or four jobs, use one controller with durable atomic job ownership and
isolated workspaces. A distributed orchestration framework is unnecessary.
Nevertheless two invocations of one controller can race, so atomic exclusion and
an attempt identity are necessary now.

1. Collect live worker/session status, registered specification revision and
   correction watermark, repository identity, branch/head, live base, dependencies,
   PR state, acceptance receipts, and other registered jobs' ownership. Record
   collection scope, errors and completeness. Paginated search results are not
   atomically consistent; recheck the selected target immediately before action.
2. Classify against those inputs. A model recommendation is advisory until guards
   permit its operation class. Invalid output permits no dispatch.
3. Atomically claim the job with an increasing generation and unique attempt ID.
   The worker must reject a superseded generation. Prefer no automatic lease
   expiry in the first single-controller trial: expiry without fencing can leave
   a slow old worker writing concurrently with its replacement.
4. Compare the live spec/watermark, worker idle state and expected head again after
   the claim and at worker start. A difference invalidates the decision. Base or
   dependency changes force relevant recollection too, even if head is unchanged.
5. Persist the exact packet and a prepared receipt before delivery. Use one stable
   dispatch ID for transport retries. The adapter must support deduplication or
   reconciliation by ID. Lost acknowledgment means delivery UNKNOWN, not “send
   again.” Recover the existing run before creating a replacement.
6. Record acknowledgment/run identity and result; reobserve repository and
   acceptance state afterward. Do not equate worker exit zero with completion.

A cooperative local lock does not exclude external agents or human pushes. Use
isolated workspaces and expected-parent/ref checks when publishing results. Never
force-push over concurrent work. Initial trial serializes mutating jobs within one
repository; separate repositories may run concurrently. This avoids pretending
nonoverlapping files prove semantic independence. Later file-overlap checks can
reduce false waits, but dependencies and shared generated interfaces still matter.

Fresh immediately before dispatch: head/base/dependencies; active worker and lease;
spec version plus relevant correction watermark; PR/issue state if used for the
decision; required check run/checkout/result; collection completeness. Historical
and reusable: original authorized source revision, failed attempts, original
human decision, immutable artifact receipts under AICI's explicit reuse rules.
Refresh bindings without erasing historical identity. No elapsed-time TTL alone
makes evidence fresh.

Cross-thread corrections require an observation channel. A repository registry
cannot know a message it never receives. The trial must either provide a session
event adapter that routes corrections to registered jobs, or explicitly lack
automatic mutating dispatch when that coverage is unknown. Do not claim global
freshness from a local context hash. Do not solve this by forcing the user to
repeat every correction in GitHub.

## Continuation packet

Same trustworthy session: send the unresolved acceptance IDs, concise next action,
spec revision, expected state and prohibitions; link unchanged receipts. Confirm
the session has the expected context watermark. Replacement/restarted session:
also include a compact completed/unresolved summary grounded in inspected state,
authoritative job text or resolvable reference, previous attempt, blockers and
prior corrections. If the receiving worker cannot access a reference, inline its
necessary content; do not assume a URL restores context.

Required envelope: job/attempt/dispatch ID; worker ID; controller generation;
spec/source-authority references and digests; repository/branch/head/base;
dependency identities; context watermark and coverage; allowed operation class;
first unresolved criterion; relevant receipts; explicit exclusions; stop condition.
Keep model rationale separate from the instruction. Never execute a model-supplied
shell command as controller code.

Example instruction, **synthetic and not dispatched**:

> Continue the retained translation under the registered specification. Complete
> acceptance item T4 using the original source revision. Preserve discarded
> features as discarded. Verify the expected branch/head and active specification
> before editing. Do not redesign, weaken T4, merge, publish, or alter other work.
> If those identities changed, return the changed facts without mutating the tree.

## Receipts and scheduling

Append immutable attempt records and atomically update only the current pointer.
Record observation identities and scope; spec/authority; classifier/prompt/config;
chosen action/reason/operation class; why authority applies; exact packet hash and
private packet location; expected heads; lease generation; delivery state/run ID;
result and independently observed after-state; unresolved obligations; predecessor
and successor. Preserve PREPARED, DELIVERY_UNKNOWN, INTERRUPTED and failed records.
Do not publish private job content merely to make a receipt reproducible.

Wake on worker completion, named dependency/check changes, or a bounded recovery
inspection after a lost event. No repeated polling prompt while work is running.
Use fair rotation among eligible registered jobs so a permanently repairable
failure cannot monopolize supervision. Bound no-progress retries by unchanged
obligation/evidence fingerprints. Repeated failure triggers diagnosis, not new
authority and not endless “continue.” A single human question should persist until
answered or invalidated; do not ask it on every sweep.

## Deliberately unautomated in the first trial

Unregistered-thread activation, contested architecture, irreversible actions,
paid capacity expansion, communications, credentials/security changes, physical
acceptance, and broad cleanup remain excluded. Each lacks either supplied
authority, a reliable observation channel, or an accepted actuator. Ordinary
registered in-scope implementation and evidence collection are the intended
automation target, not collateral omissions.
