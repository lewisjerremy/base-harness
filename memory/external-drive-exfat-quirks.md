---
name: external-drive-exfat-quirks
description: The LewisOS projects live on an exFAT external drive, which creates AppleDouble ._ files and flips git file modes.
metadata:
  type: project
---

All LewisOS repos (BarL4, Ranch.Bot, etc.) live under
`/Volumes/X9 Pro/Development/LewisOS/` — an **exFAT** external drive.

## Why

exFAT has no Unix permissions or resource forks. macOS compensates by writing
**AppleDouble** files (`._<name>`) for every real file, and by surfacing every
file as mode `100755` regardless of intent. The result in git: hundreds of
spurious "mode change 100644 → 100755" entries and a flood of `._*` untracked
files.

## How to apply

- `git config core.fileMode false` in each repo (already set in BarL4) so mode
  flips don't show as changes.
- `.gitignore` carries `._*` (and the harness `.gitignore` carries `._*` +
  `._*/`). Don't commit AppleDouble files — delete them if they slip in.
- Symlinks **do** work on this drive (macOS's exFAT driver supports them), so
  the base-harness relative-symlink model works here.
