# setup/codex/

Codex has **no global auto-sync hook** (no `SessionStart`-style primitive). So
for Codex the workflow is:

- Rules and skills are already inherited for free (parent `AGENTS.md` walk +
  `.agents/skills` link).
- The only thing `sync.sh` does for Codex is create the `.agents/skills` link —
  which you can get by running `sync.sh <repo>` once per repo/worktree, or by
  opening the same checkout in Claude Code / pi once (their auto-sync hooks will
  create the link for you, and Codex reads the same `.agents/skills`).

## Global config

Codex's behavior is configured globally in `~/.codex/config.toml` — approval
policies, model, sandbox, etc. There's nothing harness-specific to put there;
set it to your taste. A starter sketch:

```toml
# ~/.codex/config.toml  (sketch — adjust to your taste)
model = "gpt-5-codex"
approval_policy = "on-request"   # or "untrusted" / "never"
sandbox_mode = "workspace-write"

[history]
persistence = "save-all"
```

If you want one place to capture your Codex defaults alongside the harness,
drop a `config.toml` snippet in this folder and symlink it into `~/.codex/`
yourself; the harness intentionally does not touch your home dir.
