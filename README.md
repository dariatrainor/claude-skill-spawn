# bg — Background Claude Session Skill

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill that spawns a new Claude session in a separate git worktree, opening it in a new iTerm2 tab. Use it when you have an idea that doesn't belong on your current branch — kick it off in the background without breaking your flow.

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

From within a Claude Code session:

```
/plugin marketplace add dariatrainor/claude-skill-bg
/plugin install bg
```

Or manually — copy `skills/bg/SKILL.md` into `~/.claude/skills/bg/SKILL.md` (personal) or `.claude/skills/bg/SKILL.md` (per-project).

## Usage

From within a Claude Code session:

```
/bg Fix the authentication bug in the login flow
```

This will open a new iTerm2 tab with a Claude session working in a dedicated worktree. The new terminal tab opens in the same working directory as the parent session.

## Why use it

When you're deep in a task and notice something else that needs doing — a failing lint rule, a stale dependency, a quick hotfix — you don't want to context-switch. `/bg` lets you kick off that work in parallel without losing your place.

Some examples:

```
/bg Fix the eslint warnings in src/utils
/bg Run npm audit fix and commit the result
/bg Bump axios to latest to resolve the CVE
/bg Add missing unit tests for the UserService class
```

It also works as a **runnable todo note**. If you think of something that needs doing but aren't ready to break your flow, fire off a `/bg` and come back to that tab when you're at a natural stopping point. The session starts immediately in its own worktree, so by the time you switch over, it may already be done — or waiting for your input.
