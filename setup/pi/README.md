# setup/pi/

One-time, user-global installer for the pi auto-sync extension.

## Install

Copy [`extensions/sync-on-start.ts`](extensions/sync-on-start.ts) into
`~/.pi/agent/extensions/` (pi auto-discovers `*.ts` there). Edit the `PARENT`
constant to the absolute path of your parent dir — the one holding both
`base-harness/` and your project repos.

## What it does

On every pi `session_start`, if the cwd is under your parent dir, it runs
`base-harness/sync.sh <cwd>`. That fans the canonical `context/`, `skills/`,
and `agents/pi/` into the checkout, so a fresh clone or worktree is ready with
no manual step. Errors are swallowed so a non-checkout cwd never breaks startup.

This mirrors the Claude Code SessionStart hook — pi has no JSON "hook"
primitive, so the same idea is expressed as a tiny TypeScript extension
subscribing to the `session_start` lifecycle event.

## Project trust

The first time pi opens a synced checkout, it will prompt to **trust the
project** (because `.pi/` and/or project `.agents/skills` now exist). Approve
once, or run `/trust` to remember the decision.

## The per-checkout half

What gets synced *into* each checkout lives in
[`../../agents/pi/`](../../agents/pi/).
