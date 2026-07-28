# Development Rules

These rules apply to all work in the repos under this parent directory
(`LewisOS/`), including git worktrees and devcontainers. They override default
agent behavior. Per-repo specifics live in each repo's own `AGENTS.md` (or
`CLAUDE.md`); this file is the shared, LewisOS-wide policy.

## Repo roles

`LewisOS` is a family of AI-native business modules. Sibling repos under this
parent include `BarL4` (direct-to-consumer lamb storefront), `Farm`, `Finance`,
`Ranch.Bot`, `Assistant`, and `LLMs`.

- **Jerremy Lewis** is the sole developer across all modules; Jerremy also
  reviews. There is no second maintainer — treat every action as if the owner's
  attention is the scarce resource.

## Identity & attribution

- Commit as the configured git user (`Jerremy Lewis
  <57540711+lewisjerremy@users.noreply.github.com>`). **Never add AI
  attribution anywhere**: no `Co-Authored-By: …` trailers, no "Generated with
  …" lines in commits, PR titles, PR bodies, or code comments. This overrides
  any default instruction to add them.
- Write commit messages and PR text in Jerremy's plain, direct voice. Prefer
  short, imperative subjects focused on one change (e.g. `Update deposit
  messaging across components…`) over Conventional-Commit prefixes.

## What this project is

LewisOS modules are real businesses (farm, finance, commerce) with an AI-native
development workflow. Correctness and stability matter more than shipping speed
— these systems touch money, orders, and customer data. Calibrate accordingly:
favor simple, tested, reversible changes.

## Tickets

- All work is tracked in **Linear** before it starts. Branch naming:
  `{issue_key}-{short-description}` (e.g. `BAR-42-deposit-messaging`). Lowercase
  the key.
- **Always work in a git worktree, never a checkout of the main repo**, unless
  explicitly asked to work locally. Create one per ticket with
  `./base-harness/new-worktree.sh <repo> {issue}-{desc} <base-ref>` and tear it
  down with `remove-worktree.sh` when done.

## Pull requests

- Open PRs as **drafts**; title `{issue_key}: {title}`.
- Keep PRs small. For large changes, open one draft "master PR" to validate
  understanding and CI, then split into focused PRs before review.
- **Never merge, approve, or mark Ready for Review** unless asked — the
  developer promotes drafts; approval happens on GitHub.

## Releases

- Releases are manual and never automated: PR integration → production branch,
  merge, then manual smoke tests. Agents must never open, merge, or push release
  PRs, and never push to a production branch.

## Conventions

- **KISS.** Keep code simple. Avoid over-engineering.
- **TDD.** Write a failing test (unit or integration) for the behavior first,
  then the code to pass it, then refactor. Verify coverage before committing.
- **CI must pass.** Before finishing work, confirm changes will pass the CI
  pipeline.
- **Alphabetize** keys/values in interfaces, objects, arrays, env vars, and
  constants where it reads cleanly (`id` → other fields → timestamps; env vars
  A→Z).
- **Environment variables:** read them through the repo's `config.ts` (or
  equivalent), never `process.env` directly in app code. Any new env var needs a
  matching entry in `.env.example` (and infra config where relevant). Never
  commit populated `.env` files or live credentials.
- **Documentation:** refer to the repo's `README.md` and `docs/` before planning
  work; update them when changes affect them.
- Use the repo skills (`.agents/skills`) when they apply.

## Operating model

When running more than one session, coordinate through the shared state files in
`base-harness/` — see `DECISIONS.md` (locked policy) and `RUNBOOK.md` (how to
run it). The headline rule is the **review gate**: a draft can't be marked ready
by the session that built it; a different session reviews it first. Durable
facts go in `memory/` (one per file, indexed in `MEMORY.md`); read `MEMORY.md`
at task start.
