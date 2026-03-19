# Stage 1: Base
FROM node:22-slim AS base
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app

# Stage 2: Frontend Dependencies + Build
FROM base AS frontend-builder
COPY frontend/package*.json ./frontend/
RUN cd frontend && npm install --omit=dev
COPY frontend/ ./frontend/
RUN cd frontend && npm run build

# Stage 3: Backend Dependencies + Build
FROM base AS backend-builder
COPY backend/package*.json ./backend/
RUN cd backend && npm install
COPY backend/ ./backend/
RUN cd backend && npm run build

# Stage 4: Production
FROM base AS production
# Frontend: Next.js standalone output + static files
COPY --from=frontend-builder /app/frontend/.next/standalone ./frontend/
COPY --from=frontend-builder /app/frontend/.next/static ./frontend/.next/static
COPY --from=frontend-builder /app/frontend/public ./frontend/public 2>/dev/null || true
# Backend: kompiliertes JS + node_modules (production only)
COPY --from=backend-builder /app/backend/dist ./backend/dist
COPY --from=backend-builder /app/backend/node_modules ./backend/node_modules

# Start-Script
COPY docker-entrypoint.sh ./
RUN chmod +x docker-entrypoint.sh

EXPOSE 3000 3001
CMD ["./docker-entrypoint.sh"]
