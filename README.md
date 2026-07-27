# base-harness

A minimal, shareable harness for agent-assisted development (Claude Code + Codex).
It gives you three things, wired to work identically on the host and inside
devcontainers:

1. **Rules** — a parent-directory `CLAUDE.md` / `AGENTS.md` that every repo and
   worktree underneath inherits for free (no per-repo setup).
2. **Skills** — a folder of agent skills (`SKILL.md` files) linked into each
   checkout via relative symlinks, so they resolve on the host and in containers.
3. **Worktrees** — helpers that create devcontainer-portable git worktrees and
   link the skills into them automatically.

Nothing here is project-specific. Fork it, drop your own skills into `skills/`,
edit `context/CLAUDE.md` to your conventions, and you have the same setup.

## Layout

```
install.sh         links skills/ into a repo or worktree checkout (relative links)
new-worktree.sh    create a devcontainer-portable worktree with skills linked
remove-worktree.sh remove a worktree made by new-worktree.sh
context/CLAUDE.md  shared workflow rules; AGENTS.md is a symlink to it
context/<repo>.md  optional per-repo conventions, symlinked back as each repo's
                   local CLAUDE.md (see example-repo.md)
skills/            your agent skills — one folder per skill, each with a SKILL.md
setup/             paste-ready settings templates (project allowlist + SessionStart hook)

# Multi-session operating model (optional — delete if you work one session at a time)
DECISIONS.md       locked policy the skills/runbook defer to (autonomy ceilings, hard rules)
RUNBOOK.md         how to run multiple concurrent sessions through shared state
queue.md           the attention surface — what's waiting on whom, in priority order
STATE.md           in-flight work + the claim mechanism (collision avoidance, resume)
standups/          dated planning notes; each is the next one's input
memory/            durable facts — one per file, indexed in MEMORY.md (self-improving)
lints/             diff-scoped taste checks with remediation text (starter kit + example)
```

## How distribution works

- **Rules** — check this repo out as a sibling of your project repos, then
  symlink `context/CLAUDE.md` to a parent `CLAUDE.md` and `AGENTS.md`. Claude Code
  and Codex read instruction files from parent directories, so every repo and
  worktree underneath inherits them with zero setup. Repo-specific conventions
  layer on top via each repo's own local `CLAUDE.md` symlink.
- **Skills** — skills are only discovered inside a checkout, so each repo/worktree
  needs `./install.sh <path>` once (idempotent; creates **relative** `.claude/skills`
  and `.agents/skills` symlinks). A SessionStart hook (see `setup/`) runs it
  automatically for checkouts that are missing the links.

## Devcontainers

For the host-path → `/workspaces` remap to keep everything working inside a
container, mount the *parent* directory (the one holding both this harness and
your repos) at `/workspaces`, e.g. in `.devcontainer/devcontainer.json`:

```json
"workspaceMount": "source=${localWorkspaceFolder}/..,target=/workspaces,type=bind,consistency=cached",
"workspaceFolder": "/workspaces/<your-repo>"
```

Then inside the container the parent rules, the skills, and the relative skill
symlinks all resolve with nothing extra to configure. (If a repo's devcontainer
mounts only itself, host sessions are unaffected — only in-container sessions
lack the shared skills and rules.)

## Worktrees

Use the helpers, not raw `git worktree`:

```sh
./new-worktree.sh <repo-dir-or-name> <branch> [base-ref]
./remove-worktree.sh ../<repo>-<branch> [--delete-branch]
```

`new-worktree.sh` places the worktree as a sibling of the repo under the parent
dir (so it's inside the devcontainer mount), rewrites git's worktree link files
to relative paths (host git < 2.48 writes absolute ones that dangle in the
container), and links the skills. `remove-worktree.sh` exists because plain
`git worktree remove` on git < 2.48 rejects those relative links.

## Setting up a new machine

```sh
git clone <this-repo> ~/Development/<parent>/base-harness
cd ~/Development/<parent>
ln -s base-harness/context/CLAUDE.md CLAUDE.md
ln -s base-harness/context/CLAUDE.md AGENTS.md
# Optional: per-repo conventions, one line per repo
ln -s ../base-harness/context/<repo>.md <repo>/CLAUDE.md
# Link skills into each repo (idempotent)
./base-harness/install.sh <repo>
```

Then apply the settings templates in `setup/` (project allowlist + SessionStart
hook). Add `<repo>/.git/info/exclude` entries for `CLAUDE.md` and `.agents/` if a
repo's `.gitignore` doesn't already cover them.
