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
│   ├── commands/          ← Slash Commands
│   │   ├── new-project.md ← Interaktiver Projekt-Wizard
│   │   ├── plan.md        ← Aufgabe analysieren (Plan & Solve)
│   │   ├── implement.md   ← Plan umsetzen (Orchestrator)
│   │   ├── review.md      ← Code Review (Council, 3 Runden)
│   │   ├── discuss.md     ← Architektur-Entscheidung (Council, 2-5 Runden)
│   │   ├── commit.md      ← Intelligenter Commit
│   │   └── route.md       ← Task klassifizieren & Modell wählen
│   └── agents/            ← Agent-Definitionen
│       ├── planner.md         ← Aufgabe zerlegen, Abhängigkeiten (Groß)
│       ├── developer.md       ← Code schreiben, Features, Bugfixes (Mittel)
│       ├── frontend.md        ← UI, CSS, React, Accessibility (Mittel)
│       ├── backend.md         ← API, Datenbank, Business Logic (Mittel)
│       ├── tester.md          ← Tests schreiben & ausführen (Mittel)
│       ├── reviewer.md        ← Code Review, Qualität, Security (Groß)
│       ├── committer.md       ← Git-Operationen, Commit Messages (Klein)
│       ├── council-generalist.md ← Gesamtbild, Machbarkeit (Groß)
│       ├── council-developer.md  ← Technische Umsetzung (Groß)
│       └── council-reviewer.md   ← Qualität, Security, Risiken (Groß)
├── hooks/                 ← Shell-Hooks (SessionStart, PreToolUse, PostToolUse)
│   ├── cc-session-start.sh   ← MEMORY.md laden, Provider & TODOs anzeigen
│   ├── cc-pre-bash.sh        ← Secrets-Scan vor git commit (blockierend)
│   ├── cc-post-bash.sh       ← Post-Bash-Logik
│   ├── git-pre-commit.sh     ← Git pre-commit Hook
│   ├── git-post-commit.sh    ← Git post-commit Hook
│   └── secrets-scan.sh       ← Pattern-Scan für API-Keys & Secrets
├── workspace/             ← Projekte (temporär, nie in Git)
├── skills/                ← SKILL.md Dateien (automatisch geladen bei Bedarf)
│   ├── git-workflow/      ← Git-Operationen
│   ├── docker/            ← Container-Änderungen
│   ├── planning/          ← Aufgaben zerlegen (Plan & Solve)
│   ├── testing/           ← Tests schreiben & ausführen
│   ├── debugging/         ← Fehler systematisch beheben
│   ├── code-style/        ← TypeScript & Python Konventionen
│   ├── frontend/          ← UI, CSS, React, Accessibility
│   ├── model-routing/     ← Modell- & Provider-Auswahl (Klein/Mittel/Groß)
│   └── council/           ← Council-Governance, Runden, HitL
└── knowledge/             ← Wissensbasis (bei Bedarf laden)
    ├── models.md          ← Modelle & Routing-Logik
    ├── git-workflow.md    ← Git-Konventionen
    ├── project-wizard.md  ← Neues Projekt anlegen
    └── docker.md          ← Container-Änderungen
```

## DEBUG_MODE

`DEBUG_MODE` wird aus `.env` geladen und von `entrypoint.sh` in MEMORY.md geschrieben.

**Falls `DEBUG_MODE: on` in MEMORY.md steht, MUSS nach jeder Antwort folgendes ausgegeben werden:**

```
[🔀 <agent oder skill>]  Provider: <provider> | Modell: <modell>
                         Dauer: ~<Xs> | Tool-Calls: <n> | Token: ~<n> (geschätzt)
```

- Bei einfachen Chat-Antworten ohne Tool-Calls: einzeilig am Ende der Antwort
  `[🔀 chat]  Provider: Anthropic | Modell: claude-sonnet-4-6 | Tool-Calls: 0`
- Bei mehreren Agents/Skills: je eine Zeile pro Agent
- Token-Schätzung: grob, auf 100 gerundet
- Dauer: seit Beginn der Antwort schätzen

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
