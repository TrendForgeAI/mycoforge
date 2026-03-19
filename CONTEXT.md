# CONTEXT.md — Risiko-Lösungen Web-UI

Entscheidung getroffen: 2026-03-19

## Entscheidung

Alle 5 Implementierungsrisiken der mycoforge Web-UI sind mit konkreten
Lösungsmustern adressiert. Kein Blocker für den Start.

## Lösungen

### Risiko 1 — node-pty Compilation
`@homebridge/node-pty-prebuilt-multiarch` statt `node-pty`.
Prebuilt Binaries für Linux/x64/Node 22 — kein node-gyp, kein build-essential im Dockerfile.

### Risiko 2 — Claude Code Output-Format (PoC-Pflicht vor T2)
Vor Implementierung des Backends PoC im Container:
- `claude --output-format stream-json` prüfen
- Bob hat Chat-UI gewählt → strukturierter Output bevorzugt
- Fallback: raw ANSI-Stream + xterm.js wenn kein JSON-Mode verfügbar
- Backend leitet Stream durch, kein spekulativer Parser

### Risiko 3 — Cloudflare Tunnel
- `CLOUDFLARE_TUNNEL_TOKEN` als optionale .env-Variable
- System funktioniert ohne Token auf localhost:3000
- `docs/web-ui-setup.md` mit manuellem Setup-Guide
- secrets-scan-Hook muss Token-Patterns erkennen

### Risiko 4 — Fastify + Next.js
**Kein Custom Server.** Zwei separate Prozesse:
- Next.js auf Port 3000 (`next start`)
- Fastify (API + WebSocket) auf Port 3001
- nginx/Caddy: `/api/*` → 3001, `/*` → 3000
- Dev: `next.config.js` rewrites() für `/api/*`

### Risiko 5 — WebSocket-Reconnect / PTY-Lifecycle
- `Map<sessionId, PtySession>` im Fastify-Prozess (Session-Store)
- PTY bleibt am Leben bei WS-Disconnect (30s Reconnect-Fenster)
- Ring-Buffer 10.000 Zeichen → Replay bei Reconnect
- Nach Timeout: `ptyProcess.kill()` + Session cleanup
- Idle-Timeout: 4 Stunden (Root-Prozesse im Container!)

## Auflagen / Einschränkungen

- Risiko 2 PoC MUSS vor T2-Implementierung abgeschlossen sein
- Auth (Cloudflare Access) auf jedem HTTP- und WebSocket-Endpunkt — kein ungeschützter Endpoint

## Nicht-Entschieden

- Ob `claude --output-format stream-json` tatsächlich existiert (wird im PoC geklärt)
- Exaktes nginx vs. Caddy für Reverse-Proxy (beide funktionieren, Entscheidung bei Implementierung)
- ob xterm.js in V1 benötigt wird (abhängt von PoC-Ergebnis)
