# Harness — Locked Decisions

<!-- TEMPLATE: Non-obvious directional *policy* for how the harness is allowed to
     behave. This is the authority the skills and the runbook defer to. Append a
     dated entry when a direction locks or reverses; don't re-litigate an entry
     here without the project owner. Durable *facts* (gotchas, env quirks) go in
     memory/; this file is for *policy*. -->

## Why this exists

LewisOS is a family of real businesses (farm, finance, direct-to-consumer
commerce) run by a **single maintainer** using many concurrent agent sessions.
The harness's job is not to maximize throughput — it's to protect what matters
(production, customer data, money, and the maintainer's scarce attention): queue
review-ready work in front of the maintainer and never spend their attention on
something a machine could handle. Jerremy is the sole reviewer, so the
self-review gate (a *different* session reviews each draft before it reaches
"ready") is what keeps the maintainer's pass from being the first.

## The autonomy ladder

Every workflow climbs rungs one at a time. A workflow only climbs after a run of
consecutive approvals with no edits. Calibrate the threshold to your risk
tolerance.

| Rung | Meaning |
| ---- | ------- |
| 1 | Draft only — a human executes the action |
| 2 | Draft + self-review gate — the owner approves each before it advances |
| 3 | Autonomous with owner spot-checks of samples |
| 4 | Autonomous with audit log (safe read-only lanes only) |

## Per-lane autonomy ceilings

<!-- TEMPLATE: Set a permanent cap for any lane that touches production or money.
     These caps are the core of the safety model — they do not climb "to save
     time." Fill in your own lanes. -->

| Lane | What it is | Ceiling | Notes |
| ---- | ---------- | ------- | ----- |
| build | Code on a ticket → draft PR | Rung 2 | |
| review | Review a diff against house criteria | Rung 2 (prep) | Review prepares findings; it never approves. |
| release | integration → production + smoke | Rung 1 | Draft the release PR + checklist; a human executes. |

## Hard rules (never)

- **Never** merge, approve, or mark Ready for Review unless explicitly asked.
- **Never** push anything to the production branch. Releases are manual.
- **Never** bypass the self-review gate (below).
- **Never** run a production write without an explicit per-operation human "yes."
- **Never** add AI attribution — no `Co-Authored-By`, no "Generated with…".
- **Never** have two write-capable sessions in the same git worktree. One writer
  per worktree.
- **Never** climb a capped lane past its ceiling to "save time."

## Self-review gate

A draft is not "ready" until a **fresh agent instance** — a different session
than the one that built it — has reviewed the diff and found no blocking
findings. The maintainer's attention should never be the first review pass. In a
multi-window setup this is natural: the window that builds surfaces the draft as
"needs review"; a different window reviews it; only clean drafts are promoted to
"ready."

## Release policy

<!-- TEMPLATE: Make explicit that releases are never automated, and any timing
     constraints (no Friday releases, freeze windows, etc.). -->

- Releases are manual and never automated. The harness may **draft** a release PR
  and produce the smoke-test checklist; it never executes.
- Timing constraints: no Friday/weekend releases; no release within 48 hours of
  a launch or live event (e.g. an open order batch for BarL4). Pause and confirm
  with the owner outside these windows.

## How state is shared across sessions

Shared live state lives in this repo (sibling to every project repo), so all
concurrent sessions see the same picture:

- **`queue.md`** — the attention surface: what is waiting on whom, in priority
  order. The first thing the maintainer reads.
- **`STATE.md`** — in-flight work: which tickets are claimed by which session,
  status, branch. How work survives a closed laptop and how sessions avoid
  collisions.
- **`standups/YYYY-MM-DD.md`** — dated standup notes; each is the next standup's
  input.
- **`memory/`** — durable facts (unchanged).

**Edit convention for `queue.md` / `STATE.md`:** re-read the file immediately
before editing, make the smallest change, and commit infrequently (at session
wrap). If two sessions collide, the second writer re-reads and merges. State
transitions are infrequent, so contention is rare.

## Model policy

<!-- Calibrate to the models you actually run in pi. Defaults below are a
     starting point — replace the names with your preferred workhorse + escalation
     model once chosen. -->

- **Default workhorse:** the model configured as pi's default. Fine for building,
  tests, and routine review prep.
- **Escalate** to a stronger model for: the final review of a diff touching
  money/auth/customer data, release go/no-go, and scoping a genuinely ambiguous
  ticket. The conductor session that runs the review gate is the natural place to
  spend the stronger model.

## How to change a decision

Append a dated entry here when a direction locks or reverses. Don't silently
contradict an entry in a skill — either change the entry here in the same change,
or flag the conflict to the owner. Skills point here; this file is the authority.
