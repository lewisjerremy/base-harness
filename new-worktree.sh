#!/usr/bin/env bash
# Create a git worktree that works on the host AND inside devcontainers
# (which mount the parent dir at /workspaces).
#
# - Places the worktree as a sibling of the repo under the parent dir.
# - Rewrites git's worktree link files to relative paths (host git < 2.48
#   writes absolute paths, which dangle inside the container).
# - Links the shared skills into the worktree.
#
# Usage: ./new-worktree.sh <repo-dir-or-name> <branch> [base-ref]
#   e.g.  ./new-worktree.sh my-repo 842-fix-timer development
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"   # the parent dir holding repos + this harness
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"      # this harness

REPO_ARG="${1:?usage: new-worktree.sh <repo> <branch> [base-ref]}"
BRANCH="${2:?usage: new-worktree.sh <repo> <branch> [base-ref]}"
REPO="$([ -d "$REPO_ARG" ] && cd "$REPO_ARG" && pwd || echo "$ROOT/$REPO_ARG")"
[ -e "$REPO/.git" ] || { echo "error: $REPO is not a git checkout" >&2; exit 1; }
BASE="${3:-$(git -C "$REPO" symbolic-ref --short HEAD)}"

WT="$ROOT/$(basename "$REPO")-$BRANCH"
NAME="$(basename "$WT")"

if git -C "$REPO" show-ref --verify --quiet "refs/heads/$BRANCH"; then
  git -C "$REPO" worktree add "$WT" "$BRANCH"
else
  git -C "$REPO" worktree add -b "$BRANCH" "$WT" "$BASE"
fi

relpath() { python3 -c 'import os,sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))' "$1" "$2"; }

# Rewrite the two absolute-path link files to relative so the pair survives
# the host-path -> /workspaces remap inside devcontainers.
GITDIR="$REPO/.git/worktrees/$NAME"
printf 'gitdir: %s\n' "$(relpath "$GITDIR" "$WT")" > "$WT/.git"
printf '%s\n' "$(relpath "$WT/.git" "$GITDIR")" > "$GITDIR/gitdir"
git -C "$WT" status --porcelain >/dev/null   # sanity check the rewrite

"$HERE/install.sh" "$WT"
echo "worktree ready: $WT (branch $BRANCH, base $BASE)"
