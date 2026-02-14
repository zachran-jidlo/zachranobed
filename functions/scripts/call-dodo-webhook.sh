#!/usr/bin/env bash
#
# Call the DODO Order Status webhook with a specific status.
#
# Usage:
#   ./scripts/call-dodo-webhook.sh <identifier> <status> [options]
#
# Arguments:
#   identifier  - Delivery identifier (e.g., "ZO-2025-001")
#   status      - DODO status (OnWayToPickup, ArrivedToPickup, OnWayToCustomer, ArrivedToCustomer, Finished, Refused)
#
# Options:
#   --env local|dev|prod   Environment (default: local)
#   --token <base64>       Override auth token
#
# Examples:
#   ./scripts/call-dodo-webhook.sh ZO-123 OnWayToPickup
#   ./scripts/call-dodo-webhook.sh ZO-123 OnWayToCustomer --env dev
#   ./scripts/call-dodo-webhook.sh ZO-123 ArrivedToCustomer --env prod --token abc123

set -euo pipefail

# --- Defaults ---
ENV="local"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SECRET_FILE="$SCRIPT_DIR/../.secret.local"
DEFAULT_TOKEN=""
if [[ -f "$SECRET_FILE" ]]; then
  DEFAULT_TOKEN=$(grep '^DODO_WEBHOOK_TOKEN=' "$SECRET_FILE" | sed 's/^DODO_WEBHOOK_TOKEN=//')
fi
TOKEN="${DODO_TEST_TOKEN:-$DEFAULT_TOKEN}"
echo "$TOKEN"

# --- Parse positional args ---
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <identifier> <status> [--env local|dev|prod] [--token <token>]"
  exit 1
fi

IDENTIFIER="$1"
STATUS="$2"
shift 2

# --- Parse options ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --env)   ENV="$2"; shift 2 ;;
    --token) TOKEN="$2"; shift 2 ;;
    -h|--help) head -17 "$0" | tail -15; exit 0 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

# --- Resolve base URL ---
case "$ENV" in
  local) BASE_URL="http://localhost:5001/zachran-obed-dev/europe-west1/orders" ;;
  dev)   BASE_URL="https://europe-west1-zachran-obed-dev.cloudfunctions.net/orders" ;;
  prod)  BASE_URL="https://europe-west1-zachran-obed.cloudfunctions.net/orders" ;;
  *)     echo "Unknown env: $ENV (use local, dev, or prod)"; exit 1 ;;
esac

URL="$BASE_URL/$IDENTIFIER/status"

echo "PUT $URL"
echo "Status: $STATUS"
echo ""

curl -s -X PUT "$URL" \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $TOKEN" \
  -d "{\"OrderStatus\":\"$STATUS\"}" | python3 -m json.tool 2>/dev/null || true

echo ""
