# mycoforge

An organic AI development environment that grows with you.

## Was ist mycoforge?

mycoforge ist eine containerisierte KI-Entwicklungsumgebung auf einem Ubuntu VPS.
Sie wird genutzt um Projekte zu entwickeln – und kann sich dabei selbst weiterentwickeln.
mycoforge ist die Werkstatt. Die Projekte die darin entstehen sind die Werkstücke.

## Infrastruktur

- **VPS:** Ubuntu, Hostinger, /docker/mycoforge/
- **GitHub Organisation:** https://github.com/TrendForgeAI
- **Container Pfad:** /docker/mycoforge/
- **Arbeitsbereich:** /docker/mycoforge/workspace/ (temporär, nicht in Git)

## Projektstruktur
```
mycoforge/
├── CLAUDE.md          ← Projektkontext (dieser File)
├── MEMORY.md          ← Systemgedächtnis (wird beim Start automatisch befüllt)
├── README.md          ← für Menschen
├── Dockerfile         ← Container-Definition
├── docker-compose.yml ← Deployment
├── entrypoint.sh      ← Initialisierung beim Start
├── update.sh          ← Update-Workflow (git pull → build → restart)
├── .env               ← Secrets (nie in Git)
├── .env.example       ← Dokumentation der benötigten Variablen
├── claude/            ← Claude Code Konfiguration (nie in Git)
└── workspace/         ← Arbeitsbereich für Projekte (Inhalt nie in Git)
```

## Arbeitsweise

- Jede Änderung wird verstanden bevor sie gemacht wird
- Atomic Commits nach jeder abgeschlossenen Aufgabe
- Keine Secrets in Git – immer .env.example statt .env
- Änderungen an mycoforge selbst werden sofort committed und gepusht
- Projekte entstehen in workspace/ als geklonte GitHub Repos

## Modell-Routing

mycoforge nutzt intelligentes Modell-Routing basierend auf der Aufgabe.
Verfügbare Provider stehen in MEMORY.md.

- **Planung / Architektur / Zusammenhänge** → größtes verfügbares Modell
- **Code schreiben** → mittleres Modell
- **Dateioperationen / einfache Edits** → kleinstes verfügbares Modell
- **Routing-Entscheidung selbst** → kleinstes verfügbares Modell

## Neue Projekte anlegen

Jedes Projekt bekommt ein eigenes GitHub Repo unter TrendForgeAI.
workspace/ ist der temporäre Arbeitsbereich – GitHub ist die Quelle der Wahrheit.

1. GitHub Repo anlegen (https://github.com/TrendForgeAI/projekt-name)
2. In workspace/ klonen: git clone git@github.com:TrendForgeAI/projekt-name.git
3. CLAUDE.md mit Projektkontext erstellen
4. README.md erstellen
5. .gitignore erstellen
6. Erstes Commit: "init: project scaffold"
7. Pushen

## mycoforge selbst verbessern

mycoforge ist ein Projekt wie jedes andere. Verbesserungen:
1. Änderung verstehen und planen
2. Umsetzen
3. Testen
4. Atomic Commit
5. ./update.sh ausführen

## KI-Runtimes

- Claude Code ✅ (primär, installiert)
- Gemini CLI 🔜 (geplant)
- OpenCode 🔜 (geplant)
- Codex 🔜 (geplant)
