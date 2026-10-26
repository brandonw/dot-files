#!/usr/bin/env python3
"""PreToolUse gate for deletes.

Permission ask/allow rules are skipped under --dangerously-skip-permissions,
but PreToolUse hooks run in every mode and can deny the tool call. This denies:

- Bash commands that delete: rm and friends, git branch/tag/ref deletes,
  gh/curl DELETE calls, cloud and infra destroys, destructive SQL. Unless the
  command carries USER_REQUESTED_DELETE=1, which Claude is instructed (global
  CLAUDE.md) to add only when Brandon explicitly told it to run that delete.
- Delete actions in MCP and Artifact tools, always: they carry no command to
  mark, so Brandon does those himself.

Commands are matched at command position (start, or after ; && || | ( $( `
and wrappers like sudo/xargs/env), so a pattern inside a grep argument does
not trip it.
"""

import json
import re
import sys

ESCAPE = "USER_REQUESTED_DELETE=1"

# Where a command word can start: the beginning, after a separator, or inside
# `sh -c "..."` / eval, then any wrappers and VAR=value assignments.
START = (
    r"(?:^|[;&|(\n`{]|\$\(|-c\s+[\"']|\beval\s+[\"']?|\b(?:then|do|else)\s)"
    r"\s*(?:(?:sudo|command|exec|nohup|time|env|xargs(?:\s+-\S+)*)\s+)*"
    r"(?:\w+=\S*\s+)*"
)
# The rest of one command: stops at a separator.
REST = r"[^;&|\n]*"

BASH_PATTERNS = [
    # Files.
    rf"{START}(?:\S*/)?(?:rm|rmdir|unlink|shred|srm|trash)(?=\s|$|[;&|)])",
    rf"{START}find\b{REST}\s-(?:delete\b|exec(?:dir)?\s+(?:\S*/)?rm\b)",
    rf"{START}rsync\b{REST}\s--(?:delete|remove-source-files)",
    # Git: files, branches, tags, refs, stashes, worktrees, remotes.
    rf"{START}git(?:\s+-[cC]\s+\S+|\s+--\S+)*\s+"
    r"(?:rm\b|clean\b"
    rf"|branch\b{REST}\s(?:-[a-zA-Z]*[dD]\b|--delete\b)"
    rf"|tag\b{REST}\s(?:-[a-zA-Z]*d\b|--delete\b)"
    rf"|push\b{REST}(?:\s(?:-d|--delete)\b|\s\+?:\S)"
    r"|worktree\s+remove\b|stash\s+(?:drop|clear)\b"
    r"|remote\s+(?:remove|rm)\b|update-ref\s+-d\b|reflog\s+(?:delete|expire)\b)",
    # GitHub and HTTP.
    rf"{START}gh\b{REST}\s(?:delete|--delete-branch)\b",
    rf"{START}gh\s+api\b{REST}(?:-X\s*|--method[=\s]+)DELETE\b",
    rf"{START}(?:curl|wget|xh)\b{REST}(?:-X\s*|--request[=\s]+)DELETE\b",
    rf"{START}https?\s+DELETE\b",
    # Cloud and infra.
    rf"{START}kubectl\b{REST}\sdelete\b",
    rf"{START}helm\b{REST}\s(?:uninstall|delete)\b",
    rf"{START}(?:terraform|tofu|cdktf|cdktn|pulumi)\b{REST}\s(?:destroy\b|-destroy\b|state\s+rm\b)",
    rf"{START}aws\b{REST}\s(?:delete-\S+|remove-\S+|terminate-\S+|deregister-\S+|rm\b|rb\b)",
    rf"{START}aws\s+s3\s+sync\b{REST}\s--delete\b",
    rf"{START}gcloud\b{REST}\s(?:delete|remove|rm)\b",
    rf"{START}gsutil\b{REST}\s(?:rm|rb)\b",
    rf"{START}gsutil\b{REST}\srsync\b{REST}\s-[a-zA-Z]*d\b",
    rf"{START}az\b{REST}\sdelete\b",
    rf"{START}docker\b{REST}\s(?:rm|rmi|prune)\b",
    rf"{START}docker(?:-compose|\s+compose)\b{REST}\sdown\b{REST}\s(?:-v|--volumes)\b",
    # Databases.
    rf"{START}bq\b{REST}\srm\b",
    rf"{START}redis-cli\b{REST}\b(?i:flushall|flushdb|del|unlink)\b",
]
BASH_RE = [re.compile(p) for p in BASH_PATTERNS]

# Destructive SQL anywhere in a command that runs a database client.
SQL_CLIENT_RE = re.compile(
    rf"{START}(?:psql|mysql|sqlite3|clickhouse(?:-client)?|snowsql|bq|duckdb)\b"
)
SQL_RE = re.compile(
    r"\b(?:drop\s+(?:table|database|schema|index|view|role|user|function)"
    r"|truncate\b|delete\s+from)\b",
    re.IGNORECASE,
)

TOOL_NAME_RE = re.compile(
    r"delete|remove|destroy|purge|uninstall|unset|unpublish|drop", re.IGNORECASE
)


def deny(reason: str) -> None:
    json.dump(
        {
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "deny",
                "permissionDecisionReason": reason,
            }
        },
        sys.stdout,
    )
    sys.exit(0)


def bash_deletes(command: str) -> bool:
    if any(p.search(command) for p in BASH_RE):
        return True
    return bool(SQL_CLIENT_RE.search(command) and SQL_RE.search(command))


def has_delete_action(value: object) -> bool:
    if isinstance(value, dict):
        for key, inner in value.items():
            if key in ("action", "op", "type") and inner == "delete":
                return True
            if has_delete_action(inner):
                return True
    elif isinstance(value, list):
        return any(has_delete_action(item) for item in value)
    return False


def main() -> None:
    try:
        event = json.load(sys.stdin)
    except ValueError:
        sys.exit(0)
    tool = event.get("tool_name") or ""
    tool_input = event.get("tool_input") or {}

    if tool == "Bash":
        command = tool_input.get("command") or ""
        if ESCAPE in command or not bash_deletes(command):
            sys.exit(0)
        deny(
            "Delete gate: never run a delete unless Brandon explicitly told you "
            "to run this specific command in this conversation. Give him the "
            "exact command and what it will remove instead. If he explicitly "
            "told you to run it, re-run the exact command prefixed with "
            f"`{ESCAPE} `."
        )

    if (tool.startswith("mcp__") and TOOL_NAME_RE.search(tool)) or (
        tool.startswith("Artifact") and has_delete_action(tool_input)
    ):
        deny(
            "Delete gate: deletes through tools are always blocked. Tell "
            "Brandon what to delete and where, and let him do it."
        )

    sys.exit(0)


if __name__ == "__main__":
    main()
