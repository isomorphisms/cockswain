# Chat history

Chat history is a first-class context source, but not an authority about external state.

## Sources

Cockswain should eventually accept several history adapters:

1. normalized local ChatGPT export;
2. a private/versioned history repository;
3. a live ChatGPT UI adapter;
4. synthetic/public regression fixtures.

The initial repository implements (1) and (4), plus a local join from normalized recent history into private evaluation work items.

## ChatGPT export normalization

`bin/import-chatgpt-export` reads the `conversations.json` file from a ChatGPT data export.

For each conversation it:

- preserves the conversation id and title;
- chooses `current_node` when supplied by the export;
- otherwise chooses the latest message node as a fallback leaf;
- follows parent links back to the root so alternate abandoned branches are not mixed into the active transcript;
- preserves each selected message's node id, parent id, role, time, and text.

This is intentionally local processing. Exported chat data can contain personal information and must not be committed to this public repository.

## Recent-history evaluation cases

`bin/cockswain-recent-cases list NORMALIZED_HISTORY.json [COUNT]` sorts normalized conversations by update time and prints the id, time, title, and a short excerpt of the last user message. This is a local selection aid; it does not write a corpus.

`bin/cockswain-recent-cases build NORMALIZED_HISTORY.json CASE_SPEC.json OUTPUT_DIR` joins selected conversations to an independently authored local case spec. The spec supplies:

- `conversation_id`;
- `case_id`;
- `expected_action`;
- `goal`;
- objective `state`;
- `unresolved` items;
- `done_when` conditions;
- optionally `history_messages`.

The builder supplies only the selected active-branch history and its source metadata. It deliberately does not infer the expected action, objective state, or completion conditions from chat. That would turn non-authoritative history into the evaluation oracle.

By default the last 12 messages are attached. `COCKSWAIN_HISTORY_MESSAGES` changes that default; per-case `history_messages` overrides it. A value of `0` keeps the full active branch.

If the output directory is inside the Cockswain checkout, the builder refuses any location outside `.private/`. Files are written with a private umask. Keep the case spec there too, because goals and objective state can also contain private project information.

## Authority order

When sources disagree, use this order unless a work-item contract says otherwise:

1. current objective evidence (for example GitHub state and durable receipts);
2. explicit project policy/AGENTS instructions and work-item completion criteria;
3. durable Cockswain state;
4. chat history.

A chat statement such as "all checks pass" is a clue to verify, not proof.

## Live sidebar history

Live ChatGPT browser/sidebar access is a later adapter. Cockswain's core schema does not depend on it. The same normalized `chat_history` field is intended to receive history from either exported/local records or a UI-driving adapter.
