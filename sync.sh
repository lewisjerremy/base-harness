#!/usr/bin/env bash
# sync.sh — the agent adapter.
#
# One source of truth (context/, skills/, memory/, agents/) fanned out to every
# coding agent a checkout might be opened with. Idempotent. Uses RELATIVE
# symlinks so the links resolve on the host AND inside devcontainers that mount
# the parent dir at /workspaces.
#
# Why this exists: agents disagree on where rules/skills/settings live. Rather
# than N hand-maintained copies per repo, we keep canonical files here and
# generate the per-agent shadows. Add an agent = add a block below + a folder
# under agents/. See agents/README.md for the full mapping.
#
# What this links into a checkout:
#   skills/                       -> .claude/skills            (Claude Code)
#   skills/                       -> .agents/skills            (Codex AND pi)
#   agents/claude/settings.json   -> .claude/settings.local.json
#   agents/pi/settings.json       -> .pi/settings.json
#   context/CLAUDE.md             -> .github/copilot-instructions.md   (Copilot)
#
# Rules reach Claude Code, Codex, and pi for FREE via the parent-directory walk
# (they all read CLAUDE.md / AGENTS.md). Copilot is the only one that needs a
# per-checkout rules file because it does not walk parents.
#
# Usage: ./sync.sh [target-checkout-path]   (defaults to current directory)
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$(cd "${1:-.}" && pwd)"

if [ ! -e "$TARGET/.git" ]; then
  echo "sync: $TARGET is not a git checkout" >&2
  exit 1
fi

relpath() { # relpath <target> <from-dir>
  python3 -c 'import os,sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))' "$1" "$2"
}

# link <source-relative-to-harness> <dest-relative-to-checkout>
# Idempotent. Refuses to clobber a real (non-symlink) file/dir — remove it
# manually first if it should be the shared link.
link() {
  local src="$HERE/$1" dest="$TARGET/$2" rel
  if [ ! -e "$src" ]; then
    echo "skip: $1 (not present in harness)"
    return
  fi
  rel="$(relpath "$src" "$(dirname "$dest")")"
  if [ -L "$dest" ]; then
    if [ "$(readlink "$dest")" = "$rel" ]; then
      echo "ok: $2 already linked"
      return
    fi
    rm "$dest"
  elif [ -e "$dest" ]; then
    echo "skip: $2 exists and is not a symlink — remove it first if it should be the shared link" >&2
    return
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s "$rel" "$dest"
  echo "linked: $2 -> $rel"
}

# --- skills (shared by every skill-aware agent) ---
link skills                 .claude/skills        # Claude Code
link skills                 .agents/skills        # Codex + pi (both discover this dir)

# --- per-agent settings / instructions written into the checkout ---
link agents/claude/settings.json   .claude/settings.local.json
link agents/pi/settings.json       .pi/settings.json
link context/CLAUDE.md             .github/copilot-instructions.md   # Copilot (no parent walk)

echo "synced: $TARGET"
