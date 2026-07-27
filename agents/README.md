# agents/ — per-agent adapters

This folder is the **adapter layer** between the harness's canonical sources
(`context/`, `skills/`, `memory/`) and the agents you open checkouts with.
One subfolder per agent. `sync.sh` reads it and writes the per-checkout files
each agent expects.

## Why this exists

Agents disagree on three things, and the disagreement is where all the churn
lives:

1. **Rules** — Claude Code reads `CLAUDE.md`, Codex reads `AGENTS.md`, pi reads
   either, Copilot reads `.github/copilot-instructions.md`, Cursor reads
   `.cursor/rules/`. They also disagree on *whether* they walk parent dirs.
2. **Skills** — Claude Code: `.claude/skills`. Codex: `.agents/skills`. pi:
   `.agents/skills` + `.pi/skills` + a settings array. Copilot: no native
   concept. Same word, different contracts.
3. **Settings / permissions / hooks** — each agent has its own schema and file
   location. Claude Code's `permissions.allow` and `hooks.SessionStart` have no
   equivalent in Codex's `config.toml`; pi expresses the same needs via
   TypeScript extensions.

The naive answer is N copies of everything in every repo. This folder is the
non-naive answer: **canonical files here, `sync.sh` generates the shadows.**

## The mapping (what `sync.sh` writes per agent)

| Agent | Rules | Skills | Per-checkout settings |
| ----- | ----- | ------ | --------------------- |
| [Claude Code](claude/) | parent `CLAUDE.md` (free) | `.claude/skills` ← `skills/` | `.claude/settings.local.json` ← `claude/settings.json` |
| [Codex](codex/) | parent `AGENTS.md` (free) | `.agents/skills` ← `skills/` | none (global `~/.codex/config.toml` only) |
| [pi](pi/) | parent `AGENTS.md`/`CLAUDE.md` (free) | `.agents/skills` ← `skills/` (auto-discovered) | `.pi/settings.json` ← `pi/settings.json` |
| [Copilot](copilot/) | `.github/copilot-instructions.md` ← `context/CLAUDE.md` | — (no native skills) | — |

"Free" = the agent walks parent directories, so it picks up the parent
`CLAUDE.md`/`AGENTS.md` symlink with nothing written inside the checkout.
`.agents/skills` is read by **both** Codex and pi, so one link covers two agents.

The user-global, one-time half of each adapter (auto-run `sync.sh` on session
start) lives in [`../setup/`](../setup/), not here.

## Adding an agent

1. Make `agents/<agent>/` with whatever per-checkout file(s) it needs (or just a
   `README.md` if it needs none, like Codex/Copilot).
2. Add one or more `link …` lines to [`../sync.sh`](../sync.sh).
3. Add a row to the table above.
4. (Optional) add `setup/<agent>/` with a one-time global hook so `sync.sh`
   runs automatically — see [`../setup/README.md`](../setup/README.md).

That's it — no edits to any project repo, no N-way copy.
