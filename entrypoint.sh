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

# GitHub Info ermitteln
GITHUB_INFO=""
[ -n "$GH_TOKEN" ] && GITHUB_INFO="\n- Token: vorhanden" || GITHUB_INFO="\n- Token: nicht gesetzt"

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
MEMORY

# Übergebenen Befehl ausführen
exec "$@"
