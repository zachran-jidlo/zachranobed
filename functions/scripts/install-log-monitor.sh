#!/bin/bash
# install-log-monitor.sh
# Installs (or uninstalls) the macOS LaunchAgent that runs check-prod-logs.sh
# every 30 minutes in the background.
#
# Usage:
#   ./install-log-monitor.sh            # install & load
#   ./install-log-monitor.sh --uninstall

set -euo pipefail

LABEL="com.zachranobed.log-monitor"
PLIST="$HOME/Library/LaunchAgents/${LABEL}.plist"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONITOR_SCRIPT="$SCRIPT_DIR/check-prod-logs.sh"
LOG_FILE="$HOME/Library/Logs/zachranobed-log-monitor.log"

# ── uninstall ─────────────────────────────────────────────────────────────────

if [[ "${1:-}" == "--uninstall" ]]; then
  echo "Uninstalling log monitor..."
  launchctl unload "$PLIST" 2>/dev/null && echo "Agent unloaded." || echo "Agent was not loaded."
  rm -f "$PLIST"
  echo "Removed: $PLIST"
  echo "Done. State file (~/.zachranobed-log-monitor-last-run) kept for reference."
  exit 0
fi

# ── prerequisites check ───────────────────────────────────────────────────────

missing=()
command -v gcloud &>/dev/null || missing+=("gcloud")
command -v jq    &>/dev/null || missing+=("jq (brew install jq)")

if [[ ${#missing[@]} -gt 0 ]]; then
  echo "ERROR: Missing required tools: ${missing[*]}"
  echo "Install them and re-run."
  exit 1
fi

if [[ ! -f "$MONITOR_SCRIPT" ]]; then
  echo "ERROR: Monitor script not found at: $MONITOR_SCRIPT"
  exit 1
fi

chmod +x "$MONITOR_SCRIPT"

# ── install ───────────────────────────────────────────────────────────────────

mkdir -p "$(dirname "$LOG_FILE")"

# Resolve the PATH so gcloud/jq are found when launchd runs the script
RESOLVED_PATH="$(command -v gcloud | xargs dirname):$(command -v jq | xargs dirname):/usr/local/bin:/usr/bin:/bin"

cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${LABEL}</string>

    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>${MONITOR_SCRIPT}</string>
    </array>

    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>${RESOLVED_PATH}</string>
        <key>HOME</key>
        <string>${HOME}</string>
    </dict>

    <!-- Run every 30 minutes (1800 seconds) -->
    <key>StartInterval</key>
    <integer>1800</integer>

    <!-- Also run immediately when loaded -->
    <key>RunAtLoad</key>
    <true/>

    <key>StandardOutPath</key>
    <string>${LOG_FILE}</string>

    <key>StandardErrorPath</key>
    <string>${LOG_FILE}</string>
</dict>
</plist>
EOF

echo "Created: $PLIST"

# Unload first in case it was previously installed
launchctl unload "$PLIST" 2>/dev/null || true
launchctl load "$PLIST"

echo ""
echo "✅ Log monitor installed and running."
echo ""
echo "   Runs every: 30 minutes"
echo "   Script:     $MONITOR_SCRIPT"
echo "   Log file:   $LOG_FILE"
echo "   To stop:    ./install-log-monitor.sh --uninstall"
echo "   To check:   launchctl list | grep zachranobed"
echo "   Live log:   tail -f $LOG_FILE"
