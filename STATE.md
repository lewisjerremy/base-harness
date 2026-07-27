# In-Flight Work

<!-- TEMPLATE: Durable record of work in progress, so any session (or a reopened
     laptop) can resume without asking what was happening. One block per in-flight
     ticket. Append when a session claims a ticket; update the status line at each
     transition; move to Recently completed when the ticket merges, closes, or is
     dropped. -->

This is also the **claim mechanism**: before a session starts a ticket it checks
here (and `queue.md`) that the ticket isn't already claimed. Two sessions never
work the same ticket.

Block format:

```markdown
## #<issue> — <short title>
- **Session:** <name or number> (worktree: <path>)
- **Started:** YYYY-MM-DD HH:MM
- **Status:** claiming | building | draft-open | needs-review | ready | in-review | blocked
- **Branch:** <branch>
- **PR:** #<n> (once open)
- **Notes:** <anything the next session needs to know — permutations touched,
  test status, what's left>
- **Last update:** YYYY-MM-DD HH:MM — <what changed>
```

---

## In-Flight
_(empty)_

## Recently completed
<!-- Move blocks here (trimmed to a one-line summary) when they merge, close, or
     are dropped. Prune periodically. -->
_(empty)_
