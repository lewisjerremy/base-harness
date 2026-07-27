# lint-comments.awk — fail when a git diff ADDS a filler or history comment.
# Diff-scoped: only `+` lines are checked, so existing comments never trigger.
# Reads a `git diff -U0` stream (piped in), prints "file:line: how to fix" per
# finding, exits 1 if any matched.

/^@@/         { line = substr($0, index($0,"+")+1)+0; next }
/^\+\+\+ b\// { file = substr($0, 7); next }

/^\+/ {
    if (file !~ /\.(cs|ts|tsx|js|jsx)$/) { line++; next }
    c = substr($0, 2); sub(/^[ \t]+/, "", c)        # added content, trimmed

    if (c ~ /^\/\/[ \t]*([Dd]o nothing|nothing (here|to do))[ \t]*$/)
        { printf "%s:%d: do-nothing: delete the filler comment\n", file, line; found=1 }
    else if (c ~ /PR #[0-9]+/ || c ~ /^\/\/[ \t]*#[0-9]+[: -]/)
        { printf "%s:%d: changelog-ref: delete; the PR/issue carries it\n", file, line; found=1 }

    line++
}

END { exit found ? 1 : 0 }
