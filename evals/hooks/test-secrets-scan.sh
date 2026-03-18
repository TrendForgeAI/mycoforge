# Suite: Hook Logic — secrets-scan.sh
# Tests that secrets-scan detects known-bad patterns and passes clean files.
#
# R1 Mitigation: Uses a dedicated temp git repo per test run.
# Fixtures contain FAKE patterns — structurally identical to real secrets
# but prefixed with FAKE_ and clearly non-functional.
#
# Sourced by run-evals.sh — uses assert_eq helpers.

SCAN_SCRIPT="$MYCOFORGE_DIR/hooks/secrets-scan.sh"
FIXTURES_DIR="$MYCOFORGE_DIR/evals/hooks/fixtures"

if [ ! -f "$SCAN_SCRIPT" ]; then
  skip "secrets-scan tests" "hooks/secrets-scan.sh not found"
  return
fi

# Setup: create isolated temp git repo
TEST_REPO=$(mktemp -d)
git -C "$TEST_REPO" init -q
git -C "$TEST_REPO" config user.email "test@mycoforge"
git -C "$TEST_REPO" config user.name "mycoforge-test"
# Initial commit so HEAD exists
echo "# test" > "$TEST_REPO/README.md"
git -C "$TEST_REPO" add README.md
git -C "$TEST_REPO" commit -q -m "init"

cleanup() { rm -rf "$TEST_REPO"; }
trap cleanup EXIT

run_scan() {
  local repo="$1"
  bash "$SCAN_SCRIPT" "$repo" 2>&1
  return ${PIPESTATUS[0]}
}

# --- Helper: stage a file with given content in test repo ---
stage_content() {
  local filename="$1" content="$2"
  echo "$content" > "$TEST_REPO/$filename"
  git -C "$TEST_REPO" add "$filename"
}

# --- Test 1: Clean file passes ---
stage_content "clean.txt" "This is a normal file with no secrets."
exit_code=0
bash "$SCAN_SCRIPT" "$TEST_REPO" > /dev/null 2>&1 || exit_code=$?
assert_eq "clean file: exit code 0" "0" "$exit_code"
git -C "$TEST_REPO" restore --staged clean.txt 2>/dev/null || true
rm -f "$TEST_REPO/clean.txt"

# --- Test 2: .env file staged is detected ---
echo "SECRET=real_value" > "$TEST_REPO/.env"
git -C "$TEST_REPO" add .env
exit_code=0
bash "$SCAN_SCRIPT" "$TEST_REPO" > /dev/null 2>&1 || exit_code=$?
assert_eq ".env staged: exit code non-zero" "1" "$([ "$exit_code" -ne 0 ] && echo 1 || echo 0)"
git -C "$TEST_REPO" restore --staged .env 2>/dev/null || true
rm -f "$TEST_REPO/.env"

# --- Test 3: Anthropic API key pattern detected ---
# Key placed at line start so git diff shows: +sk-ant-api03-... (matches ^\+ pattern)
# Clearly non-real: wrong length, TEST marker, no valid chars for actual auth
stage_content "config.js" 'sk-ant-api03-TEST-NOT-REAL-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
exit_code=0
bash "$SCAN_SCRIPT" "$TEST_REPO" > /dev/null 2>&1 || exit_code=$?
assert_eq "Anthropic key pattern: exit code non-zero" "1" "$([ "$exit_code" -ne 0 ] && echo 1 || echo 0)"
git -C "$TEST_REPO" restore --staged config.js 2>/dev/null || true
rm -f "$TEST_REPO/config.js"

# --- Test 4: OpenAI API key pattern detected ---
stage_content "config.py" 'sk-proj-TEST-NOT-REAL-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
exit_code=0
bash "$SCAN_SCRIPT" "$TEST_REPO" > /dev/null 2>&1 || exit_code=$?
assert_eq "OpenAI key pattern: exit code non-zero" "1" "$([ "$exit_code" -ne 0 ] && echo 1 || echo 0)"
git -C "$TEST_REPO" restore --staged config.py 2>/dev/null || true
rm -f "$TEST_REPO/config.py"

# --- Test 5: .env.example is allowed (not a secret) ---
stage_content ".env.example" "ANTHROPIC_API_KEY=your-key-here"
exit_code=0
bash "$SCAN_SCRIPT" "$TEST_REPO" > /dev/null 2>&1 || exit_code=$?
assert_eq ".env.example: exit code 0 (allowed)" "0" "$exit_code"
git -C "$TEST_REPO" restore --staged .env.example 2>/dev/null || true
rm -f "$TEST_REPO/.env.example"

# --- Test 6: GitHub token pattern detected ---
stage_content "deploy.sh" 'ghp_TESTNOTREALxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
exit_code=0
bash "$SCAN_SCRIPT" "$TEST_REPO" > /dev/null 2>&1 || exit_code=$?
assert_eq "GitHub token pattern: exit code non-zero" "1" "$([ "$exit_code" -ne 0 ] && echo 1 || echo 0)"
git -C "$TEST_REPO" restore --staged deploy.sh 2>/dev/null || true
rm -f "$TEST_REPO/deploy.sh"
