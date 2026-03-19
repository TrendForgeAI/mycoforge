#!/bin/bash

# Claude config erstellen falls nicht vorhanden
if [ ! -f /mycoforge/claude/.claude.json ]; then
    echo '{"firstStartTime": "'$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'"}' > /mycoforge/claude/.claude.json
fi

# /root/.claude.json → persistentes Volume verlinken
ln -sf /mycoforge/claude/.claude.json /root/.claude.json

# Verfügbare AI Provider — werden durch Generator aus config/model-routing.yaml ermittelt

# Neueste Änderungen aus GitHub holen (Fallback für automatische Neustarts)
if [ -n "$GH_TOKEN" ]; then
    cd /mycoforge
    if git diff --quiet HEAD 2>/dev/null; then
        git pull --ff-only 2>/dev/null || true
    fi
fi

# Git mit GitHub Token konfigurieren
if [ -n "$GH_TOKEN" ]; then
    git config --global credential.helper store
    echo "https://${GH_ORG}:${GH_TOKEN}@github.com" > /root/.git-credentials
    chmod 600 /root/.git-credentials
    git config --global user.name "${GIT_USER_NAME:-}"
    git config --global user.email "${GIT_USER_EMAIL:-}"
fi

# MEMORY.md generieren (liest config/model-routing.yaml + manifests/ statt Markdown zu scrapen)
bash /mycoforge/scripts/generate-memory.sh

# Git Hooks installieren (mycoforge Repo)
if [ -d /mycoforge/.git/hooks ]; then
    cp /mycoforge/hooks/git-pre-commit.sh /mycoforge/.git/hooks/pre-commit
    cp /mycoforge/hooks/git-post-commit.sh /mycoforge/.git/hooks/post-commit
    chmod +x /mycoforge/.git/hooks/pre-commit /mycoforge/.git/hooks/post-commit
fi

# Hook-Skripte ausführbar machen
chmod +x /mycoforge/hooks/*.sh 2>/dev/null

# Übergebenen Befehl ausführen
exec "$@"
