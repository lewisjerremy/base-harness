# setup/ — one-time, user-GLOBAL installers

This is the global half of the adapter. Where [`../agents/`](../agents/) holds
the **per-checkout** files that `sync.sh` writes into each repo, this folder
holds the **per-user, install-once** hook that runs `sync.sh` automatically so
you never have to remember to sync a fresh checkout.

One subfolder per agent. Each installs differently (Claude Code has a JSON
`SessionStart` hook; pi has a TypeScript `session_start` extension; Codex and
Copilot have no global hook and are synced manually).

| Agent | How to auto-sync | Where it installs |
| ----- | ---------------- | ----------------- |
| [Claude Code](claude/) | JSON `SessionStart` hook | merge into `~/.claude/settings.json` |
| [pi](pi/) | TypeScript `session_start` extension | drop into `~/.pi/agent/extensions/` |
| [Codex](codex/) | no global hook — manual | run `sync.sh <repo>` once per repo |
| [Copilot](copilot/) | no global hook — manual | run `sync.sh <repo>` once per repo |

All paths in these templates are placeholders (`/Absolute/Path/To/Your/Parent/Dir`)
— replace them with the absolute path to the parent dir that holds both this
harness and your project repos.

## The split, restated

- **`agents/<agent>/`** → files that live *inside each checkout* (synced by
  `sync.sh`). Project-scoped.
- **`setup/<agent>/`** → files that live in your *home dir* (installed once).
  User-scoped. They exist only to re-run `sync.sh` when a checkout is missing
  its links.
