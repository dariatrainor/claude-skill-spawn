# bg — Background Claude Session Skill

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill that spawns a new Claude session in a separate git worktree, opening it in a new iTerm2 tab.

## What it does

- Takes a prompt describing the task for the new session
- Creates a git worktree with an auto-derived name
- Opens a new iTerm2 tab running `claude -w <worktree> '<prompt>'`
- Lets you work on parallel tasks without leaving your current session

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- [iTerm2](https://iterm2.com/)
- macOS (uses `osascript`)

## Installation

Add this skill to your Claude Code configuration by referencing this repo. For example, in your `.claude/settings.json`:

```json
{
  "skills": [
    "github:dariatrainor/claude-skill-bg"
  ]
}
```

## Usage

From within a Claude Code session:

```
/bg Fix the authentication bug in the login flow
```

This will open a new iTerm2 tab with a Claude session working in a dedicated worktree. The new terminal tab opens in the same working directory as the parent session.
