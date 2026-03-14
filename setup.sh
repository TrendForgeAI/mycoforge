#!/bin/bash

echo "🍄 mycoforge setup starting..."

# Git Identität setzen
echo "→ Configuring git identity..."
git config --global user.name "TrendForgeAI"
git config --global user.email "trendforge.ai@gmail.com"

# SSH Key für GitHub prüfen
if [ ! -f ~/.ssh/github_mycoforge ]; then
    echo "→ Creating SSH key for GitHub..."
    ssh-keygen -t ed25519 -C "mycoforge@trendforge" -f ~/.ssh/github_mycoforge -N ""
    cat >> ~/.ssh/config << 'SSHEOF'
Host github.com
  IdentityFile ~/.ssh/github_mycoforge
  User git
SSHEOF
    echo ""
    echo "⚠️  Add this SSH key to GitHub (Settings → SSH Keys):"
    echo ""
    cat ~/.ssh/github_mycoforge.pub
    echo ""
    read -p "Press Enter when done..."
fi

# .env anlegen falls nicht vorhanden
if [ ! -f .env ]; then
    echo "→ Creating .env from .env.example..."
    cp .env.example .env
    echo "⚠️  Please edit .env and add your API keys:"
    echo "   nano .env"
fi

# Claude credentials prüfen
if [ ! -f claude/.credentials.json ]; then
    echo "→ Claude credentials not found"
    echo "⚠️  Copy your credentials or run: claude auth login"
    echo "   cp ~/.claude/.credentials.json claude/.credentials.json"
fi

# MEMORY.md von Git-Tracking ausschließen
echo "→ Excluding MEMORY.md from git tracking..."
git update-index --skip-worktree MEMORY.md

# Docker Container bauen
echo "→ Building Docker container..."
docker compose build

echo ""
echo "✓ mycoforge setup complete"
echo ""
echo "Next steps:"
echo "  1. Edit .env and add your API keys"
echo "  2. Copy Claude credentials to claude/.credentials.json"
echo "  3. Run: docker compose run --rm mycoforge claude -p 'test'"
