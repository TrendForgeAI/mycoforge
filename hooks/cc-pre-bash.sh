#!/bin/bash
# Claude Code PreToolUse Hook — Bash
# Wird vor jedem Bash-Tool-Aufruf ausgeführt.
# Prüft bei git commit auf Secrets.
#
# Exit 0 = erlauben, Exit 2 = blockieren

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

# Nur bei git commit prüfen
if ! echo "$COMMAND" | grep -qE 'git\s+(-.+\s+)*commit'; then
    exit 0
fi

# Repo-Verzeichnis aus -C Flag extrahieren
REPO_DIR=$(echo "$COMMAND" | grep -oE -- '-C\s+\S+' | head -1 | awk '{print $2}')
if [ -z "$REPO_DIR" ]; then
    REPO_DIR="/mycoforge"
fi

# Scan ausführen
RESULT=$(/mycoforge/hooks/secrets-scan.sh "$REPO_DIR" 2>&1)
STATUS=$?

if [ $STATUS -ne 0 ]; then
    echo "$RESULT"
    echo ""
    echo "Commit blockiert. Bitte Secrets entfernen und erneut versuchen."
    exit 2
fi

exit 0
