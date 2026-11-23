#!/bin/sh
# SessionStart (matcher `compact`): leaves a marker that changes with each
# compaction, which hooks/native.ts reads at the next prompt to re-send the
# task-graph protocol. A command hook, because on managed machines sec-default
# skips the module's `classic.SessionStart` and `session.compact` hooks.
# Prints nothing: SessionStart stdout would land in the conversation.
id=$(sed -n 's/.*"session_id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)
[ -n "$id" ] || id=$CLAUDE_CODE_SESSION_ID
[ -n "$id" ] && [ -n "$CLAUDE_PLUGIN_DATA" ] || exit 0
mkdir -p "$CLAUDE_PLUGIN_DATA" && printf '%s-%s\n' "$(date +%s)" "$$" > "$CLAUDE_PLUGIN_DATA/compacted-$id"
exit 0
