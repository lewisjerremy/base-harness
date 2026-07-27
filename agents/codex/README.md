# agents/codex/

Codex adapter. `sync.sh` writes **one** thing into each checkout:

| Canonical source | Linked into checkout as |
| ---------------- | ----------------------- |
| [`../../skills/`](../../skills/) | `.agents/skills` |

Rules come free via the parent `AGENTS.md` symlink (Codex walks parents, same as
Claude Code). There is **no per-checkout settings file** for Codex: its
configuration lives globally in `~/.codex/config.toml`. See
[`../../setup/codex/`](../../setup/codex/) for the global half.

That makes Codex the cheapest agent in the harness — one shared skills link and
the inherited rules, nothing else to keep in sync.
