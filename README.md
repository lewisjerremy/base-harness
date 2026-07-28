# base-harness

A minimal, **agent-agnostic** harness for agent-assisted development. Keep one
canonical copy of your rules, skills, memory, and settings; a single `sync.sh`
fans them out to whichever coding agents you actually use — Claude Code, Codex,
Copilot, and pi — and keeps them in step.

## Why this exists

Coding agents have evolved fast and keep evolving, and the providers are
inconsistent. They disagree on three things, and the disagreement is where all
the churn lives:

1. **Rules** — Claude Code reads `CLAUDE.md`, Codex reads `AGENTS.md`, pi reads
   either, Copilot reads `.github/copilot-instructions.md`, Cursor reads
   `.cursor/rules/`. They also disagree on *whether* they walk parent dirs.
2. **Skills** — Claude Code: `.claude/skills`. Codex: `.agents/skills`. pi:
   `.agents/skills` + `.pi/skills` + a settings array. Copilot: no native
   concept. Same word, different contracts.
3. **Settings / permissions / hooks** — each agent has its own schema and file
   location. Claude Code's `permissions.allow` and `hooks.SessionStart` have no
   equivalent in Codex's `~/.codex/config.toml`; pi expresses the same needs in
   TypeScript extensions, not JSON.

The naive way to share memory / skills / context across Codex, Claude Code,
Copilot, and pi is **N copies of everything** — N instruction files, N skill
directories, N settings formats — in every repo. Every agent update or new
agent is then churn: rename a discovery path, hand-port a settings schema,
re-test that memory is still discoverable. The copies drift.

This harness keeps **canonical** files in one place and generates the per-agent
shadows. Adding an agent is one folder under `agents/` and one block in
`sync.sh` — not N hand-maintained copies across every repo.

## The model

```
                 ┌── context/CLAUDE.md (= AGENTS.md)   canonical rules
  ONE SOURCE ────┼── skills/                            canonical skills
                 ├── memory/                            canonical durable facts
                 └── agents/<agent>/                    per-agent settings templates
                               │
                          sync.sh <checkout>
                               │  relative symlinks → resolve on host + in devcontainers
                               ▼
                        each repo / worktree
```

`sync.sh <checkout>` links the canonical sources into a checkout at the paths
each agent actually reads. Agents that discover rules by walking parent
directories (Claude Code, Codex, pi) need **no** per-checkout rules file — they
pick up the parent `CLAUDE.md`/`AGENTS.md` symlink for free. Agents that don't
walk parents (Copilot) get a per-checkout link.

## What goes where

| Agent | Rules | Skills | Per-checkout settings (synced) |
| ----- | ----- | ------ | ------------------------------ |
| Claude Code | parent `CLAUDE.md` (free) | `.claude/skills` ← `skills/` | `.claude/settings.local.json` ← `agents/claude/settings.json` |
| Codex | parent `AGENTS.md` (free) | `.agents/skills` ← `skills/` | none (global `~/.codex/config.toml` only) |
| pi | parent `AGENTS.md`/`CLAUDE.md` (free) | `.agents/skills` ← `skills/` (auto-discovered) | `.pi/settings.json` ← `agents/pi/settings.json` |
| Copilot | `.github/copilot-instructions.md` ← `context/CLAUDE.md` | — (no native skills) | — |

`.agents/skills` is read by **both** Codex and pi, so one link covers two
agents. See [`agents/README.md`](agents/README.md) for the full adapter map and
how to add an agent.

## Layout

```
sync.sh             the adapter — fans canonical sources into a checkout
install.sh          deprecated alias for sync.sh (kept so old notes/scripts work)
new-worktree.sh     create a devcontainer-portable worktree, then sync it
remove-worktree.sh  remove a worktree made by new-worktree.sh

context/CLAUDE.md   shared rules; AGENTS.md is a symlink to it (Claude+Codex+pi)
context/<repo>.md   optional per-repo conventions (see example-repo.md)
skills/             your agent skills — one folder per skill, each with SKILL.md. Empty by
                    design (the harness ships none). Add your own: `skills/<name>/SKILL.md`.
                    Do NOT put a loose `README.md` here — agents (pi) validate every root
                    `.md` as a skill and reject it for missing frontmatter.
agents/             per-checkout adapter files, one folder per agent (the map)
setup/              one-time USER-GLOBAL installers per agent (auto-sync hooks)

# Multi-session operating model (optional — delete if you work one session at a time)
DECISIONS.md        locked policy the skills/runbook defer to (autonomy ceilings, hard rules)
RUNBOOK.md          how to run multiple concurrent sessions through shared state
queue.md            the attention surface — what's waiting on whom, in priority order
STATE.md            in-flight work + the claim mechanism (collision avoidance, resume)
standups/           dated planning notes; each is the next one's input
memory/             durable facts — one per file, indexed in MEMORY.md (self-improving)
lints/              diff-scoped taste checks with remediation text (starter kit + example)
```

## Setting up a new machine

```sh
git clone <this-repo> ~/Development/<parent>/base-harness
cd ~/Development/<parent>
ln -s base-harness/context/CLAUDE.md CLAUDE.md
ln -s base-harness/context/CLAUDE.md AGENTS.md
# Optional: per-repo conventions, one line per repo
ln -s ../base-harness/context/<repo>.md <repo>/CLAUDE.md
```

Then, for each agent you use, install the one-time auto-sync hook so any
checkout missing its links gets them on session start — see
`setup/<agent>/README.md`. Finally, sync each repo once:

```sh
./base-harness/sync.sh <repo>
```

Add `<repo>/.git/info/exclude` entries for `.claude/`, `.agents/`, `.pi/`, and
`.github/copilot-instructions.md` if the repo's `.gitignore` doesn't already
cover generated agent dirs.

## Devcontainers

For the host-path → `/workspaces` remap to keep everything working inside a
container, mount the *parent* directory (the one holding both this harness and
your repos) at `/workspaces`, e.g. in `.devcontainer/devcontainer.json`:

```json
"workspaceMount": "source=${localWorkspaceFolder}/..,target=/workspaces,type=bind,consistency=cached",
"workspaceFolder": "/workspaces/<your-repo>"
```

`sync.sh` writes **relative** symlinks, so the parent rules, the skills, and the
per-agent settings all resolve inside the container with nothing extra to
configure. (If a repo's devcontainer mounts only itself, host sessions are
unaffected — only in-container sessions lack the shared skills and rules.)

## Worktrees

Use the helpers, not raw `git worktree`:

```sh
./new-worktree.sh <repo-dir-or-name> <branch> [base-ref]
./remove-worktree.sh ../<repo>-<branch> [--delete-branch]
```

`new-worktree.sh` places the worktree as a sibling of the repo under the parent
dir (so it's inside the devcontainer mount), rewrites git's worktree link files
to relative paths (host git < 2.48 writes absolute ones that dangle in the
container), and runs `sync.sh` to link skills + per-agent settings. The relative
links are why `remove-worktree.sh` exists — plain `git worktree remove` on
git < 2.48 rejects them.

## Multi-session operating model (optional)

If you run more than one agent session at a time, the harness ships a
shared-state model for coordinating them: `DECISIONS.md` (locked policy),
`RUNBOOK.md` (the operating manual), `queue.md` (the attention surface),
`STATE.md` (claim/collision/resume), plus `standups/`, `memory/`, and `lints/`.
The headline rule is the **review gate** — a draft can't be marked ready by the
session that built it; a different session reviews it first, so the maintainer's
attention is never the first review pass. Read [`RUNBOOK.md`](RUNBOOK.md) to run
it; delete these files if you work one session at a time.
