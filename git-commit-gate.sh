#!/bin/bash
# PreToolUse gate for git commits.
#
# Permission ask/allow rules are skipped under --dangerously-skip-permissions,
# but PreToolUse hooks run in every mode and can deny the tool call. This
# blocks any `git commit` unless the command carries the explicit marker
# USER_REQUESTED_COMMIT=1, which Claude is instructed (global CLAUDE.md) to add
# only when Brandon explicitly asked for a commit in the conversation.

INPUT=$(cat)
CMD=$(jq -r '.tool_input.command // empty' <<<"$INPUT")

# Detect a git-commit invocation anywhere in the command (compounds included).
if ! grep -qE '(^|[^A-Za-z0-9_-])git[[:space:]]+commit($|[^A-Za-z0-9_-])' <<<"$CMD"; then
  exit 0
fi

# Escape hatch: deliberate assertion that the user asked for this commit.
if grep -q 'USER_REQUESTED_COMMIT=1' <<<"$CMD"; then
  exit 0
fi

cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Commit gate: never run `git commit` unless Brandon explicitly asked for a commit in this conversation. If he explicitly asked, re-run the exact command prefixed with `USER_REQUESTED_COMMIT=1 `. If he did not ask, do not commit - leave the changes in the working tree and report what is ready."}}
EOF
exit 0
