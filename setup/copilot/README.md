# setup/copilot/

Copilot has **no global auto-sync hook**. It runs inside the editor and reads
`.github/copilot-instructions.md` from the repo root on demand — so the only
thing to keep in sync is that one file, which `sync.sh` creates as a symlink to
`context/CLAUDE.md`.

## Workflow

Run `sync.sh <repo>` once per repo after cloning:

```sh
/Absolute/Path/To/Your/Parent/Dir/base-harness/sync.sh <repo>
```

Because the result is a **relative symlink**, later edits to `context/CLAUDE.md`
propagate automatically — you only re-run `sync.sh` to create the link in a
fresh checkout.

## Notes

- If you also use Claude Code or pi, their auto-sync hooks already run
  `sync.sh`, which creates the Copilot instructions link as a side effect. So
  Copilot "just works" once any auto-synced agent has opened the checkout.
- See [`../../agents/copilot/`](../../agents/copilot/) for the symlink-vs-real-file
  caveat if a tool refuses to follow symlinks.
