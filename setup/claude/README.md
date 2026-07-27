# setup/claude/

One-time, user-global installer for the Claude Code auto-sync hook.

## Install

Merge [`sessionstart-hook.json`](sessionstart-hook.json) into
`~/.claude/settings.json` (replace the placeholder path with the absolute path
to your parent dir — the one holding both `base-harness/` and your project
repos).

## What it does

On every Claude Code `SessionStart`, if the cwd is under your parent dir and
`.agents/skills` is missing, it runs `base-harness/sync.sh .` That fans the
canonical `context/`, `skills/`, and `agents/claude/` into the checkout, so a
fresh clone or a new worktree is ready with no manual step.

The guard (`[ -e .agents/skills ]`) keeps it a no-op on already-synced
checkouts, and the `case` keeps it from firing outside your parent dir.

## The per-checkout half

What gets synced *into* each checkout lives in
[`../../agents/claude/`](../../agents/claude/).
