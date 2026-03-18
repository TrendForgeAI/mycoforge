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

## Namenskonventionen

| Bereich | Regel | Beispiel |
|---------|-------|---------|
| Dateinamen | Englisch, `lowercase-kebab-case` | `finish-branch.md`, `cc-pre-bash.sh` |
| Verzeichnisnamen | Englisch, `lowercase-kebab-case` | `skills/git-workflow/`, `claude/agents/` |
| Inhalte (Agent-Rollen, Skill-Trigger, Commands) | Deutsch | „Wenn ein Branch abgeschlossen wird…" |
| Inhalte (Code, technische Namen, knowledge/anchors) | Englisch | `SOLID`, `ReAct`, `kebab-case` |
| Skill-Dir-Name | = Command-Name wenn Pendant existiert | `finish-branch/` ↔ `/finish-branch` |
| Skill-Dir-Name | Konzept-Name wenn kein Command | `planning/`, `council/`, `model-routing/` |

**Warum Commands flache Dateien, Skills aber Verzeichnisse?**
Commands (`claude/commands/commit.md`) sind flache Dateien weil Claude Code das so erwartet —
der Dateiname wird direkt zum Command-Namen (`commit.md` → `/commit`).
Skills (`skills/code-style/SKILL.md`) sind Verzeichnisse weil ein Skill zukünftig mehrere
Dateien enthalten kann (Templates, Beispiele, Sub-Skripte). `SKILL.md` folgt der
`README.md`-Konvention: die primäre Datei im Verzeichnis ist großgeschrieben.

## Projektstruktur
```
mycoforge/
├── CLAUDE.md              ← Projektkontext (dieser File)
├── ARCHITECTURE.md        ← Systemdenken & Agent-Patterns (Explanation)
├── MEMORY.md              ← Systemgedächtnis (wird beim Start generiert, nicht in Git)
├── README.md              ← für Menschen
├── TODO.md                ← Arbeitsplan & offene Punkte
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
│   │   ├── commit.md      ← Intelligenter Commit
│   │   ├── discuss.md     ← Architektur-Entscheidung (Council, 2–5 Runden)
│   │   ├── explore.md     ← Offene Exploration (Swarm)
│   │   ├── finish-branch.md ← Branch abschließen (Tests, Merge/PR/Verwerfen)
│   │   ├── implement.md   ← Plan umsetzen (Orchestrator)
│   │   ├── new-project.md ← Interaktiver Projekt-Wizard
│   │   ├── pause.md       ← Session-Zustand sichern
│   │   ├── plan.md        ← Aufgabe analysieren (Plan & Solve)
│   │   ├── review.md      ← Code Review (Council, 3 Runden)
│   │   ├── route.md       ← Task klassifizieren & Modell wählen
│   │   ├── verify.md      ← Implementierung auf Funktionsfähigkeit prüfen
│   │   └── worktree.md    ← Git Worktree anlegen / auflisten / entfernen
│   └── agents/            ← Agent-Definitionen
│       ├── backend.md           ← API, Datenbank, Business Logic (Mittel)
│       ├── committer.md         ← Git-Operationen, Commit Messages (Klein)
│       ├── council-developer.md ← Council: Technische Umsetzung (Groß)
│       ├── council-generalist.md ← Council: Gesamtbild, Machbarkeit (Groß)
│       ├── council-reviewer.md  ← Council: Qualität, Security, Risiken (Groß)
│       ├── council-swarm.md     ← Swarm: Governance & Konvergenz-Erkennung (Groß)
│       ├── developer.md         ← Code schreiben, Features, Bugfixes (Mittel)
│       ├── frontend.md          ← UI, CSS, React, Accessibility (Mittel)
│       ├── planner.md           ← Aufgabe zerlegen, Abhängigkeiten (Groß)
│       ├── reviewer.md          ← Code Review, Qualität, Security (Groß)
│       ├── swarm-coordinator.md ← Swarm: Iteration steuern, Agents spawnen (Groß)
│       └── tester.md            ← Tests schreiben & ausführen (Mittel)
├── hooks/                 ← Shell-Hooks (SessionStart, PreToolUse, PostToolUse)
│   ├── cc-context-monitor.sh ← Kontext-Warnung bei hoher Auslastung
│   ├── cc-session-start.sh   ← MEMORY.md laden, Provider & TODOs anzeigen
│   ├── cc-pre-bash.sh        ← Secrets-Scan vor git commit (blockierend)
│   ├── cc-post-bash.sh       ← Post-Bash-Logik
│   ├── git-pre-commit.sh     ← Git pre-commit Hook
│   ├── git-post-commit.sh    ← Git post-commit Hook
│   └── secrets-scan.sh       ← Pattern-Scan für API-Keys & Secrets
├── workspace/             ← Projekte (temporär, nie in Git)
├── skills/                ← SKILL.md Dateien (automatisch geladen bei Bedarf)
│   ├── code-style/        ← TypeScript & Python Konventionen
│   ├── council/           ← Council-Governance, Runden, HitL
│   ├── debugging/         ← Fehler systematisch beheben
│   ├── docker/            ← Container-Änderungen
│   ├── finish-branch/     ← Branch abschließen
│   ├── frontend/          ← UI, CSS, React, Accessibility
│   ├── git-workflow/      ← Git-Operationen
│   ├── git-worktree/      ← Isolierte Feature-Entwicklung mit Worktrees
│   ├── model-routing/     ← Modell- & Provider-Auswahl (Klein/Mittel/Groß)
│   ├── pause/             ← Session-Zustand sichern
│   ├── planning/          ← Aufgaben zerlegen (Plan & Solve)
│   ├── swarm/             ← Swarm-Exploration, Iterations-Governance
│   ├── testing/           ← Tests schreiben & ausführen
│   └── verify/            ← Implementierung verifizieren
├── docs/                  ← Anwender-Dokumentation
│   ├── usage.md           ← Commands, Workflows, Beispiele
│   └── agent-guide.md     ← Wie schreibe ich einen neuen Agent?
└── knowledge/             ← Wissensbasis (bei Bedarf laden)
    ├── anchors/           ← Best-Practice-Anchors (60+, je eine Datei)
    ├── checkpoints.md     ← Checkpoint-Muster für lange Tasks
    ├── continuation-format.md ← Format für Session-Fortsetzungen
    ├── docker.md          ← Container-Änderungen
    ├── git-workflow.md    ← Git-Konventionen
    ├── models.md          ← Modelle & Routing-Logik
    ├── project-state.md   ← STATE.md Format & Kontext-Rot-Prevention
    ├── project-wizard.md  ← Neues Projekt anlegen
    ├── semantic-anchors.md ← mycoforge-Terminologie & Anchor-Index
    └── verification-patterns.md ← Verifikations-Patterns nach /implement
```

## DEBUG_MODE

`DEBUG_MODE` wird aus `.env` geladen und von `entrypoint.sh` in MEMORY.md geschrieben.

**Falls `DEBUG_MODE: on` in MEMORY.md steht, MUSS am Ende jeder Antwort folgendes ausgegeben werden:**

```
[🔀 <Agent>]  Provider: <provider> | Modell: <modell> | Runden: <n> | Tool-Calls: <n> | Dauer: ~<Xs> | Token: ~<n> (geschätzt)
```

Felder:
- **Agent**: Name des Skills/Agents (z.B. `review`, `commit`, `planner`) — bei normaler Chat-Antwort: `Chat`
- **Provider**: z.B. `Anthropic`, `OpenAI`, `Google`
- **Modell**: z.B. `claude-sonnet-4-6`
- **Runden**: Anzahl Council- oder Orchestrator-Runden — bei Chat: `1`
- **Tool-Calls**: Anzahl der ausgeführten Tool-Calls in dieser Antwort
- **Dauer**: geschätzte Zeit seit Beginn der Antwort in Sekunden
- **Token**: grobe Schätzung des Gesamtverbrauchs (Input + Output), auf 100 gerundet

Bei mehreren Agents (z.B. Council): je eine Zeile pro Agent.

## Arbeitsweise

- Jede Änderung wird verstanden bevor sie gemacht wird
- Atomic Commits nach jeder abgeschlossenen Aufgabe
- Keine Secrets in Git – immer .env.example statt .env
- Änderungen an mycoforge selbst werden sofort committed und gepusht
- Projekte entstehen in /workspace/ als geklonte GitHub Repos

## Modell-Routing

Verfügbare Provider stehen in MEMORY.md.
Kanonische Tier-Definitionen und Modellnamen: `config/model-routing.yaml` (Single Source of Truth).
Für Erklärungen: @knowledge/models.md laden.

Grundprinzip: Klein wenn möglich, Groß wenn nötig.

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
