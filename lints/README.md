# lints/ — diff-scoped taste checks

A starter kit for mechanical checks that fail a build when a diff *adds*
something you don't want. The idea: a rule that keeps coming up in review
becomes a check that applies everywhere automatically — and the error message
tells you exactly how to fix it.

## The example

`lint-comments.sh` + `lint-comments.awk` fail when added lines introduce:

- **`// Do nothing`** filler — an empty branch narrating itself.
- **`// PR #123` / `// #123:`** history notes — git and the PR already carry these.

## Why diff-scoped

The checker inspects only *added* (`+`) lines. Pre-existing violations in the
tree never trigger — so you can adopt it on a messy repo without a big-bang
cleanup that gets the lint disabled on day one. It enforces the rule going
forward, on every new line. Old debt is a separate, gradual cleanup.

## Run it

```sh
./lint-comments.sh                       # staged changes (pre-commit)
./lint-comments.sh --base origin/main    # a rev range (CI)
./lint-comments.test.sh                  # validate the checker
```

## Wire it into a repo

CI is a fresh checkout and can't see this harness, so **vendor**
`lint-comments.sh` + `.awk` into the repo (e.g. `scripts/`) and add a CI step:

```yaml
- run: chmod +x scripts/lint-comments.sh && scripts/lint-comments.sh --base origin/main
```

For pre-commit (husky), call it with no args — it checks `git diff --cached`.
Bypass a genuine exception with `git commit --no-verify`.

## Make it your own

Copy the structure to add your own checks: a thin `.sh` that picks the diff
(staged vs `base..HEAD`) and pipes it to an `.awk` that prints
`file:line: how to fix` and exits non-zero on any finding. Keep it diff-scoped
and keep the fix in the message.
