#!/usr/bin/env bash
#
# Test script for the DODO Order Status webhook endpoint.
#
# Usage:
#   ./scripts/test-dodo-webhook.sh                          # All tests against local emulator
#   ./scripts/test-dodo-webhook.sh --env dev                # All tests against DEV
#   ./scripts/test-dodo-webhook.sh --env prod               # All tests against PROD
#   ./scripts/test-dodo-webhook.sh --url <custom-url>       # All tests against custom base URL
#   ./scripts/test-dodo-webhook.sh --test 1                 # Run only test #1
#   ./scripts/test-dodo-webhook.sh --test 1,3,5             # Run specific tests
#   ./scripts/test-dodo-webhook.sh --token <base64-token>   # Override auth token
#
# Environment variables:
#   DODO_TEST_TOKEN  - Base64-encoded "user:password" for auth (default: testuser:testpass)

set -euo pipefail

# --- Defaults ---
ENV="local"
BASE_URL=""
TOKEN="${DODO_TEST_TOKEN:-$(echo -n 'testuser:testpass' | base64)}"
TESTS_TO_RUN="all"
IDENTIFIER="TEST-IDENTIFIER-123"
PASSED=0
FAILED=0
SKIPPED=0

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# --- Parse arguments ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --env)
      ENV="$2"
      shift 2
      ;;
    --url)
      BASE_URL="$2"
      shift 2
      ;;
    --token)
      TOKEN="$2"
      shift 2
      ;;
    --test)
      TESTS_TO_RUN="$2"
      shift 2
      ;;
    --identifier)
      IDENTIFIER="$2"
      shift 2
      ;;
    -h|--help)
      head -15 "$0" | tail -13
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# --- Resolve base URL ---
if [[ -n "$BASE_URL" ]]; then
  # Strip trailing slash
  BASE_URL="${BASE_URL%/}"
elif [[ "$ENV" == "local" ]]; then
  BASE_URL="http://localhost:5001/zachran-obed-dev/europe-west1/orders"
elif [[ "$ENV" == "dev" ]]; then
  BASE_URL="https://europe-west1-zachran-obed-dev.cloudfunctions.net/orders"
elif [[ "$ENV" == "prod" ]]; then
  BASE_URL="https://europe-west1-zachran-obed.cloudfunctions.net/orders"
else
  echo "Unknown env: $ENV (use local, dev, or prod)"
  exit 1
fi

# --- Helper: check if test should run ---
should_run() {
  local test_num="$1"
  [[ "$TESTS_TO_RUN" == "all" ]] && return 0
  echo ",$TESTS_TO_RUN," | grep -q ",$test_num," && return 0
  return 1
}

# --- Helper: run a single test ---
run_test() {
  local num="$1"
  local name="$2"
  local expected_status="$3"
  shift 3
  # Remaining args are curl options

  if ! should_run "$num"; then
    ((SKIPPED++))
    return
  fi

  echo -e "${BOLD}Test $num: $name${NC}"
  echo -e "  Expected: HTTP $expected_status"

  local response
  local http_code
  response=$(curl -s -w "\n%{http_code}" "$@" 2>&1)
  http_code=$(echo "$response" | tail -1)
  local body
  body=$(echo "$response" | sed '$d')

  echo -e "  Response: HTTP $http_code"
  echo -e "  Body:     $body"

  if [[ "$http_code" == "$expected_status" ]]; then
    echo -e "  ${GREEN}PASS${NC}"
    ((PASSED++))
  else
    echo -e "  ${RED}FAIL${NC} (expected $expected_status, got $http_code)"
    ((FAILED++))
  fi
  echo ""
}

# --- Print header ---
echo ""
echo -e "${CYAN}${BOLD}DODO Order Status Webhook Tests${NC}"
echo -e "  Target:     ${BOLD}$BASE_URL${NC}"
echo -e "  Env:        $ENV"
echo -e "  Identifier: $IDENTIFIER"
echo ""

# --- Test 1: Valid PUT ---
run_test 1 "Valid PUT with auth → 200" "200" \
  -X PUT \
  "$BASE_URL/$IDENTIFIER/status" \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $TOKEN" \
  -d '{"StatusChangeTime":"2023-05-31T12:00:00Z","OrderStatus":"OnWayToPickup","Pickup":{},"Drop":{}}'

# --- Test 2: Wrong HTTP method ---
run_test 2 "GET instead of PUT → 405" "405" \
  -X GET \
  "$BASE_URL/$IDENTIFIER/status" \
  -H "Authorization: Basic $TOKEN"

# --- Test 3: Bad path ---
run_test 3 "Missing /status suffix → 404" "404" \
  -X PUT \
  "$BASE_URL/$IDENTIFIER" \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $TOKEN" \
  -d '{"OrderStatus":"OnWayToPickup"}'

# --- Test 4: No auth ---
run_test 4 "No auth header → 401" "401" \
  -X PUT \
  "$BASE_URL/$IDENTIFIER/status" \
  -H "Content-Type: application/json" \
  -d '{"OrderStatus":"OnWayToPickup"}'

# --- Test 5: Wrong token ---
run_test 5 "Wrong token → 401" "401" \
  -X PUT \
  "$BASE_URL/$IDENTIFIER/status" \
  -H "Authorization: Basic WRONGTOKEN" \
  -H "Content-Type: application/json" \
  -d '{"OrderStatus":"OnWayToPickup"}'

# --- Test 6: Missing OrderStatus ---
run_test 6 "Missing OrderStatus in body → 400" "400" \
  -X PUT \
  "$BASE_URL/$IDENTIFIER/status" \
  -H "Authorization: Basic $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"StatusChangeTime":"2023-05-31T12:00:00Z"}'

# --- Test 7: Unknown status ---
run_test 7 "Unknown status (accepted with warning) → 200" "200" \
  -X PUT \
  "$BASE_URL/$IDENTIFIER/status" \
  -H "Authorization: Basic $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"OrderStatus":"SomeUnknownStatus"}'

# --- Test 8: All valid statuses ---
if should_run 8; then
  echo -e "${BOLD}Test 8: All valid statuses → 200${NC}"
  all_ok=true
  for s in OnWayToPickup ArrivedToPickup OnWayToCustomer ArrivedToCustomer Finished Refused; do
    code=$(curl -s -o /dev/null -w "%{http_code}" -X PUT \
      "$BASE_URL/$IDENTIFIER/status" \
      -H "Authorization: Basic $TOKEN" \
      -H "Content-Type: application/json" \
      -d "{\"OrderStatus\":\"$s\"}")
    if [[ "$code" == "200" ]]; then
      echo -e "  $s → ${GREEN}$code${NC}"
    else
      echo -e "  $s → ${RED}$code${NC}"
      all_ok=false
    fi
  done
  if $all_ok; then
    echo -e "  ${GREEN}PASS${NC}"
    ((PASSED++))
  else
    echo -e "  ${RED}FAIL${NC}"
    ((FAILED++))
  fi
  echo ""
else
  ((SKIPPED++))
fi

# --- Summary ---
TOTAL=$((PASSED + FAILED))
echo -e "${BOLD}Results: $PASSED/$TOTAL passed${NC}"
[[ $SKIPPED -gt 0 ]] && echo -e "  ${YELLOW}$SKIPPED skipped${NC}"
[[ $FAILED -gt 0 ]] && echo -e "  ${RED}$FAILED failed${NC}" && exit 1
echo -e "  ${GREEN}All tests passed${NC}"
