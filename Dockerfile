# mycoforge - AI Development Environment
# Base: Node.js 20 slim (Debian-based)
FROM node:20-slim

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

# Symlink Claude config to expected location
RUN ln -s /root/.claude/.claude.json /root/.claude.json

# GitHub CLI installieren
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

# Arbeitsverzeichnis
WORKDIR /workspace

# Umgebungsvariablen
ENV TZ=Europe/Berlin
ENV NODE_ENV=production

# Entrypoint Script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Standard-Shell
CMD ["/bin/bash"]
