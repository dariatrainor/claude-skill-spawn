#!/bin/sh
# Spawns a Claude Code session in a new git worktree.
# Usage: spawn.sh <slug> <prompt>
# Outputs warnings/info to stdout, then launches in tmux or iTerm2.

set -eu

SLUG="$1"
PROMPT="$2"

if [ -z "$SLUG" ] || [ -z "$PROMPT" ]; then
  echo "ERROR: Usage: spawn.sh <slug> <prompt>"
  exit 1
fi

CWD="$(pwd)"

# Check for worktree name collision
WORKTREES="$(git worktree list)"
ORIGINAL_SLUG="$SLUG"
SUFFIX=2
while echo "$WORKTREES" | grep -q "/${SLUG}  "; do
  SLUG="${ORIGINAL_SLUG}-${SUFFIX}"
  SUFFIX=$((SUFFIX + 1))
done

if [ "$SLUG" != "$ORIGINAL_SLUG" ]; then
  echo "NOTE: Worktree name collision. Using '$SLUG' instead of '$ORIGINAL_SLUG'."
fi

# Escape single quotes in prompt for shell: ' -> '\''
ESCAPED_PROMPT="$(printf '%s' "$PROMPT" | sed "s/'/'\\\\''/g")"

# Build the command string
CMD="cd ${CWD} && claude -w ${SLUG} '${ESCAPED_PROMPT}'"

# Detect terminal and launch
if [ -n "${TMUX:-}" ]; then
  tmux new-window -n "$SLUG" "$CMD"
  echo "LAUNCHED: tmux window '$SLUG'"
else
  # Escape backslashes and double quotes for AppleScript double-quote string
  AS_CMD="$(printf '%s' "$CMD" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g')"
  osascript \
    -e 'tell application "iTerm2"' \
    -e 'tell current window' \
    -e 'create tab with default profile' \
    -e 'tell current session' \
    -e "write text \"${AS_CMD}\"" \
    -e 'end tell' \
    -e 'end tell' \
    -e 'end tell'
  echo "LAUNCHED: iTerm2 tab"
fi

echo "WORKTREE: $SLUG (branch: worktree-$SLUG)"
