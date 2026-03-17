#!/bin/bash
# Claude Code PostToolUse Hook — Bash
# Wird nach jedem Bash-Tool-Aufruf ausgeführt.
# Nach git commit: MEMORY.md auf Aktualität prüfen.

INPUT=$(node -e "
const chunks = [];
process.stdin.on('data', d => chunks.push(d));
process.stdin.on('end', () => {
  try {
    const d = JSON.parse(chunks.join(''));
    process.stdout.write(JSON.stringify({
      command: (d.tool_input || {}).command || ''
    }));
  } catch(e) {
    process.stdout.write(JSON.stringify({ command: '' }));
  }
});
" 2>/dev/null)

COMMAND=$(node -e "process.stdout.write(JSON.parse(process.argv[1]).command)" "$INPUT" 2>/dev/null)

# Nur nach git commit ausführen
if ! echo "$COMMAND" | grep -qE 'git\s+(-.+\s+)*commit'; then
    exit 0
fi

# Repo-Verzeichnis aus -C Flag extrahieren
REPO_DIR=$(echo "$COMMAND" | grep -oE -- '-C\s+\S+' | head -1 | awk '{print $2}')
if [ -z "$REPO_DIR" ]; then
    REPO_DIR=$(pwd)
fi

# Letzten Commit-Info holen
COMMIT_INFO=$(git -C "$REPO_DIR" log -1 --pretty=format:"%h %s" 2>/dev/null)
COMMIT_DATE=$(git -C "$REPO_DIR" log -1 --pretty=format:"%ci" 2>/dev/null | cut -d' ' -f1)
REPO_NAME=$(basename "$REPO_DIR")

# MEMORY.md auf Platzhalter prüfen
MEMORY_FILE="/mycoforge/MEMORY.md"
if grep -q '<!-- Wird ergänzt' "$MEMORY_FILE" 2>/dev/null; then
    echo "ℹ️  Hinweis: MEMORY.md hat noch Platzhalter — bitte bei Bedarf aktualisieren."
fi

# Commit in Session-Log eintragen
SESSION_LOG="/mycoforge/claude/history.jsonl"
if [ -f "$SESSION_LOG" ] && [ -n "$COMMIT_INFO" ]; then
    echo "{\"type\":\"commit\",\"repo\":\"$REPO_NAME\",\"commit\":\"$COMMIT_INFO\",\"date\":\"$COMMIT_DATE\"}" >> "$SESSION_LOG" 2>/dev/null
fi

exit 0
