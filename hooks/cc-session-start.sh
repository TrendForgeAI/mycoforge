#!/bin/bash
# Claude Code SessionStart Hook
# Wird beim Start einer Claude Code Session ausgeführt.
# Zeigt Kontext: Provider, offene TODOs, aktive Projekte.

MEMORY_FILE="/mycoforge/MEMORY.md"
TODO_FILE="/mycoforge/TODO.md"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  mycoforge Session gestartet"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Hilfsfunktion: Abschnitt aus Markdown-Datei extrahieren (## Header bis nächstem ##)
extract_section() {
    local file="$1"
    local section="$2"
    awk "/^## ${section}/{found=1; next} found && /^## /{exit} found{print}" "$file" 2>/dev/null
}

# Verfügbare Provider
if [ -f "$MEMORY_FILE" ]; then
    PROVIDERS=$(extract_section "$MEMORY_FILE" "Verfügbare AI Provider" | grep -E '^\s*-' | head -5)
    if [ -n "$PROVIDERS" ]; then
        echo ""
        echo "Verfügbare Provider:"
        echo "$PROVIDERS" | sed 's/^/  /'
    fi
fi

# Offene TODOs
if [ -f "$TODO_FILE" ]; then
    OPEN_TODOS=$(grep -c '^\s*- \[ \]' "$TODO_FILE" 2>/dev/null || echo 0)
    if [ "$OPEN_TODOS" -gt 0 ]; then
        echo ""
        echo "Offene TODOs ($OPEN_TODOS):"
        grep '^\s*- \[ \]' "$TODO_FILE" | head -5 | sed 's/^/  /'
        if [ "$OPEN_TODOS" -gt 5 ]; then
            echo "  ... und $((OPEN_TODOS - 5)) weitere (siehe TODO.md)"
        fi
    fi
fi

# Aktive Projekte
if [ -f "$MEMORY_FILE" ]; then
    PROJECTS=$(extract_section "$MEMORY_FILE" "Aktive Projekte" | grep -E '^\s*-' | grep -v 'Wird ergänzt' | head -5)
    if [ -n "$PROJECTS" ]; then
        echo ""
        echo "Aktive Projekte:"
        echo "$PROJECTS" | sed 's/^/  /'
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

exit 0
