#!/usr/bin/env bash
# lint-comments.test.sh — feed synthetic diffs to the checker, assert the catches.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
PASS=0; FAIL=0

run() { # run <label> <diff> <expected-finding-count>
  local got; got=$(printf '%s\n' "$2" | awk -f "$HERE/lint-comments.awk" | grep -c ':' || true)
  if [[ "$got" == "$3" ]]; then echo "  ok   $1 ($got)"; PASS=$((PASS+1))
  else echo "  FAIL $1 — expected $3, got $got"; FAIL=$((FAIL+1)); fi
}

echo "lint-comments.test.sh"
run "catches filler + history refs" \
'diff --git a/x.cs b/x.cs
--- a/x.cs
+++ b/x.cs
@@ -1,1 +1,4 @@
+            // Do nothing
+            // See PR #459
+            // #299: lifted the logic
+            var x = 1;' "3"
run "clean diff is clean" \
'diff --git a/x.cs b/x.cs
--- a/x.cs
+++ b/x.cs
@@ -1,1 +1,1 @@
+        var x = 1;' "0"
run "non-source files ignored" \
'diff --git a/README.md b/README.md
--- a/README.md
+++ b/README.md
@@ -1,1 +1,2 @@
+Do nothing' "0"

echo
echo "$PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
