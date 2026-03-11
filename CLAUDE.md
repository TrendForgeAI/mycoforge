# mycoforge

An organic AI development environment that grows with you.

## Was ist mycoforge?

mycoforge ist eine containerisierte KI-Entwicklungsumgebung auf einem Ubuntu VPS.
Sie ermöglicht es, mit verschiedenen KI-Runtimes (Claude Code, Gemini, OpenCode, Codex)
Projekte zu entwickeln – und sich dabei selbst weiterzuentwickeln.

## Infrastruktur

- **VPS:** Ubuntu, Hostinger, /docker/mycoforge/
- **GitHub:** https://github.com/TrendForgeAI/mycoforge
- **Bestehende Projekte:** OpenClaw unter /docker/openclaw-kv9c/

## Projektstruktur
```
mycoforge/
├── CLAUDE.md          ← dieser File (Projektkontext)
├── README.md          ← für Menschen
├── Dockerfile         ← Container-Definition
├── docker-compose.yml ← Deployment
├── .env.example       ← benötigte Umgebungsvariablen
└── claude/
    └── settings.json  ← Claude Code Konfiguration
```

## Arbeitsweise

- Jede Änderung wird verstanden bevor sie gemacht wird
- Atomic Commits nach jeder abgeschlossenen Aufgabe
- Keine Secrets in Git – immer .env.example statt .env
- Der Container soll transparent und nachvollziehbar sein

## KI-Runtimes

Ziel ist die Unterstützung mehrerer Runtimes:
- Claude Code (primär, bereits installiert auf Host)
- Gemini CLI (geplant)
- OpenCode (geplant)
- Codex (geplant)
