# mycoforge

An organic AI development environment that grows with you.

## Was ist mycoforge?

mycoforge ist eine containerisierte KI-Entwicklungsumgebung auf einem Ubuntu VPS.
Sie wird genutzt um Projekte zu entwickeln – und kann sich dabei selbst weiterentwickeln.
mycoforge ist die Werkstatt. Die Projekte die darin entstehen sind die Werkstücke.

## Wichtige Pfade

- **Im Container:** /mycoforge/ (dieses Projekt), /workspace/ (Projekte)
- **Auf dem Host:** /docker/mycoforge/
- **GitHub:** https://github.com/TrendForgeAI

## Projektstruktur
```
mycoforge/
├── CLAUDE.md              ← Projektkontext (dieser File)
├── ARCHITECTURE.md        ← Agent-Patterns & Systemarchitektur
├── MEMORY.md              ← Systemgedächtnis (wird beim Start automatisch befüllt)
├── README.md              ← für Menschen
├── TODO.md                ← offene Punkte
├── LICENSE                ← MIT Lizenz
├── Dockerfile             ← Container-Definition
├── docker-compose.yml     ← Deployment
├── start.sh               ← Claude starten (Terminal 1)
├── shell.sh               ← Shell in laufenden Container (Terminal 2)
├── setup.sh               ← Einmalige Erstinstallation
├── update.sh              ← Update-Workflow (git pull → build → restart)
├── entrypoint.sh          ← Initialisierung beim Container-Start
├── .env                   ← Secrets (nie in Git)
├── .env.example           ← Dokumentation der benötigten Variablen
├── claude/                ← Claude Code Konfiguration (nie in Git)
├── workspace/             ← Projekte (temporär, nie in Git)
└── knowledge/             ← Wissensbasis (bei Bedarf laden)
    ├── models.md          ← Modelle & Routing-Logik
    ├── git-workflow.md    ← Git-Konventionen
    ├── project-wizard.md  ← Neues Projekt anlegen
    └── docker.md          ← Container-Änderungen
```

## Arbeitsweise

- Jede Änderung wird verstanden bevor sie gemacht wird
- Atomic Commits nach jeder abgeschlossenen Aufgabe
- Keine Secrets in Git – immer .env.example statt .env
- Änderungen an mycoforge selbst werden sofort committed und gepusht
- Projekte entstehen in /workspace/ als geklonte GitHub Repos

## Modell-Routing

Verfügbare Provider stehen in MEMORY.md.
Für Modell-Entscheidungen: @knowledge/models.md laden.

Grundprinzip:
- Planung / Architektur → größtes verfügbares Modell
- Code schreiben → mittleres Modell
- Dateioperationen / einfache Edits → kleinstes Modell
- Routing-Entscheidung selbst → kleinstes Modell

## Neue Projekte anlegen

Wenn der Nutzer ein neues Projekt anlegen möchte:
1. Lies ZUERST @knowledge/project-wizard.md
2. Befolge die Schritte dort EXAKT – kein eigener Wizard
3. Stelle alle Pflichtfragen BEVOR du anfängst
4. Lege das GitHub Repo mit `gh` an
5. Klone es in /workspace/
6. Erstelle CLAUDE.md, README.md, .gitignore
7. Mache den ersten Commit und pushe

Jedes Projekt bekommt eine CLAUDE.md – unabhängig davon ob es KI nutzt.
Die CLAUDE.md ist für Claude Code als Entwickler, nicht für die Anwendung selbst.

## mycoforge selbst verbessern

mycoforge ist ein Projekt wie jedes andere:
1. Änderung verstehen und planen
2. Umsetzen und testen
3. Atomic Commit auf dem Host: cd /docker/mycoforge && git add . && git commit && git push
4. ./update.sh ausführen

## KI-Runtimes

- Claude Code ✅ (primär, installiert)
- Gemini CLI 🔜 (geplant)
- OpenCode 🔜 (geplant)
- Codex 🔜 (geplant)
