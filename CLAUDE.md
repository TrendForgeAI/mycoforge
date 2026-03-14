# mycoforge

An organic AI development environment that grows with you.

## Was ist mycoforge?

mycoforge ist eine containerisierte KI-Entwicklungsumgebung auf einem Ubuntu VPS.
Sie wird genutzt um Projekte zu entwickeln – und kann sich dabei selbst weiterentwickeln.
mycoforge ist die Werkstatt. Die Projekte die darin entstehen sind die Werkstücke.

## Infrastruktur

- **VPS:** Ubuntu, Hostinger, /docker/mycoforge/
- **GitHub Account:** https://github.com/TrendForgeAI
- **Container Pfad:** /docker/mycoforge/
- **Arbeitsbereich:** /docker/mycoforge/workspace/ (temporär, nicht in Git)

## Projektstruktur
```
mycoforge/
├── CLAUDE.md              ← Projektkontext (dieser File)
├── MEMORY.md              ← Systemgedächtnis (wird beim Start automatisch befüllt)
├── README.md              ← für Menschen
├── Dockerfile             ← Container-Definition
├── docker-compose.yml     ← Deployment
├── entrypoint.sh          ← Initialisierung beim Start
├── update.sh              ← Update-Workflow (git pull → build → restart)
├── .env                   ← Secrets (nie in Git)
├── .env.example           ← Dokumentation der benötigten Variablen
├── claude/                ← Claude Code Konfiguration (nie in Git)
├── workspace/             ← Projekte (temporär, nie in Git)
└── knowledge/             ← Wissensbasis (bei Bedarf laden)
    ├── models.md          ← Modelle & Routing-Logik
    ├── git-workflow.md    ← Git-Konventionen
    ├── new-project.md     ← Neues Projekt anlegen
    └── docker.md          ← Container-Änderungen
```

## Arbeitsweise

- Jede Änderung wird verstanden bevor sie gemacht wird
- Atomic Commits nach jeder abgeschlossenen Aufgabe
- Keine Secrets in Git – immer .env.example statt .env
- Änderungen an mycoforge selbst werden sofort committed und gepusht
- Projekte entstehen in workspace/ als geklonte GitHub Repos

## Modell-Routing

Verfügbare Provider stehen in MEMORY.md.
Für Modell-Entscheidungen: @knowledge/models.md laden.

Grundprinzip:
- Planung / Architektur → größtes verfügbares Modell
- Code schreiben → mittleres Modell
- Dateioperationen / einfache Edits → kleinstes Modell
- Routing-Entscheidung selbst → kleinstes Modell

## Neue Projekte anlegen

Für detaillierte Schritte: @knowledge/new-project.md laden.

Kurzfassung:
1. GitHub Repo anlegen (TrendForgeAI/projekt-name)
2. In workspace/ klonen
3. CLAUDE.md, README.md, .gitignore erstellen
4. Erstes Commit: "init: project scaffold"

## mycoforge selbst verbessern

mycoforge ist ein Projekt wie jedes andere:
1. Änderung verstehen und planen
2. Umsetzen und testen
3. Atomic Commit
4. ./update.sh ausführen

## KI-Runtimes

- Claude Code ✅ (primär, installiert)
- Gemini CLI 🔜 (geplant)
- OpenCode 🔜 (geplant)
- Codex 🔜 (geplant)
