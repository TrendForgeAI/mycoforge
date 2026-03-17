#!/bin/bash
# Git post-commit Hook
# Wird von Git nach jedem Commit aufgerufen.
# Installiert durch entrypoint.sh als .git/hooks/post-commit

REPO_DIR="$(pwd)"
MEMORY_FILE="/mycoforge/MEMORY.md"

# MEMORY.md auf Platzhalter prüfen (nur im mycoforge Repo)
if [ "$REPO_DIR" = "/mycoforge" ] && grep -q '<!-- Wird ergänzt' "$MEMORY_FILE" 2>/dev/null; then
    echo "ℹ️  MEMORY.md hat noch Platzhalter — bei Bedarf aktualisieren."
fi

exit 0
