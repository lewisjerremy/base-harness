#!/usr/bin/env bash
# Link the shared agent skills into a repo or worktree checkout.
# Creates RELATIVE symlinks so they resolve both on the host and inside
# devcontainers that mount the parent dir at /workspaces.
# Usage: ./install.sh [target-checkout-path]   (defaults to current directory)
set -euo pipefail

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skills"
TARGET="$(cd "${1:-.}" && pwd)"

if [ ! -e "$TARGET/.git" ]; then
  echo "error: $TARGET is not a git checkout" >&2
  exit 1
fi

relpath() { # relpath <target> <from-dir>
  python3 -c 'import os,sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))' "$1" "$2"
}

link() {
  local dest="$1"
  local rel
  rel="$(relpath "$SKILLS_DIR" "$(dirname "$dest")")"
  if [ -L "$dest" ]; then
    [ "$(readlink "$dest")" = "$rel" ] && { echo "ok: $dest already linked"; return; }
    rm "$dest"
  elif [ -d "$dest" ]; then
    echo "skip: $dest is a real directory — remove it first if it should be the shared link" >&2
    return
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s "$rel" "$dest"
  echo "linked: $dest -> $rel"
}

link "$TARGET/.claude/skills"
link "$TARGET/.agents/skills"
