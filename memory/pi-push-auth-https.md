---
name: pi-push-auth-https
description: Push to lewisjerremy/* GitHub repos over HTTPS; the default SSH key authenticates as a different account (ranchbot-dev) with no access.
metadata:
  type: project
---

On this machine, `gh` is logged in as **lewisjerremy** (HTTPS + osxkeychain),
but the default SSH key authenticates as **`ranchbot-dev`** — a different GitHub
account with no access to `lewisjerremy/*` repos. An SSH push fails with
`Repository not found` even though the repo is public.

## Why

Two different credentials are configured: the SSH agent offers the
`ranchbot-dev` key, while `gh`/osxkeychain holds a `lewisjerremy` token.

## How to apply

- Set each repo's `origin` to the **HTTPS** URL
  (`https://github.com/lewisjerremy/<repo>.git`), not SSH. Pushes then auth as
  `lewisjerremy` with write access.
- Don't "fix" this by reconfiguring the SSH key unless you also intend to
  change which account owns pushes across all repos.
- `barl4lamb`'s origin was switched to HTTPS for exactly this reason.
