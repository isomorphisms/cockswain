# Verbatim chat history

This directory is transcript evidence, not reconstructed context.

Every message body in this directory must be literal text preserved from a real chat message. Do not put paraphrases, summaries, inferred intent, reconstructed assistant replies, or synthetic continuations here.

Metadata such as date, thread title, role, and source record may be added around the message. The text between `---` and `===` must remain unchanged.

Plain text files are preferred. This corpus is intended to support turn-by-turn and chunk-by-chunk evaluation.

## Current corpus

At this revision:

- 138 literal messages total
- 88 user messages
- 50 assistant messages
- zero duplicate message bodies

Files include literal user messages recovered from recent project threads, literal assistant replies recovered from recent conversation records, and the exact two-sided Cockswain corpus-ingestion discussion where available.

## Rules

- `role: user` means the body is literal user text.
- `role: assistant` means the body is literal assistant text.
- Do not reconstruct missing turns.
- Do not promote a summary into transcript text.
- A partial quote is not a full message; include it only when the source establishes that the quoted text itself is the exact unit being preserved.
- Keep derived summaries and supervision cues outside this directory.

## Privacy boundary

This repository is public. Do not commit credentials, secrets, private repository contents, sensitive personal material, or a complete ChatGPT export here.

A private/local Takeout corpus may contain full two-sided transcripts. Public history should contain only deliberately selected non-personal project messages.

## Derived context

Summaries and reconstructed intent are not chat history. Historical derived records are retained separately under `corpus/derived-context/` and must not be counted as transcript messages.
