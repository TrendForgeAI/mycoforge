#!/bin/bash
# Context Monitor Hook (PostToolUse)
# Zählt Tool-Calls pro Session und warnt bei hohem Kontext-Verbrauch.
# Ausgabe wird in Claude's Kontext injiziert.

COUNTER_FILE="/tmp/claude-tool-counter-$$"
SESSION_COUNTER_FILE="/tmp/claude-session-counter"
DEBOUNCE_FILE="/tmp/claude-context-warned"

# Session-ID aus Prozessgruppe ableiten (bleibt pro Session stabil)
SESSION_ID=$(ps -o pgid= $$ 2>/dev/null | tr -d ' ' || echo "$$")
COUNTER_FILE="/tmp/claude-tool-counter-${SESSION_ID}"
DEBOUNCE_FILE="/tmp/claude-context-warned-${SESSION_ID}"

# Zähler erhöhen
COUNT=0
if [ -f "$COUNTER_FILE" ]; then
    COUNT=$(cat "$COUNTER_FILE" 2>/dev/null || echo 0)
fi
COUNT=$((COUNT + 1))
echo "$COUNT" > "$COUNTER_FILE"

# Schwellenwerte
WARN_THRESHOLD=35
CRITICAL_THRESHOLD=55
DEBOUNCE_INTERVAL=8

# Letzte Warnung prüfen (Debounce)
LAST_WARNED=0
if [ -f "$DEBOUNCE_FILE" ]; then
    LAST_WARNED=$(cat "$DEBOUNCE_FILE" 2>/dev/null || echo 0)
fi
CALLS_SINCE_WARNING=$((COUNT - LAST_WARNED))

# Nur warnen wenn genug Calls seit letzter Warnung vergangen
if [ "$CALLS_SINCE_WARNING" -lt "$DEBOUNCE_INTERVAL" ]; then
    exit 0
fi

# Warnstufen
if [ "$COUNT" -ge "$CRITICAL_THRESHOLD" ]; then
    echo ""
    echo "⚠️  KONTEXT KRITISCH — ca. $COUNT Tool-Calls in dieser Session."
    echo "   Empfehlung: /clear ausführen und mit frischem Kontext weitermachen."
    echo "   Tipp: Wichtige Dateien und den Plan kurz neu laden nach /clear."
    echo ""
    echo "$COUNT" > "$DEBOUNCE_FILE"
elif [ "$COUNT" -ge "$WARN_THRESHOLD" ]; then
    echo ""
    echo "ℹ️  Kontext-Hinweis: ca. $COUNT Tool-Calls bisher."
    echo "   Bei großen Tasks empfiehlt sich bald ein /clear."
    echo ""
    echo "$COUNT" > "$DEBOUNCE_FILE"
fi

exit 0
