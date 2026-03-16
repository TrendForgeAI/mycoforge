#!/bin/bash

# Claude config erstellen falls nicht vorhanden
if [ ! -f /root/.claude/.claude.json ]; then
    echo '{"firstStartTime": "'$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'"}' > /root/.claude/.claude.json
fi

# Verfügbare AI Provider ermitteln
PROVIDERS=""
[ -n "$ANTHROPIC_API_KEY" ] && PROVIDERS="$PROVIDERS\n- Anthropic (Claude Opus, Sonnet, Haiku)"
[ -n "$OPENAI_API_KEY" ]    && PROVIDERS="$PROVIDERS\n- OpenAI (GPT-5.4-pro, GPT-5.4, GPT-5.3-instant)"
[ -n "$GEMINI_API_KEY" ]    && PROVIDERS="$PROVIDERS\n- Google (Gemini 3.1 Pro, Gemini 3 Flash, Gemini 3.1 Flash-Lite)"
[ -n "$XAI_API_KEY" ]       && PROVIDERS="$PROVIDERS\n- xAI (Grok)"
[ -z "$PROVIDERS" ]         && PROVIDERS="\n- Keine API Keys gesetzt"

# Git mit GitHub Token konfigurieren
if [ -n "$GH_TOKEN" ]; then
    git config --global credential.helper store
    echo "https://TrendForgeAI:${GH_TOKEN}@github.com" > /root/.git-credentials
    git config --global user.name "TrendForgeAI"
    git config --global user.email "github@trendforge.ai"
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
- Account: TrendForgeAI (User, keine Organisation)
- URL: https://github.com/TrendForgeAI
$(echo -e "$GITHUB_INFO")

## Aktive Projekte
<!-- Wird ergänzt wenn neue Projekte angelegt werden -->

## Slash Commands

$(echo -e "$SLASH_COMMANDS_TABLE")

## Einstellungen

- \`DEBUG_MODE: $DEBUG_MODE\`  — \`on\` = Agent/Provider/Modell bei jedem Task anzeigen

## Konventionen
- Atomic Commits nach jeder abgeschlossenen Aufgabe
- Keine Secrets in Git
- Jedes Projekt bekommt ein eigenes Repo
- Änderungen an mycoforge selbst werden sofort committed und gepusht

## VPS Infrastruktur
- Pfad: /docker/mycoforge/
- Container Pfad: /mycoforge/
- Arbeitsbereich: /workspace/
- GitHub: https://github.com/TrendForgeAI/mycoforge

## Offene TODOs
$(grep '^\s*- \[ \]' /mycoforge/TODO.md 2>/dev/null | head -10 || echo "- Keine offenen TODOs")
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
