#!/bin/bash
# MEMORY.md Generator for mycoforge
#
# Reads structured sources instead of scraping prose markdown:
#   config/model-routing.yaml  — provider model names per tier
#   manifests/commands.yaml    — command registry
#   skills/*/SKILL.md          — skill trigger descriptions
#   /workspace/                — active projects
#   ENV vars                   — provider availability, runtime config
#
# Usage: ./scripts/generate-memory.sh
# Output: /mycoforge/MEMORY.md (always overwritten, idempotent)

set -euo pipefail

MYCOFORGE_DIR="${MYCOFORGE_DIR:-/mycoforge}"
ROUTING_CONFIG="$MYCOFORGE_DIR/config/model-routing.yaml"
COMMANDS_MANIFEST="$MYCOFORGE_DIR/manifests/commands.yaml"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# Extract a provider model name from model-routing.yaml
# Usage: get_model <tier> <provider>   e.g. get_model small anthropic
get_model() {
  local tier="$1" provider="$2"
  awk -v tier="$tier" -v provider="$provider" '
    /^  [a-z]/ { gsub(/:.*/, ""); current = substr($0, 3) }
    current == tier && /^      / {
      gsub(/^[[:space:]]+/, "")
      split($0, a, ": ")
      if (a[1] == provider) { print a[2]; exit }
    }
  ' "$ROUTING_CONFIG"
}

# ---------------------------------------------------------------------------
# Section 1 — Verfügbare AI Provider
# ---------------------------------------------------------------------------
build_providers() {
  local providers=""

  if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
    local small medium large
    small=$(get_model small anthropic) || small=""
    medium=$(get_model medium anthropic) || medium=""
    large=$(get_model large anthropic) || large=""
    providers="${providers}\n- Anthropic (${large}, ${medium}, ${small})"
  fi

  if [ -n "${OPENAI_API_KEY:-}" ]; then
    local small medium large
    small=$(get_model small openai) || small=""
    medium=$(get_model medium openai) || medium=""
    large=$(get_model large openai) || large=""
    providers="${providers}\n- OpenAI (${large}, ${medium}, ${small})"
  fi

  if [ -n "${GEMINI_API_KEY:-}" ]; then
    local small medium large
    small=$(get_model small google) || small=""
    medium=$(get_model medium google) || medium=""
    large=$(get_model large google) || large=""
    providers="${providers}\n- Google (${large}, ${medium}, ${small})"
  fi

  if [ -n "${XAI_API_KEY:-}" ]; then
    providers="${providers}\n- xAI (Grok)"
  fi

  if [ -z "$providers" ]; then
    providers="\n- Keine API Keys gesetzt ⚠ — Claude Code läuft, aber kein Modell verfügbar"
  fi

  echo -e "$providers"
}

# ---------------------------------------------------------------------------
# Section 2 — Slash Commands (from manifests/commands.yaml)
# ---------------------------------------------------------------------------
build_commands_table() {
  echo "| Command | Beschreibung |"
  echo "|---------|--------------|"

  if [ ! -f "$COMMANDS_MANIFEST" ]; then
    echo "| — | Manifest nicht gefunden: manifests/commands.yaml |"
    return
  fi

  # Parse YAML: extract name+description pairs
  # Format in YAML: "  - name: foo\n    description: \"bar\""
  local name="" desc=""
  while IFS= read -r line; do
    if echo "$line" | grep -q "^  - name:"; then
      name=$(echo "$line" | sed 's/.*name: //')
    elif echo "$line" | grep -q "^    description:"; then
      desc=$(echo "$line" | sed 's/.*description: //' | tr -d '"')
      if [ -n "$name" ] && [ -n "$desc" ]; then
        echo "| \`/$name\` | $desc |"
      fi
      name=""
      desc=""
    fi
  done < "$COMMANDS_MANIFEST"
}

# ---------------------------------------------------------------------------
# Section 3 — Skills (still read from SKILL.md — no manifest yet)
# ---------------------------------------------------------------------------
build_skills_table() {
  echo "| Skill | Wann laden |"
  echo "|-------|------------|"

  if [ ! -d "$MYCOFORGE_DIR/skills" ]; then
    return
  fi

  for d in "$MYCOFORGE_DIR/skills/*/"; do
    local skill_file="${d}SKILL.md"
    if [ -f "$skill_file" ]; then
      local name trigger
      name=$(grep '^# ' "$skill_file" | head -1 | sed 's/^# //')
      trigger=$(awk '/^## Wann laden\?/{found=1; next} found && /^##/{exit} found && NF{printf "%s ", $0}' "$skill_file" | sed 's/ $//')
      echo "| $name | $trigger |"
    fi
  done
}

# ---------------------------------------------------------------------------
# Section 4 — Aktive Projekte
# ---------------------------------------------------------------------------
build_projects() {
  # Read from structured state file if it exists (written by project management)
  local state_file="$MYCOFORGE_DIR/runtime/state/projects.yaml"
  if [ -f "$state_file" ]; then
    grep "^  - name:\|^    url:\|^    description:" "$state_file" | paste - - - \
      | awk '{
          name=$0; gsub(/.*name: /, "", name); gsub(/\t.*/, "", name)
          # simplified output
          print "- " name
        }'
    return
  fi

  # Fallback: scan /workspace/ filesystem
  local found=0
  if [ -d /workspace ]; then
    for p in /workspace/*/; do
      [ -d "$p" ] || continue
      local project_name desc=""
      project_name=$(basename "$p")
      [[ "$project_name" == "." ]] && continue
      [ -f "/workspace/${project_name}/CLAUDE.md" ] && \
        desc=$(grep -m1 '^[^#]' "/workspace/${project_name}/CLAUDE.md" 2>/dev/null | head -c 80)
      if [ -n "$desc" ]; then
        echo "- ${project_name}: ${desc}"
      else
        echo "- ${project_name}"
      fi
      found=1
    done
  fi

  [ "$found" -eq 0 ] && echo "<!-- Keine Projekte in /workspace/ -->"
}

# ---------------------------------------------------------------------------
# Build MEMORY.md
# ---------------------------------------------------------------------------
DEBUG_MODE="${DEBUG_MODE:-off}"
GH_ORG="${GH_ORG:-}"

cat > "$MYCOFORGE_DIR/MEMORY.md" << MEMORY
# mycoforge Memory

## Verfügbare AI Provider
$(build_providers)

## Modell-Routing Prinzip
- Kanonische Konfiguration: \`config/model-routing.yaml\`
- Planung / Architektur → großes Modell (large)
- Code schreiben → mittleres Modell (medium)
- Dateioperationen / einfache Edits → kleinstes Modell (small)
- Routing-Entscheidung selbst → kleinstes verfügbares Modell

## GitHub
- Account: ${GH_ORG}
- URL: https://github.com/${GH_ORG}
$([ -n "${GH_TOKEN:-}" ] && echo "- Token: vorhanden" || echo "- Token: nicht gesetzt")

## Aktive Projekte
$(build_projects)

## Slash Commands

$(build_commands_table)

## Verfügbare Skills

$(build_skills_table)

## Einstellungen

- \`DEBUG_MODE: $DEBUG_MODE\`  — \`on\` = Agent/Provider/Modell bei jedem Task anzeigen

## Konventionen
- Atomic Commits nach jeder abgeschlossenen Aufgabe
- Keine Secrets in Git
- Jedes Projekt bekommt ein eigenes Repo
- Änderungen an mycoforge selbst werden sofort committed und gepusht

## Infrastruktur
- Container: /mycoforge/ (Code) · /workspace/ (Projekte) · /root/.claude/ (Config)
- GitHub: https://github.com/${GH_ORG}/mycoforge

## Offene TODOs
→ siehe /mycoforge/TODO.md

$(if [ -z "${ANTHROPIC_API_KEY:-}" ] && [ -z "${OPENAI_API_KEY:-}" ] && [ -z "${GEMINI_API_KEY:-}" ] && [ -z "${XAI_API_KEY:-}" ]; then
  echo "## ⚠ Konfigurationsproblem"
  echo ""
  echo "Keine API Keys gefunden. Mögliche Ursachen:"
  echo "- .env nicht vorhanden oder leer → Vorlage: .env.example"
  echo "- Container ohne .env gestartet → Variablen in Platform-UI setzen"
  echo "- Umgebungsvariablen nicht exportiert"
fi)
MEMORY
