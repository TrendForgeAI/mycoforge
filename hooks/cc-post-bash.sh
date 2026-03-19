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

# Commit in Session-Log eintragen
SESSION_LOG="/mycoforge/claude/history.jsonl"
if [ -f "$SESSION_LOG" ] && [ -n "$COMMIT_INFO" ]; then
    SAFE_COMMIT=$(echo "$COMMIT_INFO" | sed 's/\\/\\\\/g; s/"/\\"/g')
    SAFE_REPO=$(echo "$REPO_NAME" | sed 's/\\/\\\\/g; s/"/\\"/g')
    echo "{\"type\":\"commit\",\"repo\":\"$SAFE_REPO\",\"commit\":\"$SAFE_COMMIT\",\"date\":\"$COMMIT_DATE\"}" >> "$SESSION_LOG" 2>/dev/null
fi

# Docs-Update-Reminder als context injection
# Prüfe ob relevante Dateien betroffen sind (Struktur, API, Commands, Architektur)
CHANGED_FILES=$(git -C "$REPO_DIR" diff HEAD~1 --name-only 2>/dev/null || true)
DOCS_HINT=""

# Strukturelle Änderungen: neue Dateien/Verzeichnisse oder entfernte
if echo "$CHANGED_FILES" | grep -qE '(apps/|hooks/|skills/|knowledge/|claude/|scripts/|config/)'; then
    DOCS_HINT="Strukturelle Änderung erkannt."
fi
# Neue Features oder größere Code-Änderungen
if echo "$CHANGED_FILES" | grep -qE '\.(ts|tsx|py|sh|yaml|yml)$'; then
    DOCS_HINT="${DOCS_HINT} Code-Änderung erkannt."
fi

if [ -n "$DOCS_HINT" ]; then
    node -e "
const hint = process.argv[1];
const msg = 'Docs-Check nach Commit: ' + hint + ' Prüfe ob CLAUDE.md (Projektstruktur), README.md oder docs/ aktualisiert werden sollten. Wenn ja, jetzt aktualisieren und committen.';
process.stdout.write(JSON.stringify({
  hookSpecificOutput: {
    hookEventName: 'PostToolUse',
    additionalContext: msg
  }
}) + '\n');
" "$DOCS_HINT" 2>/dev/null
fi

exit 0
