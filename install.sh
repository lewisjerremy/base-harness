#!/usr/bin/env bash
# Deprecated alias for sync.sh.
# Older notes and scripts (and the runbook) call `install.sh <repo>`. Kept as a
# thin passthrough so they keep working. Prefer sync.sh going forward.
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/sync.sh" "$@"
