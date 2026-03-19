#!/bin/bash

echo "🍄 mycoforge update starting..."

# Zum Projektverzeichnis (script-relativ, funktioniert auf jedem Host)
cd "$(dirname "$(realpath "$0")")"

# Aktuelle Änderungen aus Git holen
echo "→ Pulling latest changes from GitHub..."
git pull

# Container neu bauen
echo "→ Rebuilding containers..."
docker compose --profile tunnel build

# Alles stoppen
echo "→ Stopping all containers..."
docker compose --profile tunnel down

# Alles starten (mit Tunnel-Profil)
echo "→ Starting all containers..."
docker compose --profile tunnel up -d

echo "✓ mycoforge updated successfully"
