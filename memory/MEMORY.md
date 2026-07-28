# Memory Index

One line per memory. Agents: skim this at task start, read the linked files that
matter, and keep it current (add, refresh, prune).

Each memory is its own file in this directory. Format: optional frontmatter
(`name`, `description`, `metadata.type`: `project` | `reference` | `feedback` |
`user`) followed by the fact, with **Why** and **How to apply** sections where
useful. One durable fact per file.

- [external-drive-exfat-quirks](external-drive-exfat-quirks.md) — repos live on an exFAT external drive; creates `._*` AppleDouble files and git mode churn. Use `core.fileMode false` + ignore `._*`.
- [pi-push-auth-https](pi-push-auth-https.md) — push to lewisjerremy/* over HTTPS (gh/osxkeychain); the SSH key is a different account (`ranchbot-dev`) with no access.
- [barl4-stack-and-secrets](barl4-stack-and-secrets.md) — BarL4 = Express+tRPC+Prisma API (port 7001) + Vite+React web; .env is gitignored and holds Stripe/Twilio/Mailgun/Prisma creds.
- [base-harness-installed-at-lewisos](base-harness-installed-at-lewisos.md) — base-harness cloned at LewisOS/base-harness; sync.sh fans shared rules/skills/memory into each repo via symlinks.
