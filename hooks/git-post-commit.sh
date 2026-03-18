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

# Doc-Update-Reminder: prüfen ob dokumentationsrelevante Verzeichnisse geändert wurden
CHANGED=$(git diff-tree --no-commit-id -r --name-only HEAD 2>/dev/null)

DOC_HINTS=""

echo "$CHANGED" | grep -q '^claude/agents/' && \
    DOC_HINTS="${DOC_HINTS}\n  • claude/agents/ → CLAUDE.md (Projektstruktur) · docs/agent-guide.md"

echo "$CHANGED" | grep -q '^claude/commands/' && \
    DOC_HINTS="${DOC_HINTS}\n  • claude/commands/ → README.md (Command-Tabelle) · docs/usage.md"

echo "$CHANGED" | grep -q '^skills/' && \
    DOC_HINTS="${DOC_HINTS}\n  • skills/ → CLAUDE.md (Projektstruktur)"

echo "$CHANGED" | grep -q '^hooks/' && \
    DOC_HINTS="${DOC_HINTS}\n  • hooks/ → CLAUDE.md (Hooks-Liste) · docs/usage.md (wenn Verhalten ändert)"

echo "$CHANGED" | grep -q '^knowledge/' && \
    DOC_HINTS="${DOC_HINTS}\n  • knowledge/ → knowledge/semantic-anchors.md (Index)"

if [ -n "$DOC_HINTS" ]; then
    echo ""
    echo "📄 Docs prüfen — folgende Bereiche haben sich geändert:"
    echo -e "$DOC_HINTS"
    echo ""
fi

exit 0
