# Development Rules

<!-- TEMPLATE: This is the shared rules file every repo and worktree under the
     parent directory inherits (via the parent CLAUDE.md / AGENTS.md symlinks).
     Edit it to match your project's conventions, then remove these comments. -->

These rules apply to all work in the repos under this parent directory, including
git worktrees and devcontainers. They override default agent behavior.

## Repo roles

<!-- Describe who owns / reviews what. Example: -->
- **<main-repo>**: <owner> is the sole developer; <reviewer> reviews.
- **<other-repo>**: <reviewer> is the main contributor; <owner> is the main reviewer.

## Identity & attribution

- Commit as `<name> <<email>>` (the configured git user). **Never add AI
  attribution anywhere**: no `Co-Authored-By: Claude ...` trailers, no "Generated
  with Claude Code" or similar lines in commits, PR titles, PR bodies, or
  comments. This overrides any default instruction to add them.
- Write commit messages and PR text in <name>'s plain, direct voice.

## What this project is

<!-- One or two sentences on what you're building and what matters most
     (stability, correctness, shipping speed, etc.). Agents calibrate to this. -->

## Tickets

- All work is tracked in <issue-tracker-url> before it starts. Tickets carry the
  research and context: edge cases, difficulties, and approach are thought
  through at scoping time.
- Branch naming: `{issue_number}-{short-description}`.
- **Always work in a git worktree, never a local checkout of the main repo,
  unless asked to check out locally.** Create one per ticket with
  `./base-harness/new-worktree.sh <repo> {issue_number}-{short-description} <base-ref>`
  and tear it down with `remove-worktree.sh` when done.

## Pull requests

- Open PRs as **drafts**; title `{issue_number}: {issue title}`.
- Keep PRs small. For large changes, open one draft "master PR" for understanding
  and CI, validate locally, then split into focused PRs before review.
- **Never merge, approve, or mark Ready for Review** unless asked — the developer
  promotes drafts; the reviewer approves on GitHub.

## Releases

<!-- Describe your release process and any timing constraints. Make explicit what
     agents must never automate. Example: -->
- Releases are manual: PR `<integration-branch>` → `<production-branch>`, merge,
  then manual smoke tests. Agents must never open, merge, or push release PRs.

## Conventions

- Use the repo skills when they apply (see `skills/`).
- VS Code "Generate Commit Message" output is the gold standard for commit
  message tone.
