# Suite: Routing Config
# Tests config/model-routing.yaml schema validity and get_model() extraction.
# Sourced by run-evals.sh — uses assert_eq / assert_contains helpers.

CONFIG="$MYCOFORGE_DIR/config/model-routing.yaml"

# Reuse get_model() from generate-memory.sh
get_model() {
  awk -v tier="$1" -v provider="$2" '
    /^  [a-z]/ { gsub(/:.*/, ""); current = substr($0, 3) }
    current == tier && /^      / {
      gsub(/^[[:space:]]+/, "")
      split($0, a, ": ")
      if (a[1] == provider) { print a[2]; exit }
    }
  ' "$CONFIG"
}

# --- Schema: all three tiers present ---
assert_contains "tier 'small' defined"  "  small:"  "$(cat "$CONFIG")"
assert_contains "tier 'medium' defined" "  medium:" "$(cat "$CONFIG")"
assert_contains "tier 'large' defined"  "  large:"  "$(cat "$CONFIG")"

# --- Schema: all providers present in each tier ---
for tier in small medium large; do
  for provider in anthropic openai google; do
    result=$(get_model "$tier" "$provider")
    assert_eq "get_model($tier, $provider) is non-empty" "0" "$([ -n "$result" ] && echo 0 || echo 1)"
  done
done

# --- Specific known values ---
assert_eq "small/anthropic = claude-haiku-4-5"      "claude-haiku-4-5"      "$(get_model small anthropic)"
assert_eq "small/openai = gpt-5.3-instant"          "gpt-5.3-instant"       "$(get_model small openai)"
assert_eq "small/google = gemini-3.1-flash-lite"    "gemini-3.1-flash-lite" "$(get_model small google)"
assert_eq "medium/anthropic = claude-sonnet-4-6"    "claude-sonnet-4-6"     "$(get_model medium anthropic)"
assert_eq "medium/openai = gpt-5.4"                 "gpt-5.4"               "$(get_model medium openai)"
assert_eq "medium/google = gemini-3-flash"          "gemini-3-flash"        "$(get_model medium google)"
assert_eq "large/anthropic = claude-opus-4-6"       "claude-opus-4-6"       "$(get_model large anthropic)"
assert_eq "large/openai = gpt-5.4-pro"              "gpt-5.4-pro"           "$(get_model large openai)"
assert_eq "large/google = gemini-3.1-pro"           "gemini-3.1-pro"        "$(get_model large google)"

# --- preferences block present ---
assert_contains "preferences block present"     "preferences:"    "$(cat "$CONFIG")"
assert_contains "code_quality preference set"   "code_quality:"   "$(cat "$CONFIG")"
assert_contains "agentic_workflows pref set"    "agentic_workflows:" "$(cat "$CONFIG")"
