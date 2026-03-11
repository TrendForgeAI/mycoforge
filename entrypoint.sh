#!/bin/bash

# Claude config erstellen falls nicht vorhanden
if [ ! -f /root/.claude/.claude.json ]; then
    echo '{"firstStartTime": "'$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'"}' > /root/.claude/.claude.json
fi

# Übergebenen Befehl ausführen
exec "$@"
