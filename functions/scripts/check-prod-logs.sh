#!/bin/bash
# check-prod-logs.sh
# Polls GCloud production logs for the last 30 minutes and sends macOS
# notifications for any WARNING/ERROR that isn't a known happy-path event.
#
# Usage: ./check-prod-logs.sh
# Scheduled via LaunchAgent — see install-log-monitor.sh

set -euo pipefail

PROJECT="zachran-obed"
STATE_FILE="$HOME/.zachranobed-log-monitor-last-run"

# Patterns to exclude (happy-path warnings — substring match, case-insensitive)
EXCLUDED_PATTERNS=(
  "safety net activated"
)

# ── helpers ──────────────────────────────────────────────────────────────────

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

notify() {
  local title="$1"
  local subtitle="$2"
  local message="$3"
  # Escape double quotes for osascript
  local safe_message="${message//\"/\\\"}"
  local safe_subtitle="${subtitle//\"/\\\"}"
  osascript -e "display notification \"${safe_message}\" with title \"${title}\" subtitle \"${safe_subtitle}\" sound name \"Funk\"" 2>/dev/null || true
}

is_excluded() {
  local msg="$1"
  for pattern in "${EXCLUDED_PATTERNS[@]}"; do
    if echo "$msg" | grep -qiF "$pattern"; then
      return 0
    fi
  done
  return 1
}

# ── prerequisites check ───────────────────────────────────────────────────────

if ! command -v gcloud &>/dev/null; then
  log "ERROR: gcloud not found on PATH. Aborting."
  exit 1
fi

if ! command -v jq &>/dev/null; then
  log "ERROR: jq not found on PATH. Install with: brew install jq"
  exit 1
fi

# ── determine query window ────────────────────────────────────────────────────

if [[ -f "$STATE_FILE" ]]; then
  SINCE=$(cat "$STATE_FILE" | tr -d '[:space:]')
  log "Resuming from last run: $SINCE"
else
  SINCE=$(date -u -v-30M '+%Y-%m-%dT%H:%M:%SZ')
  log "First run — querying last 30 minutes: $SINCE"
fi

NOW=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

# ── query logs ────────────────────────────────────────────────────────────────

FILTER="resource.type=\"cloud_run_revision\" AND severity>=WARNING AND timestamp>=\"${SINCE}\""
log "Querying: $FILTER"

RAW_LOGS=$(gcloud logging read "$FILTER" \
  --project="$PROJECT" \
  --format=json \
  --limit=200 2>&1) || {
  log "ERROR: gcloud logging read failed:\n$RAW_LOGS"
  exit 1
}

# ── parse & notify ────────────────────────────────────────────────────────────

ISSUE_COUNT=0
SKIPPED_COUNT=0

# Parse JSON array — each element is one log entry
while IFS= read -r entry; do
  [[ -z "$entry" ]] && continue

  SEVERITY=$(echo "$entry" | jq -r '.severity // "UNKNOWN"')
  FUNCTION=$(echo "$entry" | jq -r '.resource.labels.service_name // "unknown"')
  TIMESTAMP=$(echo "$entry" | jq -r '.timestamp // ""')

  # Extract message: prefer jsonPayload.message, fall back to textPayload, then full jsonPayload
  MESSAGE=$(echo "$entry" | jq -r '
    if (.jsonPayload.message | type) == "string" then .jsonPayload.message
    elif (.textPayload | type) == "string" then .textPayload
    else (.jsonPayload // {} | tostring)
    end
  ')

  # Apply exclusion list
  if is_excluded "$MESSAGE"; then
    log "SKIP [$SEVERITY] $FUNCTION: ${MESSAGE:0:120}"
    SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
    continue
  fi

  # Truncate for notification (notifications have limited space)
  SHORT_MSG="${MESSAGE:0:250}"

  log "ALERT [$SEVERITY] $FUNCTION ($TIMESTAMP): ${MESSAGE:0:200}"
  notify "🔥 ZachranObed [$SEVERITY]" "$FUNCTION" "$SHORT_MSG"

  ISSUE_COUNT=$((ISSUE_COUNT + 1))
done < <(echo "$RAW_LOGS" | jq -c '.[]' 2>/dev/null)

# ── update state ──────────────────────────────────────────────────────────────

echo "$NOW" > "$STATE_FILE"
log "Done. Alerts: $ISSUE_COUNT, Skipped: $SKIPPED_COUNT. Next run will query from $NOW."
