# Chat history

Chat history is a first-class context source, but not an authority about external state.

## Sources

Cockswain should eventually accept several history adapters:

1. normalized local ChatGPT export;
2. a private/versioned history repository;
3. a live ChatGPT UI adapter;
4. the checked-in public verbatim corpus;
5. synthetic regression fixtures.

## ChatGPT export normalization

`bin/import-chatgpt-export` reads a local `conversations.json` export. It preserves the selected active branch, message ids, parent ids, roles, times, and text. Exported chat can contain personal information and must remain outside this public repository.

`bin/cockswain-recent-cases` joins selected private conversations to independently authored objective state and labels. It does not infer the expected action or external state from chat.

## Public verbatim corpus

The checked-in corpus under `corpus/chat-history/` is real transcript evidence. Every message body is literal text from a real chat message. Summaries and reconstructed intent belong under `corpus/derived-context/` instead.

Evaluation labels under `tests/corpus/` reference messages by file and record number. `bin/cockswain-corpus-cases` performs the extraction so a fixture cannot silently paraphrase or improve the conversation.

A case may reference several records in order, forming a history chunk. Objective state, unresolved work, completion conditions, and expected actions remain outside the transcript.

## Authority order

When sources disagree, use this order unless a work-item contract says otherwise:

1. current objective evidence such as GitHub state and durable receipts;
2. explicit project policy and completion criteria;
3. durable Cockswain state;
4. chat history.

A chat statement such as "all checks pass" is a clue to verify, not proof.

History can still be decision-relevant. For example, an explicit user reservation of a task to the human loop is a policy boundary even though it is not external completion evidence. A history-ablation case may therefore have a different expected action when that reservation is removed.

## Live sidebar history

Live ChatGPT browser/sidebar access is a later adapter. Cockswain's core schema does not depend on it.
