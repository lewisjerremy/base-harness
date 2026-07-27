# memory/

Shared **durable facts** — one fact per markdown file, indexed in `MEMORY.md`.

This is the self-improving part of the harness. Agents (and humans) write down
things that aren't derivable from the code or the tickets: a decision and *why*
it was made, a gotcha that bit once, a business rule, an environment quirk. Any
agent in any worktree, on any machine, or inside a devcontainer reads the same
files via the parent mount.

## What belongs here

- A decision and the reasoning behind it (the *why*, not just the *what*).
- A gotcha or environment quirk that isn't obvious from reading the code.
- Business context or domain rules an agent can't infer.
- A repeatedly-useful fact about how the project is structured.

## What does NOT belong here

- Session-local trivia (what you did this hour — that goes in `STATE.md`).
- Policy on *how the harness behaves* — that goes in `DECISIONS.md`.
- Anything easily re-derived from code, tickets, or git history.

## How to use it

- **At task start:** skim `MEMORY.md`, open the entries relevant to the task.
- **When you learn something durable:** write `memory/<fact>.md`, add or refresh
  its line in `MEMORY.md`, and commit + push this repo with a plain one-line
  message.
- **When a memory proves wrong or stale:** correct or delete it the same way.

## File format

```markdown
---
name: short-kebab-name
description: One sentence — what this fact is.
metadata:
  type: project  # project | reference | feedback | user
---

The fact, in a sentence or two.

## Why
The context that makes it non-obvious.

## How to apply
What an agent should do (or avoid) because of this.
```
