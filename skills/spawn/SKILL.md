---
name: spawn
description: Spawn a background Claude session in a new git worktree. Opens in a new tmux window or iTerm2 tab.
user-invocable: true
disable-model-invocation: true
allowed-tools: Bash(*/.claude/skills/spawn/spawn.sh *)
argument-hint: "<prompt for the new session>"
---

# Background Claude Session

Spawn a new Claude Code session in a separate git worktree, opening it in a new tmux window or iTerm2 tab so you can interact with it directly.

## Steps

1. **Require a prompt.** If `$ARGUMENTS` is empty, ask the user what the new session should work on. Do not proceed without a prompt. If `$ARGUMENTS` is non-empty, accept it as-is — do NOT judge, rewrite, or reject the prompt. Any non-empty string is valid, even single words like "hi" or "test".

2. **Derive a worktree name (pure logic — no tool call).** Take the first 4 words of `$ARGUMENTS`, lowercase them, replace non-alphanumeric characters with hyphens, collapse multiple hyphens, trim leading/trailing hyphens, and truncate to 30 characters (trimming at the last hyphen boundary to avoid cutting mid-word). Example: "Fix linting issues in auth module" -> `fix-linting-issues-in`. Store this as `SLUG`.

3. **Launch.** Run a single Bash command:
   ```bash
   $SKILL_DIR/spawn.sh '<SLUG>' '<ESCAPED_PROMPT>'
   ```
   Where `<ESCAPED_PROMPT>` is `$ARGUMENTS` with every single quote (`'`) replaced by `'\''`.

   The script handles everything: dirty-tree warnings, worktree name collision detection, terminal detection (tmux vs iTerm2), `cd` to the correct directory, and launching the session.

4. **Report back and stop.** Relay the script's output to the user, then stop — do not run any more commands. Key info:
   - The worktree name (note: `claude -w` automatically prefixes the branch with `worktree-`, e.g. passing `fix-auth-bug` creates a branch called `worktree-fix-auth-bug`)
   - That the session is running in a **new tmux window** or **new iTerm2 tab**
   - They can switch to that window/tab to interact with it
   - The worktree is automatically cleaned up if no changes are made. If changes exist, Claude will prompt whether to keep or remove it.
