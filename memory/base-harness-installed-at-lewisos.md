---
name: base-harness-installed-at-lewisos
description: base-harness is installed as a sibling under LewisOS/ and drives the AI-native workflow; how rules/skills/memory reach each repo.
metadata:
  type: project
---

`lewisjerremy/base-harness` is cloned at `LewisOS/base-harness/` and is the
canonical source for shared rules, skills, memory, and the multi-session
operating model across all LewisOS modules.

## Why

One canonical copy of rules/skills/memory, fanned into each repo by
`sync.sh` via relative symlinks (resolve on host and in devcontainers). Avoids
N drifting copies across repos and agents.

## How to apply

- Shared rules: `LewisOS/CLAUDE.md` and `LewisOS/AGENTS.md` are symlinks to
  `base-harness/context/CLAUDE.md`. pi/Claude/Codex pick these up via parent-dir
  walk for free. Per-repo specifics stay in each repo's own `AGENTS.md`.
- Sync a repo: `./base-harness/sync.sh <repo>` (links `.agents/skills`,
  `.pi/settings.json`, Claude settings, Copilot instructions). Idempotent.
- Worktrees: use `new-worktree.sh`/`remove-worktree.sh` (not raw
  `git worktree`) — they place the worktree as a sibling and re-sync it.
- Auto-sync: `~/.pi/agent/extensions/sync-on-start.ts` re-runs `sync.sh` on
  every pi `session_start` when cwd is under `LewisOS/`.
- First time pi opens a synced checkout it prompts to **trust** the project
  (because `.pi/` / `.agents/skills` exist) — approve or `/trust`.
