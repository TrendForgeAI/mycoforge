#!/bin/bash
# Secrets-Scan für einen Git-Repository
# Wird als Git pre-commit Hook und vom Claude Code Hook aufgerufen
#
# Usage: secrets-scan.sh [REPO_DIR]
#   REPO_DIR: Pfad zum Git-Repo (default: aktuelles Verzeichnis)

REPO_DIR="${1:-$(pwd)}"

# Git root ermitteln
GIT_ROOT=$(git -C "$REPO_DIR" rev-parse --show-toplevel 2>/dev/null)
if [ -z "$GIT_ROOT" ]; then
    exit 0
fi

ERRORS=0

# 1. .env Dateien prüfen
STAGED_FILES=$(git -C "$GIT_ROOT" diff --cached --name-only 2>/dev/null)

if echo "$STAGED_FILES" | grep -qE '(^|/)\.env($|\.(?!example))'; then
    echo "🚨 FEHLER: .env Datei ist gestaged!"
    echo "   Entfernen: git restore --staged .env"
    ERRORS=$((ERRORS + 1))
fi

# 2. Staged Content auf Secret-Patterns prüfen
STAGED_DIFF=$(git -C "$GIT_ROOT" diff --cached 2>/dev/null)

# API Keys & Tokens (gängige Formate)
if echo "$STAGED_DIFF" | grep -qE '^\+(sk-[a-zA-Z0-9]{20,}|AIza[0-9A-Za-z_-]{35}|ghp_[a-zA-Z0-9]{36}|ghs_[a-zA-Z0-9]{36}|xoxb-[0-9]+-[a-zA-Z0-9]+|AKIA[0-9A-Z]{16})'; then
    echo "🚨 FEHLER: Bekanntes API-Key-Format im Staged-Content gefunden!"
    echo "   Überprüfen: git diff --cached"
    ERRORS=$((ERRORS + 1))
fi

# Generische Secret-Assignments
if echo "$STAGED_DIFF" | grep -qiE '^\+[[:space:]]*(API_KEY|SECRET_KEY|AUTH_TOKEN|ACCESS_TOKEN|PRIVATE_KEY|OPENAI_API_KEY|ANTHROPIC_API_KEY|GEMINI_API_KEY|GH_TOKEN|DATABASE_URL)[[:space:]]*=[[:space:]]*[^\$\{]'; then
    # Falsch-Positive ausfiltern: leere Werte, Platzhalter, Kommentare
    SUSPICIOUS=$(echo "$STAGED_DIFF" | grep -iE '^\+[[:space:]]*(API_KEY|SECRET_KEY|AUTH_TOKEN|ACCESS_TOKEN|PRIVATE_KEY|OPENAI_API_KEY|ANTHROPIC_API_KEY|GEMINI_API_KEY|GH_TOKEN|DATABASE_URL)[[:space:]]*=[[:space:]]*[^\$\{]' | grep -vE '=\s*("|'"'"'|#|$|<|your[-_]|YOUR[-_]|xxx|XXX|placeholder|PLACEHOLDER|changeme|CHANGEME|"""|'"'''"')' 2>/dev/null)
    if [ -n "$SUSPICIOUS" ]; then
        echo "⚠️  WARNUNG: Mögliche Secrets im Staged-Content:"
        echo "$SUSPICIOUS" | head -5
        echo "   Überprüfen: git diff --cached"
        ERRORS=$((ERRORS + 1))
    fi
fi

if [ $ERRORS -eq 0 ]; then
    echo "✓ Secrets-Scan: Keine Probleme gefunden"
    exit 0
else
    exit 1
fi
