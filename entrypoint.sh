#!/bin/bash

# Claude config erstellen falls nicht vorhanden
if [ ! -f /mycoforge/claude/.claude.json ]; then
    echo '{"firstStartTime": "'$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'"}' > /mycoforge/claude/.claude.json
fi

# /root/.claude.json → persistentes Volume verlinken
ln -sf /mycoforge/claude/.claude.json /root/.claude.json

# Verfügbare AI Provider ermitteln
PROVIDERS=""
[ -n "$ANTHROPIC_API_KEY" ] && PROVIDERS="$PROVIDERS\n- Anthropic (Claude Opus, Sonnet, Haiku)"
[ -n "$OPENAI_API_KEY" ]    && PROVIDERS="$PROVIDERS\n- OpenAI (GPT-5.4-pro, GPT-5.4, GPT-5.3-instant)"
[ -n "$GEMINI_API_KEY" ]    && PROVIDERS="$PROVIDERS\n- Google (Gemini 3.1 Pro, Gemini 3 Flash, Gemini 3.1 Flash-Lite)"
[ -n "$XAI_API_KEY" ]       && PROVIDERS="$PROVIDERS\n- xAI (Grok)"
[ -z "$PROVIDERS" ]         && PROVIDERS="\n- Keine API Keys gesetzt ⚠ — Claude Code läuft, aber kein Modell verfügbar"

# Git mit GitHub Token konfigurieren
if [ -n "$GH_TOKEN" ]; then
    git config --global credential.helper store
    echo "https://${GH_ORG}:${GH_TOKEN}@github.com" > /root/.git-credentials
    chmod 600 /root/.git-credentials
    git config --global user.name "${GIT_USER_NAME:-}"
    git config --global user.email "${GIT_USER_EMAIL:-}"
fi

# GitHub Info ermitteln
GITHUB_INFO=""
[ -n "$GH_TOKEN" ] && GITHUB_INFO="- Token: vorhanden" || GITHUB_INFO="- Token: nicht gesetzt"

# DEBUG_MODE aus ENV lesen (Default: off)
DEBUG_MODE="${DEBUG_MODE:-off}"

# Slash Commands aus claude/commands/ generieren
SLASH_COMMANDS_TABLE="| Command | Beschreibung |\n|---------|--------------|"
if [ -d /mycoforge/claude/commands ]; then
    for f in /mycoforge/claude/commands/*.md; do
        cmd=$(basename "$f" .md)
        desc=$(grep '^description:' "$f" | head -1 | sed 's/^description: *//')
        SLASH_COMMANDS_TABLE="$SLASH_COMMANDS_TABLE\n| \`/$cmd\` | $desc |"
    done
fi

# Skills aus skills/*/SKILL.md generieren
SKILLS_TABLE="| Skill | Wann laden |\n|-------|------------|"
if [ -d /mycoforge/skills ]; then
    for d in /mycoforge/skills/*/; do
        skill_file="${d}SKILL.md"
        if [ -f "$skill_file" ]; then
            name=$(grep '^# ' "$skill_file" | head -1 | sed 's/^# //')
            # Alle Zeilen der "Wann laden?"-Sektion zusammenfassen (bis zum nächsten ##)
            trigger=$(awk '/^## Wann laden\?/{found=1; next} found && /^##/{exit} found && NF{printf "%s ", $0}' "$skill_file" | sed 's/ $//')
            SKILLS_TABLE="$SKILLS_TABLE\n| $name | $trigger |"
        fi
    done
fi

# MEMORY.md komplett neu schreiben
cat > /mycoforge/MEMORY.md << MEMORY
# mycoforge Memory

## Verfügbare AI Provider
$(echo -e "$PROVIDERS")

## Modell-Routing Prinzip
- Planung / Architektur / Zusammenhänge → großes Modell
- Code schreiben → mittleres Modell
- Dateioperationen / einfache Edits → kleinstes Modell
- Routing-Entscheidung selbst → kleinstes verfügbares Modell

## GitHub
- Account: ${GH_ORG}
- URL: https://github.com/${GH_ORG}
$(echo -e "$GITHUB_INFO")

## Aktive Projekte
$(ls /workspace/ 2>/dev/null | grep -v '^\.' | while read p; do
    desc=""
    [ -f "/workspace/$p/CLAUDE.md" ] && desc=$(grep -m1 '^[^#]' "/workspace/$p/CLAUDE.md" 2>/dev/null | head -c 60)
    [ -n "$desc" ] && echo "- $p: $desc" || echo "- $p"
done)
$([ -z "$(ls /workspace/ 2>/dev/null | grep -v '^\.')" ] && echo "<!-- Keine Projekte in /workspace/ -->")

## Slash Commands

$(echo -e "$SLASH_COMMANDS_TABLE")

## Verfügbare Skills

$(echo -e "$SKILLS_TABLE")

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

$(if [ -z "$ANTHROPIC_API_KEY" ] && [ -z "$OPENAI_API_KEY" ] && [ -z "$GEMINI_API_KEY" ] && [ -z "$XAI_API_KEY" ]; then
    echo "## ⚠ Konfigurationsproblem"
    echo ""
    echo "Keine API Keys gefunden. Mögliche Ursachen:"
    echo "- .env nicht vorhanden oder leer → Vorlage: .env.example"
    echo "- Container ohne .env gestartet → Variablen in Platform-UI setzen"
    echo "- Umgebungsvariablen nicht exportiert"
fi)
MEMORY

# Git Hooks installieren (mycoforge Repo)
if [ -d /mycoforge/.git/hooks ]; then
    cp /mycoforge/hooks/git-pre-commit.sh /mycoforge/.git/hooks/pre-commit
    cp /mycoforge/hooks/git-post-commit.sh /mycoforge/.git/hooks/post-commit
    chmod +x /mycoforge/.git/hooks/pre-commit /mycoforge/.git/hooks/post-commit
fi

# Hook-Skripte ausführbar machen
chmod +x /mycoforge/hooks/*.sh 2>/dev/null

# Übergebenen Befehl ausführen
exec "$@"
