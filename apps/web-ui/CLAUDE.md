# web-ui

Web-Oberfläche für mycoforge — Claude Code Chat im Browser, ohne SSH.

## Projekttyp
Fullstack Web-App (Next.js Frontend + Fastify Backend)

## Tech Stack
- Frontend: Next.js 15 · TypeScript · Tailwind CSS · shadcn/ui
- Backend: Fastify 5 · TypeScript · Node 22
- Kommunikation: REST (Sidebar-Daten) + WebSocket (Chat-Streaming)
- Auth: Cloudflare Tunnel + Cloudflare Access

## Struktur
```
apps/web-ui/
├── frontend/        ← Next.js 15 App (Port 3000)
│   ├── src/app/     ← App Router
│   └── src/components/
└── backend/         ← Fastify API + WebSocket (Port 3001)
    └── src/
```

## Claude-Integration
Claude Code wird als Subprocess aufgerufen:
  claude --print --output-format stream-json --verbose --include-partial-messages

Multi-Turn via --resume <session_id> aus dem Session-Store.

## Arbeitsweise
- Kein node-pty (kein xterm.js in V1)
- Separate Prozesse: Next.js Port 3000, Fastify Port 3001 — beide im selben Container
- Dev + Prod: next.config.ts rewrites /api/* und /ws/* → localhost:3001 (container-intern)
- Extern: Cloudflare Tunnel (network_mode: host) → 127.0.0.1:3000 (Docker published port)

## Deployment
- Nur Port 3000 wird nach außen published (127.0.0.1:3000:3000 in docker-compose.yml)
- Port 3001 (Fastify) ist nur container-intern erreichbar — nie direkt exponiert
- Tunnel-Origin muss 127.0.0.1:3000 sein (nicht localhost — IPv6-Auflösung vermeiden)
- Cloudflare Access sitzt vor dem Tunnel und übernimmt die Authentifizierung
