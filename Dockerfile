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
    && rm -rf /var/lib/apt/lists/*

# Claude Code installieren
RUN npm install -g @anthropic-ai/claude-code

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
