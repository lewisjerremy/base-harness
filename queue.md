# Queue

<!-- TEMPLATE: The attention surface. The first thing the maintainer reads. One
     line per item, most urgent first within each section. Every session that
     changes an item's state updates this file (and STATE.md) at the transition —
     not continuously. -->

**Edit convention (see DECISIONS.md):** re-read immediately before editing,
smallest change, commit at session wrap. If two sessions edited near the same
time, the second re-reads and merges.

Sections, in the order attention flows:

- **🔴 Decision needed** — blocked on the maintainer. The top of the file; if
  this is empty, nothing is on fire.
- **🟡 Needs review** — drafts waiting for the self-review gate (a *different*
  session reviews them). Not yet the maintainer's problem.
- **🟢 Ready** — self-reviewed drafts awaiting validation + promotion.
- **🔵 In review** — Ready for Review on GitHub / the review system. **Hold new
  promotions if 2+ sit here** (don't flood the reviewer).
- **⚫ Blocked** — waiting on something external (a clarification, an upstream
  merge, an event to pass).

Item format (checkbox so the maintainer can tick it off):

```
- [ ] #<issue> — <one-line status> — <session/owner> — <PR # if any> — <age or date>
```

---

## 🔴 Decision needed
_(empty — nothing blocking)_

## 🟡 Needs review
_(empty)_

## 🟢 Ready
_(empty)_

## 🔵 In review
_(empty)_

## ⚫ Blocked
_(empty)_
