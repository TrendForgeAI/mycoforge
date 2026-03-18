# Suite: Memory Generator
# Tests that generate-memory.sh produces correct, complete MEMORY.md output.
# Sourced by run-evals.sh — uses assert_eq / assert_contains helpers.

GENERATOR="$MYCOFORGE_DIR/scripts/generate-memory.sh"
MEMORY="$MYCOFORGE_DIR/MEMORY.md"

if [ ! -f "$GENERATOR" ]; then
  skip "generator tests" "scripts/generate-memory.sh not found"
  return
fi

# Run generator with known env
ANTHROPIC_API_KEY=test-key GH_ORG=TestOrg MYCOFORGE_DIR="$MYCOFORGE_DIR" \
  bash "$GENERATOR"

# --- Required sections present ---
assert_contains "section: Verfügbare AI Provider"  "## Verfügbare AI Provider"  "$(cat "$MEMORY")"
assert_contains "section: Modell-Routing Prinzip"  "## Modell-Routing Prinzip"  "$(cat "$MEMORY")"
assert_contains "section: GitHub"                  "## GitHub"                  "$(cat "$MEMORY")"
assert_contains "section: Slash Commands"          "## Slash Commands"          "$(cat "$MEMORY")"
assert_contains "section: Verfügbare Skills"       "## Verfügbare Skills"       "$(cat "$MEMORY")"
assert_contains "section: Einstellungen"           "## Einstellungen"           "$(cat "$MEMORY")"

# --- Provider resolves from config, not hardcoded ---
assert_contains "Anthropic with model names"  "claude-opus-4-6"     "$(cat "$MEMORY")"
assert_contains "Anthropic sonnet present"    "claude-sonnet-4-6"   "$(cat "$MEMORY")"
assert_contains "Anthropic haiku present"     "claude-haiku-4-5"    "$(cat "$MEMORY")"

# --- Commands table has all 13 entries ---
cmd_count=$(grep -c "^| \`/" "$MEMORY" || echo 0)
assert_eq "MEMORY.md contains 13 command rows" "13" "$cmd_count"

# --- GitHub section uses GH_ORG env var ---
assert_contains "GitHub org from env" "TestOrg" "$(cat "$MEMORY")"

# --- Idempotency: two runs produce identical output ---
FIRST_HASH=$(md5sum "$MEMORY" | cut -d' ' -f1)
ANTHROPIC_API_KEY=test-key GH_ORG=TestOrg MYCOFORGE_DIR="$MYCOFORGE_DIR" \
  bash "$GENERATOR"
SECOND_HASH=$(md5sum "$MEMORY" | cut -d' ' -f1)
assert_eq "generator is idempotent" "$FIRST_HASH" "$SECOND_HASH"

# --- Config reference present (not hardcoded routing) ---
assert_contains "references routing config" "config/model-routing.yaml" "$(cat "$MEMORY")"
