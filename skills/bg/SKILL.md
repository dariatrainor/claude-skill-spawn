---
name: bg
description: Spawn a background Claude session in a new git worktree. Opens in a new iTerm2 tab.
user-invocable: true
disable-model-invocation: true
allowed-tools: Bash(claude *), Bash(git worktree *), Bash(osascript *), Bash(pwd)
argument-hint: "<prompt for the new session>"
---

# Background Claude Session

Spawn a new Claude Code session in a separate git worktree, opening it in a new iTerm2 tab so you can interact with it directly.

## Steps

1. **Require a prompt.** If `$ARGUMENTS` is empty, ask the user what the new session should work on. Do not proceed without a prompt.

2. **Derive a worktree name.** Take the first 3-4 words of `$ARGUMENTS`, lowercase them, replace non-alphanumeric characters with hyphens, collapse multiple hyphens, trim leading/trailing hyphens, and truncate to 30 characters (trimming at the last hyphen boundary to avoid cutting mid-word). Example: "Fix linting issues in auth module" -> `fix-linting-issues-in`.

3. **Check for worktree name collision.** Run `git worktree list` and check if any worktree path ends with the derived name (match against the basename of each path). If it does, append `-2` (or `-3`, etc.) until the name is unique.

4. **Get the current working directory.** Run `pwd` via Bash. Store the result as `CWD`.

5. **Build the shell command string.** Construct this exact string (with substitutions):
   ```
   cd <CWD> && claude -w <SLUG> '<ESCAPED_PROMPT>'
   ```
   - `<CWD>` = absolute path from step 4
   - `<SLUG>` = worktree name from step 2 (after collision check in step 3)
   - `<ESCAPED_PROMPT>` = `$ARGUMENTS` with every single quote (`'`) replaced by `'\''` (end the single-quoted string, insert an escaped literal quote, restart the single-quoted string). No other escaping is needed — single-quoted strings in shell treat all characters literally.

   **Example:** If CWD is `/Users/me/project`, slug is `fix-auth-bug`, and prompt is `Fix the auth bug`:
   ```
   cd /Users/me/project && claude -w fix-auth-bug 'Fix the auth bug'
   ```

   **Example with a single quote in the prompt:** prompt is `Fix the user's auth bug`:
   ```
   cd /Users/me/project && claude -w fix-the-users-auth 'Fix the user'\''s auth bug'
   ```

6. **Launch in a new iTerm2 tab.** Run the following osascript command **exactly once**. Do NOT retry, verify, or run it again — a single execution is all that is needed. Pass the command string from step 5 as the `write text` value. The osascript MUST look like this (with the FULL command from step 5 as COMMAND_STRING):
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

   **Escaping for the AppleScript layer:** The `write text` value sits inside an AppleScript double-quoted string. Within COMMAND_STRING, escape any literal `\` as `\\` and any literal `"` as `\"`. The single quotes from step 5 need no escaping here — they are just characters inside the AppleScript double-quoted string.

   **Example with special characters:** If the shell command from step 5 is:
   ```
   cd /Users/me/project && claude -w fix-path-issue 'Fix the C:\Users path "bug"'
   ```
   Then COMMAND_STRING inside `write text` becomes:
   ```
   cd /Users/me/project && claude -w fix-path-issue 'Fix the C:\\Users path \"bug\"'
   ```

   **MANDATORY CHECK before running:** Visually confirm the `write text` value starts with `cd /`. If it does not start with `cd /`, you have forgotten the cd — fix it before running.

7. **Report back and stop.** Tell the user the following, then stop — do not run any more commands:
   - The worktree name that was created
   - That the session is running in a new iTerm2 tab
   - They can switch to that tab to interact with it
   - The worktree is automatically cleaned up if no changes are made. If changes exist, Claude will prompt whether to keep or remove it.
