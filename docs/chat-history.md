# Chat history

Chat history is a first-class context source, but not an authority about external state.

## Sources

Cockswain should eventually accept several history adapters:

1. normalized local ChatGPT export;
2. a private/versioned history repository;
3. a live ChatGPT UI adapter;
4. synthetic/public regression fixtures.

The initial repository implements (1) and (4).

## ChatGPT export normalization

`bin/import-chatgpt-export` reads the `conversations.json` file from a ChatGPT data export.

For each conversation it:

- preserves the conversation id and title;
- chooses `current_node` when supplied by the export;
- otherwise chooses the latest message node as a fallback leaf;
- follows parent links back to the root so alternate abandoned branches are not mixed into the active transcript;
- preserves each selected message's node id, parent id, role, time, and text.

This is intentionally local processing. Exported chat data can contain personal information and must not be committed to this public repository.

## Authority order

When sources disagree, use this order unless a work-item contract says otherwise:

1. current objective evidence (for example GitHub state and durable receipts);
2. explicit project policy/AGENTS instructions and work-item completion criteria;
3. durable Cockswain state;
4. chat history.

A chat statement such as "all checks pass" is a clue to verify, not proof.

## Live sidebar history

Live ChatGPT browser/sidebar access is a later adapter. Cockswain's core schema does not depend on it. The same normalized `chat_history` field is intended to receive history from either exported/local records or a UI-driving adapter.
