# ── Stage 1: Frontend Build ──────────────────────────────────────────────────
FROM node:22-slim AS frontend-builder
WORKDIR /app
COPY apps/web-ui/frontend/package*.json ./
RUN npm install
COPY apps/web-ui/frontend/ ./
RUN npm run build

# ── Stage 2: Backend Build ────────────────────────────────────────────────────
FROM node:22-slim AS backend-builder
WORKDIR /app
COPY apps/web-ui/backend/package*.json ./
RUN npm install
COPY apps/web-ui/backend/ ./
RUN npm run build

# ── Stage 3: mycoforge ───────────────────────────────────────────────────────
FROM node:22-slim

LABEL org.opencontainers.image.title="mycoforge"
LABEL org.opencontainers.image.description="An organic AI development environment that grows with you"
LABEL org.opencontainers.image.source="https://github.com/TrendForgeAI/mycoforge"

# System dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    ca-certificates \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Claude Code installieren
RUN npm install -g @anthropic-ai/claude-code

# ~/.claude → /mycoforge/claude (Claude Code findet Commands/Agents direkt im Image)
RUN ln -s /mycoforge/claude /root/.claude

# GitHub CLI installieren
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

# Umgebungsvariablen
ENV TZ=Europe/Berlin
ENV NODE_ENV=production

# Code ins Image backen (Self-Contained für Platform-Deployments)
COPY . /mycoforge/

# Frontend: Next.js standalone output + static files
COPY --from=frontend-builder /app/.next/standalone /mycoforge/apps/web-ui/frontend/standalone
COPY --from=frontend-builder /app/.next/static /mycoforge/apps/web-ui/frontend/standalone/.next/static

# Backend: kompiliertes JS + node_modules (production only)
COPY --from=backend-builder /app/dist /mycoforge/apps/web-ui/backend/dist
COPY --from=backend-builder /app/node_modules /mycoforge/apps/web-ui/backend/node_modules

WORKDIR /mycoforge

# Entrypoint Script
RUN chmod +x /mycoforge/entrypoint.sh
ENTRYPOINT ["/mycoforge/entrypoint.sh"]

# Standard-Shell
CMD ["/bin/bash"]
