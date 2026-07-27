#!/usr/bin/env bash
# lint-comments.sh — fail when a diff ADDS a filler/history comment that git
# already carries. Thin wrapper over lint-comments.awk.
#
# Diff-scoped by construction: only added (+) lines are checked, so existing
# comments never trigger (no big-bang cleanup that gets the lint disabled).
#
# Usage:
#   lint-comments.sh                              # check staged changes (pre-commit)
#   lint-comments.sh --base origin/main           # check a rev range (CI)
#   LINT_BASE=origin/main lint-comments.sh
# Exit: 0 = clean, 1 = violations found, 2 = usage/git error.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[[ -f "$HERE/lint-comments.awk" ]] || { echo "lint-comments: missing $HERE/lint-comments.awk" >&2; exit 2; }

if [[ "${1:-}" == "--base" ]]; then
  [[ $# -ge 2 ]] || { echo "lint-comments: --base needs a ref" >&2; exit 2; }
  DIFF=(diff "$2..HEAD"); SCOPE="diff $2..HEAD"
elif [[ -n "${LINT_BASE:-}" ]]; then
  DIFF=(diff "${LINT_BASE}..HEAD"); SCOPE="diff ${LINT_BASE}..HEAD"
else
  DIFF=(diff --cached); SCOPE="staged changes"
fi
git rev-parse --git-dir >/dev/null 2>&1 || { echo "lint-comments: not inside a git repo" >&2; exit 2; }

# Two-dot (base..HEAD), not three-dot: shallow CI checkouts have no merge base.
echo "lint-comments: scanning ${SCOPE}..."
set +e
git "${DIFF[@]}" -U0 | awk -f "$HERE/lint-comments.awk"
rc=$?
set -e

[[ $rc -eq 0 ]] && { echo "lint-comments: ok"; exit 0; }
echo "lint-comments: delete-on-sight comments found above. Remove them; --no-verify bypasses locally." >&2
exit 1
