#!/bin/bash

# Zum Projektverzeichnis (script-relativ, funktioniert auf jedem Host)
cd "$(dirname "$(realpath "$0")")"

# Alten Session-Container aufräumen falls vorhanden
docker rm -f mycoforge-session 2>/dev/null

# Claude im Container starten — docker run statt compose run,
# damit die Session nicht am Compose-Netzwerk hängt (ermöglicht sauberes update.sh)
docker run --name mycoforge-session -it \
  --env-file .env \
  -v mycoforge_mycoforge_workspace:/workspace \
  -v mycoforge_mycoforge_claude:/mycoforge/claude \
  -v mycoforge_mycoforge_runtime:/mycoforge/runtime \
  -v ~/.ssh:/root/.ssh:ro \
  -w /mycoforge \
  mycoforge-mycoforge:latest \
  claude
