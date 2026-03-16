#!/bin/bash

# Alten Session-Container aufräumen falls vorhanden
docker rm -f mycoforge-session 2>/dev/null

# Claude im Container starten, direkt in /mycoforge/
docker compose run --name mycoforge-session -it -w /mycoforge mycoforge claude
