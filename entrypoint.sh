#!/bin/bash

# Claude config erstellen falls nicht vorhanden
if [ ! -f /root/.claude/.claude.json ]; then
    echo '{"firstStartTime": "'$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'"}' > /root/.claude/.claude.json
fi

# Verfügbare AI Provider ermitteln
PROVIDERS=""
[ -n "$ANTHROPIC_API_KEY" ] && PROVIDERS="$PROVIDERS\n- Anthropic (Claude Opus, Sonnet, Haiku)"
[ -n "$OPENAI_API_KEY" ]    && PROVIDERS="$PROVIDERS\n- OpenAI (GPT-4o, GPT-4o-mini, GPT-4.1)"
[ -n "$GEMINI_API_KEY" ]    && PROVIDERS="$PROVIDERS\n- Google (Gemini Pro, Gemini Flash)"
[ -n "$XAI_API_KEY" ]       && PROVIDERS="$PROVIDERS\n- xAI (Grok)"
[ -z "$PROVIDERS" ]         && PROVIDERS="\n- Keine API Keys gesetzt"

# MEMORY.md komplett neu schreiben
cat > /mycoforge/MEMORY.md << MEMORY
# mycoforge Memory

## Verfügbare AI Provider
$(echo -e "$PROVIDERS")

## Modell-Routing Prinzip
- Planung / Architektur / Zusammenhänge → großes Modell
- Code schreiben → mittleres Modell
- Dateioperationen / einfache Edits → kleines Modell
- Routing-Entscheidung selbst → kleinstes verfügbares Modell

## Aktive Projekte
<!-- Wird ergänzt wenn neue Projekte angelegt werden -->

## Konventionen
- Atomic Commits nach jeder abgeschlossenen Aufgabe
- Keine Secrets in Git
- Jedes Projekt bekommt ein eigenes Repo
- Änderungen an mycoforge selbst werden sofort committed

## VPS Infrastruktur
- Pfad: /docker/mycoforge/
- GitHub: https://github.com/TrendForgeAI/mycoforge
MEMORY

# Übergebenen Befehl ausführen
exec "$@"
