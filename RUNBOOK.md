# Harness Runbook — concurrent sessions coordinating through shared state

<!-- TEMPLATE: The operating manual for running multiple agent sessions in
     parallel. The goal: the maintainer's attention hops to decision points; the
     sessions do the heavy lifting in parallel and never collide. Read
     DECISIONS.md for the policy this defers to; this file is how to run it
     day-to-day. Replace the specifics (session count, model, repo name, paths)
     with your own. -->

## The model in one paragraph

<!-- TEMPLATE: N sessions. One is the conductor (runs standup, maintains the
     queue, does reviews); the rest are workers (each launched inside a ticket
     worktree, each runs the build skill). They coordinate through shared files
     in this repo — queue.md, STATE.md, and the dated standups/ notes — plus
     memory/. The queue is the boss: it tells you whose attention is needed and
     in what order. No session ever needs to ask another anything out-of-band;
     the state files carry it. -->

## The shared state (read this first)

| File | What it is | Who writes |
| ---- | ---------- | ---------- |
| `queue.md` | The attention surface — 🔴 decision / 🟡 needs review / 🟢 ready / 🔵 in review / ⚫ blocked. **Read this first, every time.** | Any session, at state transitions |
| `STATE.md` | In-flight tickets: which session claimed what, status, branch. The **collision-avoidance + resume** mechanism. | The session that claims/advances a ticket |
| `standups/YYYY-MM-DD.md` | Today's decision + targets. Yesterday's is this standup's input. | The conductor (`standup` skill, if you have one) |
| `memory/` | Durable facts, indexed in `MEMORY.md`. Unchanged. | Any session that learns something durable |

Edit convention (DECISIONS.md): re-read immediately before editing, smallest
change, commit at session wrap. State transitions are infrequent, so contention
is rare; if two sessions collide, the second re-reads and merges.

## Starting a day

1. Open the **conductor session** in this repo and run the standup/planning
   pass (or read `queue.md` directly).
2. Close out yesterday's targets, review the queue, pick ranked targets (one per
   worker). Write `standups/<today>.md`.
3. For each **build** target, create its worktree (in any terminal — not inside
   the agent session):
   ```bash
   ./base-harness/new-worktree.sh <repo> <issue>-<desc> <base-ref>
   ```
   then open a worker session *inside* that worktree (`cd … && <agent>`) and point
   it at the ticket. For a **review** target, run the review pass in a session
   that didn't build it.

## The sessions

### Conductor (in this repo)

- Runs standup/planning, keeps `queue.md` honest, sweeps `STATE.md` for
  staleness, does review passes (it's the natural "fresh instance" reviewer
  since it didn't build anything).
- This is where the maintainer's attention lives when deciding, not building.

### Workers (in worktrees)

- Each is launched **inside its worktree** (the session's cwd is fixed at launch
  — you can't `cd` into one mid-session). Point it at the ticket and it claims
  it in `STATE.md`, builds, opens the draft early, runs the test ladder,
  self-checks, and surfaces to `queue.md` → 🟡.
- It never merges, approves, marks Ready, or touches the production branch.

### The review gate (why this setup saves attention)

A worker **cannot** mark its own draft ready. It surfaces to 🟡. A *different*
session reviews it; only when that independent pass is clean does the item move
to 🟢 Ready. **The maintainer's attention is never the first review pass.** This
is the whole point of having more than one session.

## Routing cheat sheet

| You want to… | Do this |
| ------------ | ------- |
| Know what needs you | Read `queue.md` 🔴 then 🟢 |
| Pick the day's work | Standup/planning in the conductor session |
| Start a ticket | `new-worktree.sh …`, open a worker session in it, point it at the ticket |
| Review a finished draft | Run the review pass in a session that didn't build it; clean → 🟢 |
| Promote a draft to review | (You) mark Ready — only when 🔵 is at your limit |
| Remember a gotcha | Write `memory/<fact>.md`, add a line to `MEMORY.md`, commit this repo |
| End the day | Commit `queue.md` + `STATE.md` + today's standup note to this repo |

## When to escalate the model

<!-- TEMPLATE: Name your default workhorse model and when to escalate to a
     stronger one: final review of a critical diff, release go/no-go, scoping a
     genuinely hard ticket. -->

## Invariants (the things that must always be true)

- One writer per worktree. Two sessions never work the same ticket (`STATE.md`
  claims).
- Nothing reaches "ready" that a different session hasn't reviewed (the gate).
- The review queue holds at its limit, or new promotions pause.
- No AI attribution anywhere.
