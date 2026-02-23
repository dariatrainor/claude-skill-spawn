---
name: bg
description: Spawn a background Claude session in a new git worktree. Opens in a new iTerm2 tab.
user-invocable: true
disable-model-invocation: true
allowed-tools: Bash(claude:*), Bash(git worktree:*), Bash(osascript:*), Bash(pwd)
argument-hint: "<prompt for the new session>"
---

# Background Claude Session

Spawn a new Claude Code session in a separate git worktree, opening it in a new iTerm2 tab so you can interact with it directly.

## Steps

1. **Require a prompt.** If `$ARGUMENTS` is empty, ask the user what the new session should work on. Do not proceed without a prompt.

2. **Derive a worktree name.** Take the first 3-4 words of `$ARGUMENTS`, lowercase them, replace non-alphanumeric characters with hyphens, collapse multiple hyphens, trim leading/trailing hyphens, and truncate to 30 characters. Example: "Fix linting issues in auth module" -> `fix-linting-issues-in`.

3. **Get the current working directory.** Run `pwd` via Bash. Store the result as `CWD`.

4. **Build the shell command string.** Construct this exact string (with substitutions):
   ```
   cd <CWD> && claude -w <SLUG> "<ESCAPED_PROMPT>"
   ```
   - `<CWD>` = absolute path from step 3
   - `<SLUG>` = worktree name from step 2
   - `<ESCAPED_PROMPT>` = `$ARGUMENTS` with single quotes, double quotes, and backslashes escaped for shell safety

   **Example:** If CWD is `/Users/me/project`, slug is `fix-auth-bug`, and prompt is `Fix the auth bug`:
   ```
   cd /Users/me/project && claude -w fix-auth-bug "Fix the auth bug"
   ```

5. **Launch in a new iTerm2 tab.** Pass the command string from step 4 as the `write text` value. The osascript MUST look like this (with the FULL command from step 4 as COMMAND_STRING):
   ```bash
   osascript -e 'tell application "iTerm2"
     tell current window
       create tab with default profile
       tell current session
         write text "COMMAND_STRING"
       end tell
     end tell
   end tell'
   ```

   **MANDATORY CHECK before running:** Visually confirm the `write text` value starts with `cd /`. If it does not start with `cd /`, you have forgotten the cd — fix it before running.

6. **Report back.** Tell the user:
   - The worktree name that was created
   - That the session is running in a new iTerm2 tab
   - They can switch to that tab to interact with it
