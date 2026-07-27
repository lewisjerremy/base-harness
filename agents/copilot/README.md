# agents/copilot/

GitHub Copilot adapter. Copilot is the one agent here that **does not walk
parent directories** for instructions, so `sync.sh` writes one per-checkout file:

| Canonical source | Linked into checkout as |
| ---------------- | ----------------------- |
| [`../../context/CLAUDE.md`](../../context/CLAUDE.md) | `.github/copilot-instructions.md` |

Everything else in the harness (skills, memory, the multi-session state files)
has no native Copilot equivalent, so there's nothing else to adapt. Copilot has
no per-repo settings file in this scheme and no global auto-sync hook — run
`sync.sh <repo>` once per repo (the file is a relative symlink, so it keeps
working in devcontainers and after edits to `context/CLAUDE.md`).

## Notes

- The link is a **symlink**, not a copy, so the rules stay in sync with
  `context/CLAUDE.md` automatically. If a repo wants Copilot-specific trimming
  (e.g. a shorter variant), delete the symlink and commit a real
  `.github/copilot-instructions.md` instead — `sync.sh` won't clobber a real
  file.
- Some CI/tooling refuses to follow symlinks. If Copilot stops seeing the file,
  switch that repo to a real file (and re-copy on rule changes).
