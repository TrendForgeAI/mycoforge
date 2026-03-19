#!/bin/sh
set -e

echo "Starting mycoforge web-ui..."

# Backend (Port 3001)
node /app/backend/dist/server.js &
BACKEND_PID=$!

# Frontend (Port 3000) — Next.js standalone
node /app/frontend/server.js &
FRONTEND_PID=$!

echo "Backend PID: $BACKEND_PID"
echo "Frontend PID: $FRONTEND_PID"

# Warte auf beide Prozesse
wait $BACKEND_PID $FRONTEND_PID
