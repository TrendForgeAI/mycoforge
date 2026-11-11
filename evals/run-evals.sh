#!/bin/bash
# mycoforge Eval Runner
#
# Executes all deterministic test suites and reports results.
# Exit code 0 = all passed, Exit code 1 = failures present.
#
# Usage: bash evals/run-evals.sh [--suite routing|manifests|hooks|generator]

set -uo pipefail

MYCOFORGE_DIR="${MYCOFORGE_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
SUITE="${1:-all}"

TOTAL_PASSED=0
TOTAL_FAILED=0
TOTAL_SKIPPED=0

# ---------------------------------------------------------------------------
# Test framework
# ---------------------------------------------------------------------------

assert_eq() {
  local desc="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    echo "  ✓ $desc"
    SUITE_PASSED=$((SUITE_PASSED + 1))
  else
    echo "  ✗ $desc"
    echo "      expected: $(echo "$expected" | head -3)"
    echo "      actual:   $(echo "$actual"   | head -3)"
    SUITE_FAILED=$((SUITE_FAILED + 1))
  fi
}

assert_contains() {
  local desc="$1" needle="$2" haystack="$3"
  if echo "$haystack" | grep -qF "$needle"; then
    echo "  ✓ $desc"
    SUITE_PASSED=$((SUITE_PASSED + 1))
  else
    echo "  ✗ $desc — missing: $needle"
    SUITE_FAILED=$((SUITE_FAILED + 1))
  fi
}

assert_exit_code() {
  local desc="$1" expected_code="$2"
  shift 2
  local actual_code=0
  "$@" > /dev/null 2>&1 || actual_code=$?
  assert_eq "$desc" "$expected_code" "$actual_code"
}

skip() {
  local desc="$1" reason="$2"
  echo "  — $desc (skipped: $reason)"
  SUITE_SKIPPED=$((SUITE_SKIPPED + 1))
}

run_suite() {
  local name="$1" script="$2"
  SUITE_PASSED=0
  SUITE_FAILED=0
  SUITE_SKIPPED=0

  echo ""
  echo "━━━ $name ━━━"

  if [ ! -f "$script" ]; then
    echo "  — Suite not found: $script"
    return
  fi

  # shellcheck source=/dev/null
  source "$script"

  TOTAL_PASSED=$((TOTAL_PASSED + SUITE_PASSED))
  TOTAL_FAILED=$((TOTAL_FAILED + SUITE_FAILED))
  TOTAL_SKIPPED=$((TOTAL_SKIPPED + SUITE_SKIPPED))

  echo "  → $SUITE_PASSED passed, $SUITE_FAILED failed, $SUITE_SKIPPED skipped"
}

# ---------------------------------------------------------------------------
# Run suites
# ---------------------------------------------------------------------------

echo "mycoforge Evals"
echo "==============="

case "${SUITE:-all}" in
  routing|all)   run_suite "Routing Config"      "$MYCOFORGE_DIR/evals/routing/test-config.sh" ;;
esac
case "${SUITE:-all}" in
  manifests|all) run_suite "Manifest Consistency" "$MYCOFORGE_DIR/evals/manifests/test-manifests.sh" ;;
esac
case "${SUITE:-all}" in
  hooks|all)     run_suite "Hook Logic"            "$MYCOFORGE_DIR/evals/hooks/test-secrets-scan.sh" ;;
esac
case "${SUITE:-all}" in
  generator|all) run_suite "Memory Generator"      "$MYCOFORGE_DIR/evals/generator/test-generator.sh" ;;
esac

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

echo ""
echo "==============="
echo "Total: $TOTAL_PASSED passed, $TOTAL_FAILED failed, $TOTAL_SKIPPED skipped"

if [ "$TOTAL_FAILED" -gt 0 ]; then
  echo "Result: ❌ FAILED"
  exit 1
else
  echo "Result: ✅ PASSED"
  exit 0
fi
