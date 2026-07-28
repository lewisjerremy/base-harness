---
name: barl4-stack-and-secrets
description: BarL4 module stack (Express+tRPC+Prisma API, Vite+React web), ports, and the third-party services whose credentials must never be committed.
metadata:
  type: project
---

`BarL4` is the direct-to-consumer lamb storefront. Two packages:

- **`api/`** — Express + tRPC + Prisma, dev server on port `7001`. Tests split
  into `src/__tests__/unit/` and `src/__tests__/integration/` (Prisma-backed).
- **`web/`** — Vite + React 19 + TypeScript + Tailwind v4, Jest for UI tests.

Node `v24.11.1` (`.nvmrc`). API style: single quotes; web style: double quotes.

## Why

The API integrates live money/messaging/email services.

## How to apply

- `.env` (both `api/` and `web/`) is gitignored and **not** tracked — only
  `.env.example` is. The API config touches **Stripe, Twilio, Mailgun, Prisma,
  and `WEB_URL`**. Never commit populated `.env` files or live credentials.
- Any new env var must be added to the matching `.env.example` and documented.
- Read env vars through `config.ts`, never `process.env` directly in app code.
