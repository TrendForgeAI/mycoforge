#!/bin/bash
# cc-stop.sh — Automatische Session Memory (Stop Hook)
# Feuert nach jeder Claude-Antwort.
# Schreibt Git-Stand in /mycoforge/claude/session-memory.md
# (persistentes Volume, nie in Git).

MEMORY_FILE="/mycoforge/claude/session-memory.md"
TODAY=$(date +%Y-%m-%d)

cd /mycoforge 2>/dev/null || exit 0

# Aktuellen Git-Stand ermitteln
LAST_COMMIT=$(git log --oneline -1 2>/dev/null | cut -c1-80)
[ -z "$LAST_COMMIT" ] && exit 0

UNCOMMITTED=$(git diff --name-only 2>/dev/null | head -5 | tr '\n' ' ' | sed 's/ $//')

# Heutigen Eintrag aufbauen
NEW_ENTRY="## $TODAY
Commit: $LAST_COMMIT"
[ -n "$UNCOMMITTED" ] && NEW_ENTRY="$NEW_ENTRY
Offen:  $UNCOMMITTED"

# Idempotenz: nichts tun wenn sich nichts geändert hat
if [ -f "$MEMORY_FILE" ] && grep -q "^## $TODAY" "$MEMORY_FILE" 2>/dev/null; then
    CURRENT=$(awk "/^## $TODAY/{found=1; next} found && /^## /{exit} found{print}" "$MEMORY_FILE")
    EXPECTED="Commit: $LAST_COMMIT"
    [ -n "$UNCOMMITTED" ] && EXPECTED="$EXPECTED
Offen:  $UNCOMMITTED"
    [ "$CURRENT" = "$EXPECTED" ] && exit 0
fi

# Vorherige Einträge lesen (ohne heutigen, max 9 weitere)
PREVIOUS=""
if [ -f "$MEMORY_FILE" ]; then
    PREVIOUS=$(awk -v today="## $TODAY" '
        /^# Session Memory/ { next }
        /^## / {
            if ($0 == today) { skip=1; next }
            skip=0; sections++
            if (sections > 9) exit
        }
        !skip { print }
    ' "$MEMORY_FILE")
fi

# Neues File schreiben: Header + heutiger Eintrag + vorherige
TMPFILE=$(mktemp)
{
    echo "# Session Memory"
    echo ""
    printf '%s\n' "$NEW_ENTRY"
    if [ -n "$PREVIOUS" ]; then
        echo ""
        printf '%s\n' "$PREVIOUS"
    fi
} > "$TMPFILE"

mv "$TMPFILE" "$MEMORY_FILE"
