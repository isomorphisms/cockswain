# Derived context

This directory contains summaries, supervision cues, recovered intent, and other non-verbatim context.

Nothing here counts as chat transcript evidence.

The JSONL files in this directory were moved out of `corpus/chat-history/` because some records mixed exact messages with summarized assistant context or reconstructed intent. They may still be useful for designing evaluation cases, but they must not be presented as literal conversation history.

Use `corpus/chat-history/` for exact messages only.
