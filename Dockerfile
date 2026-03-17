# mycoforge - AI Development Environment
# Base: Node.js 22 LTS slim (Debian-based)
FROM node:22-slim

# Maintainer
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
WORKDIR /mycoforge

# Entrypoint Script
RUN chmod +x /mycoforge/entrypoint.sh
ENTRYPOINT ["/mycoforge/entrypoint.sh"]

# Standard-Shell
CMD ["/bin/bash"]
