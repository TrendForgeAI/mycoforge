# Suite: Manifest Consistency
# Tests that manifests/commands.yaml and manifests/agents.yaml are consistent
# with the filesystem. Gracefully degrades if claude/ is not present (not in git).
# Sourced by run-evals.sh — uses assert_eq / skip helpers.

COMMANDS_MANIFEST="$MYCOFORGE_DIR/manifests/commands.yaml"
AGENTS_MANIFEST="$MYCOFORGE_DIR/manifests/agents.yaml"
COMMANDS_DIR="$MYCOFORGE_DIR/claude/commands"
AGENTS_DIR="$MYCOFORGE_DIR/claude/agents"

# --- Manifest files exist ---
assert_eq "commands manifest exists" "0" "$([ -f "$COMMANDS_MANIFEST" ] && echo 0 || echo 1)"
assert_eq "agents manifest exists"   "0" "$([ -f "$AGENTS_MANIFEST"  ] && echo 0 || echo 1)"

# --- Count consistency ---
manifest_cmd_count=$(grep "^  - name:" "$COMMANDS_MANIFEST" 2>/dev/null | wc -l | tr -d ' ')
manifest_agent_count=$(grep "^  - name:" "$AGENTS_MANIFEST" 2>/dev/null | wc -l | tr -d ' ')
assert_eq "commands manifest has 13 entries" "13" "$manifest_cmd_count"
assert_eq "agents manifest has 12 entries"   "12" "$manifest_agent_count"

# --- All required fields present per command ---
# 'name' uses YAML list syntax "  - name:", others use "    field:"
cmd_name_count=$(grep "^  - name:" "$COMMANDS_MANIFEST" 2>/dev/null | wc -l | tr -d ' ')
assert_eq "all commands have field 'name' ($cmd_name_count/13)" "13" "$cmd_name_count"
for field in description pattern tier; do
  count=$(grep "^    ${field}:" "$COMMANDS_MANIFEST" 2>/dev/null | wc -l | tr -d ' ')
  assert_eq "all commands have field '$field' ($count/13)" "13" "$count"
done

# --- All required fields present per agent ---
agent_name_count=$(grep "^  - name:" "$AGENTS_MANIFEST" 2>/dev/null | wc -l | tr -d ' ')
assert_eq "all agents have field 'name' ($agent_name_count/12)" "12" "$agent_name_count"
for field in description tier pattern; do
  count=$(grep "^    ${field}:" "$AGENTS_MANIFEST" 2>/dev/null | wc -l | tr -d ' ')
  assert_eq "all agents have field '$field' ($count/12)" "12" "$count"
done

# --- Valid tier values only ---
invalid_tiers=$(grep "^    tier:" "$COMMANDS_MANIFEST" "$AGENTS_MANIFEST" 2>/dev/null \
  | grep -vE "tier: (small|medium|large)$" | wc -l | tr -d ' ')
assert_eq "no invalid tier values" "0" "$invalid_tiers"

# --- Manifest ↔ filesystem (graceful degradation if claude/ absent) ---
if [ ! -d "$COMMANDS_DIR" ]; then
  skip "manifest↔filesystem for commands" "claude/commands/ not on this path (not in git)"
else
  # Every manifest entry has a file
  while IFS= read -r name; do
    assert_eq "command '$name' has file" "0" \
      "$([ -f "$COMMANDS_DIR/${name}.md" ] && echo 0 || echo 1)"
  done < <(grep "^  - name:" "$COMMANDS_MANIFEST" | sed 's/.*name: //')

  # Every file has a manifest entry
  for f in "$COMMANDS_DIR"/*.md; do
    cmd=$(basename "$f" .md)
    assert_eq "file '$cmd.md' has manifest entry" "0" \
      "$(grep -q "^  - name: ${cmd}$" "$COMMANDS_MANIFEST" && echo 0 || echo 1)"
  done
fi

if [ ! -d "$AGENTS_DIR" ]; then
  skip "manifest↔filesystem for agents" "claude/agents/ not on this path (not in git)"
else
  while IFS= read -r name; do
    assert_eq "agent '$name' has file" "0" \
      "$([ -f "$AGENTS_DIR/${name}.md" ] && echo 0 || echo 1)"
  done < <(grep "^  - name:" "$AGENTS_MANIFEST" | sed 's/.*name: //')

  for f in "$AGENTS_DIR"/*.md; do
    agent=$(basename "$f" .md)
    assert_eq "file '$agent.md' has manifest entry" "0" \
      "$(grep -q "^  - name: ${agent}$" "$AGENTS_MANIFEST" && echo 0 || echo 1)"
  done
fi
