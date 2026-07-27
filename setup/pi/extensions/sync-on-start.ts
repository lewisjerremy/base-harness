// sync-on-start.ts — global pi extension (user-scope auto-sync hook).
//
// Drop into ~/.pi/agent/extensions/ (pi auto-discovers *.ts there). On
// session_start, if the cwd is under your harness parent dir, run
// base-harness/sync.sh to fan the canonical context/skills/settings out into the
// checkout. This is the pi equivalent of the Claude Code SessionStart hook in
// ../claude/sessionstart-hook.json.
//
// REPLACE PARENT below with the absolute path to the dir that holds both this
// harness and your project repos.
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execFile } from "node:child_process";

const PARENT = "/Absolute/Path/To/Your/Parent/Dir"; // <-- REPLACE
const SYNC = `${PARENT}/base-harness/sync.sh`;

export default function (pi: ExtensionAPI) {
  pi.on("session_start", async (_event, ctx) => {
    // Only inside the harness parent dir.
    if (!ctx.cwd.startsWith(PARENT + "/")) return;
    // sync.sh is idempotent and cheap; fire and forget. Swallow errors so a
    // missing python3 or a non-checkout cwd never breaks startup.
    execFile(SYNC, [ctx.cwd], { timeout: 10_000 }, () => {
      /* swallow */
    });
  });
}
