# Web-UI Setup

Browserbasierte Oberfläche für mycoforge — kein SSH mehr nötig.

## Architektur

```
Internet → Cloudflare Tunnel → cloudflared (Docker) → web-ui:3000 (Next.js)
                                                     ↓ /api/*
                                                     web-ui:3001 (Fastify)
                                                     ↓ claude subprocess
                                                     mycoforge (Claude Code CLI)
```

## Voraussetzungen

- Cloudflare-Account (kostenlos)
- Domain in Cloudflare (oder subdomain.workers.dev gratis)
- mycoforge läuft bereits

## Setup-Schritte

### 1. Cloudflare Tunnel anlegen

```bash
# Einmalig auf dem VPS oder lokal mit cloudflared installiert:
cloudflared tunnel login
cloudflared tunnel create mycoforge-web-ui

# Token ausgeben:
cloudflared tunnel token mycoforge-web-ui
```

Alternativ im Cloudflare-Dashboard:
1. Zero Trust → Access → Tunnels → "Create a tunnel"
2. Name: `mycoforge-web-ui`
3. Token kopieren

### 2. Token in .env eintragen

```bash
# Auf dem Host im mycoforge-Verzeichnis:
echo "CLOUDFLARE_TUNNEL_TOKEN=eyJ..." >> .env
```

### 3. DNS-Route konfigurieren

Im Cloudflare-Dashboard → Zero Trust → Tunnels → mycoforge-web-ui → "Configure":
- Subdomain: `forge` (oder nach Wahl)
- Domain: `deine-domain.com`
- Service: `http://web-ui:3000`

### 4. Web-UI starten

```bash
# Mit Cloudflare-Tunnel:
docker compose --profile tunnel up -d

# Nur lokal (ohne Tunnel):
docker compose up -d
# → erreichbar unter http://localhost:3000
```

### 5. Zugriff absichern (Empfohlen)

Im Cloudflare-Dashboard → Zero Trust → Access → Applications:
1. "Add an application" → Self-hosted
2. Application domain: `forge.deine-domain.com`
3. Policy: "Allow" → Emails → deine-email@example.com

Damit ist die Web-UI nur nach Cloudflare-Auth erreichbar (kostenlos).

## Smoke-Test

```bash
# Tunnel-Status prüfen:
docker logs mycoforge-cloudflared

# Health-Check:
curl https://forge.deine-domain.com/api/health
# → {"status":"ok","timestamp":"..."}
```

## Lokal entwickeln (ohne Cloudflare)

```bash
# Frontend:
cd apps/web-ui/frontend && npm install && npm run dev

# Backend (separates Terminal):
cd apps/web-ui/backend && npm install && npm run dev
```

→ Frontend: http://localhost:3000
→ Backend:  http://localhost:3001

## Troubleshooting

| Problem | Lösung |
|---------|--------|
| `TUNNEL_TOKEN` fehlt | .env prüfen, `--profile tunnel` flag |
| Backend nicht erreichbar | `docker logs mycoforge-web-ui` |
| Keine Projekte in Sidebar | `/workspace` Volume-Mount prüfen |
| Claude startet nicht | `claude --version` im mycoforge-Container testen |
