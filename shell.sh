#!/bin/bash

# Prüfen ob Session läuft
if ! docker ps | grep -q mycoforge-session; then
    echo "❌ Keine aktive mycoforge Session gefunden."
    echo "   Starte zuerst: ./start.sh"
    exit 1
fi

# In laufenden Container einsteigen, direkt in /mycoforge/
docker exec -it -w /mycoforge mycoforge-session bash
