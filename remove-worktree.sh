#!/usr/bin/env bash
# Remove a worktree created by new-worktree.sh.
# (Plain `git worktree remove` fails on git < 2.48 because we store relative
# paths in the worktree link files for devcontainer portability.)
# Usage: ./remove-worktree.sh <worktree-path> [--delete-branch]
set -euo pipefail

WT="$(cd "${1:?usage: remove-worktree.sh <worktree-path> [--delete-branch]}" && pwd)"
[ -f "$WT/.git" ] || { echo "error: $WT is not a linked worktree" >&2; exit 1; }

BRANCH="$(git -C "$WT" symbolic-ref --short HEAD 2>/dev/null || true)"
REPO_GITDIR="$(cd "$WT" && cd "$(sed 's/^gitdir: //' .git)/../.." && pwd)"

if ! git -C "$WT" status --porcelain | grep -q .; then
  rm -rf "$WT"
  git --git-dir="$REPO_GITDIR" worktree prune
  echo "removed: $WT"
  if [ "${2:-}" = "--delete-branch" ] && [ -n "$BRANCH" ]; then
    git --git-dir="$REPO_GITDIR" branch -D "$BRANCH"
    echo "deleted branch: $BRANCH"
  fi
else
  echo "error: $WT has uncommitted changes — commit, stash, or delete manually" >&2
  exit 1
fi
