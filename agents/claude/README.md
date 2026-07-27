# agents/claude/

Claude Code adapter. `sync.sh` writes two things into each checkout:

| Canonical source | Linked into checkout as |
| ---------------- | ----------------------- |
| [`../../skills/`](../../skills/) | `.claude/skills` |
| [`settings.json`](settings.json) | `.claude/settings.local.json` |

Rules are **not** written per-checkout — Claude Code walks parent directories
and reads the parent `CLAUDE.md` symlink for free.

## The settings template

[`settings.json`](settings.json) is a Claude Code project-settings file
(`.claude/settings.local.json`). It carries the tool allowlist and an optional
`PostToolUse` lint/format hook. Copy it, trim the allowlist to what each repo
actually needs, and remove anything you don't want auto-approved.

Claude Code has no project-level concept of "permissions inherit from a parent",
so this file does need to land in each checkout — which is exactly what
`sync.sh` does. Editing the template here updates every checkout on the next
sync.

## Auto-sync on session start

So a checkout that's missing its links gets them automatically, install the
one-time SessionStart hook in
[`../../setup/claude/sessionstart-hook.json`](../../setup/claude/sessionstart-hook.json)
into `~/.claude/settings.json`.
