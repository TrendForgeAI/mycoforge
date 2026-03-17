#!/bin/bash

echo "🍄 mycoforge update starting..."

# Zum Projektverzeichnis (script-relativ, funktioniert auf jedem Host)
cd "$(dirname "$(realpath "$0")")"

# Aktuelle Änderungen aus Git holen
echo "→ Pulling latest changes from GitHub..."
git pull

# Container neu bauen
echo "→ Rebuilding container..."
docker compose build

# Laufenden Container neu starten falls er läuft
if docker ps | grep -q "mycoforge"; then
    echo "→ Restarting running container..."
    docker compose restart
fi

echo "✓ mycoforge updated successfully"
