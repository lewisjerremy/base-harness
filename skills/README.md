# skills

Drop your agent skills here — one folder per skill, each containing a `SKILL.md`
(and any supporting `references/` or tool config). Example:

```
skills/
└── my-skill/
    ├── SKILL.md
    └── references/
```

`install.sh` links this whole `skills/` directory into each checkout/worktree as
`.claude/skills` and `.agents/skills` (relative symlinks, so they resolve on the
host and inside devcontainers). Both Claude Code and Codex discover skills from
those locations.

This folder is empty by design — the harness ships with no skills. Add your own.
