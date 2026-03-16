#!/bin/bash

# Alten Session-Container aufräumen falls vorhanden
docker rm -f mycoforge-session 2>/dev/null

# Claude im Container starten
docker compose run --name mycoforge-session -it mycoforge claude
