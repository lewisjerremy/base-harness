# agents/pi/

[pi](https://pi.dev) adapter. `sync.sh` writes two things into each checkout:

| Canonical source | Linked into checkout as |
| ---------------- | ----------------------- |
| [`../../skills/`](../../skills/) | `.agents/skills` (pi auto-discovers this) |
| [`settings.json`](settings.json) | `.pi/settings.json` |

Rules come free via the parent `AGENTS.md`/`CLAUDE.md` symlink — pi walks parent
directories, same as Claude Code and Codex. Skills are *also* free in the sense
that pi auto-discovers `.agents/skills`; the explicit entry in `settings.json`
just documents intent and survives any future change to pi's discovery rules.

## The settings template

[`settings.json`](settings.json) is a pi project-settings file. pi has **no**
`permissions.allow` list (permissions are expressed via TypeScript extensions,
not settings), so this file is intentionally minimal: it pins the skills path
and enables `/skill:name` commands.

## Project trust

The first time pi opens a checkout that now has a `.pi/` dir (or project-level
`.agents/skills`), it will **prompt to trust the project**. That's expected —
approve it (or run `/trust` to remember the decision). See pi's settings docs.

## Auto-sync on session start

Install the one-time global extension in
[`../../setup/pi/extensions/sync-on-start.ts`](../../setup/pi/extensions/sync-on-start.ts)
into `~/.pi/agent/extensions/` so any under-synced checkout gets fixed on
session start.
