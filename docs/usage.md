# mycoforge — Anwender-Dokumentation

Wie du mycoforge im Alltag nutzt: Commands, Workflows, Beispiele.

---

## Schnellstart

```bash
./start.sh          # Session starten (Terminal 1)
./shell.sh          # Shell in Container (Terminal 2, optional)
./update.sh         # mycoforge aktualisieren
```

Beim Start siehst du automatisch:
- Verfügbare AI Provider (aus `.env`)
- Offene TODOs aus `TODO.md`
- Aktive Projekte aus `/workspace/`

---

## Commands

### `/plan` — Aufgabe analysieren

Zerlegt eine Aufgabe in Tasks, erkennt Abhängigkeiten, schätzt Komplexität.

```
/plan füge User-Authentifizierung zur API hinzu
```

Ausgabe: strukturierter Plan mit Tasks, Parallelisierungshinweisen, Risiken.
Danach: `/implement` um den Plan auszuführen.

---

### `/implement` — Plan ausführen

Setzt einen Plan mit spezialisierten Sub-Agenten um. Der Orchestrator koordiniert,
parallelisiert unabhängige Tasks und reviewt jedes Ergebnis automatisch.

```
/implement füge einen CSV-Export zum Dashboard hinzu
```

Kein vorheriger `/plan` nötig — `/implement` erstellt bei Bedarf selbst einen Plan.

---

### `/review` — Code Review

Drei Perspektiven (Generalist, Developer, Reviewer) analysieren den Code in bis zu
3 Runden und suchen Konsens. Prüft Qualität, Security und Architektur.

```
/review
/review src/auth/middleware.ts
```

Ohne Argument: reviewt die zuletzt geänderten Dateien (`git diff HEAD~1`).

---

### `/discuss` — Entscheidung treffen

Council-Diskussion zwischen zwei Ansätzen oder zu einer offenen Frage.
2–5 Runden, Early Stop bei Konsens, HitL wenn kein Konsens.

```
/discuss sollen wir JWT oder Session-basierte Auth verwenden?
/discuss 3   (explizit 3 Runden)
```

---

### `/explore` — Offene Exploration

Swarm-Muster für komplexe Fragen ohne klaren Lösungsweg.
Mehrere Agents pro Iteration, Council-Governance nach jeder Runde.

```
/explore wie könnte eine Echtzeit-Kollaborationsfunktion aussehen?
/explore --iterations 5
```

Standard: 3 Iterationen (konfigurierbar via `SWARM_MAX_ITERATIONS` in `.env`).

---

### `/verify` — Implementierung prüfen

Prüft ob eine Implementierung tatsächlich funktioniert — nicht nur ob sie syntaktisch
korrekt ist. Läuft Tests, prüft Wiring, erkennt Stubs.

```
/verify die neue Authentifizierung
```

Empfohlen nach jedem `/implement`.

---

### `/finish-branch` — Branch abschließen

Führt durch den kompletten Branch-Abschluss: Tests prüfen, Code reviewen,
dann wählen: Merge in main, PR erstellen, behalten oder verwerfen.

```
/finish-branch
```

---

### `/worktree` — Isolierte Entwicklung

Git Worktrees für parallele Feature-Entwicklung ohne den main-Branch zu riskieren.

```
/worktree add feature/new-auth     # Neuen Worktree anlegen
/worktree list                     # Alle Worktrees anzeigen
/worktree remove feature/new-auth  # Worktree entfernen
```

---

### `/new-project` — Projekt anlegen

Interaktiver Wizard: stellt alle Pflichtfragen, legt GitHub-Repo an, klont es
nach `/workspace/`, erstellt CLAUDE.md, README.md, .gitignore, CI/CD.

```
/new-project
```

---

### `/commit` — Intelligenter Commit

Analysiert staged Changes, schlägt eine Conventional-Commits-Message vor,
erstellt den Commit nach Bestätigung.

```
/commit
/commit fix the broken auth middleware
```

---

### `/route` — Modell wählen

Klassifiziert einen Task und empfiehlt Provider + Modell nach Komplexität und
verfügbaren Providern.

```
/route schreibe einen Migrations-Skript für die Datenbank
```

---

### `/pause` — Session sichern

Schreibt `CONTINUE-HERE.md` mit aktuellem Stand und nächster Aktion,
erstellt einen WIP-Commit. Beim nächsten Start wird die Datei automatisch angezeigt.

```
/pause
```

---

## Typische Workflows

### Neues Feature entwickeln

```
1. /plan <feature beschreiben>
2. Plan prüfen, ggf. anpassen
3. /implement
4. /verify
5. /finish-branch
```

### Architektur-Entscheidung

```
1. /discuss <frage oder zwei Optionen>
2. Konsens oder HitL-Entscheidung
3. /implement <entschiedene Option>
```

### Code Review vor Merge

```
1. /review
2. Findings prüfen
3. Kritische Findings beheben
4. /commit
```

### Unklares Problem explorieren

```
1. /explore <offene Frage>
2. Nach jeder Iteration: weiter oder abbrechen
3. Ergebnis verwenden für /plan oder /discuss
```

### Parallele Feature-Entwicklung

```
1. /worktree add feature/my-feature
2. In neuem Worktree arbeiten (separate Terminal-Session)
3. /finish-branch wenn fertig
4. /worktree remove feature/my-feature
```

---

## Modell-Routing

mycoforge wählt automatisch das passende Modell für jeden Task:

| Tier | Aufgaben | Beispiele |
|------|---------|---------|
| **Groß** | Planung, Architektur, Council | Planner, Council-Agents, Reviewer |
| **Mittel** | Code schreiben, implementieren | Developer, Frontend, Backend, Tester |
| **Klein** | Dateioperationen, Git, Routing | Committer, Route-Entscheidung |

Verfügbare Provider werden beim Start aus `.env` geladen (Anthropic, OpenAI, Google).
Details: `knowledge/models.md`.

---

## DEBUG_MODE

In `.env` setzen um detaillierte Agent/Provider/Modell-Info zu sehen:

```bash
DEBUG_MODE=on
```

Nach jedem Task-Abschluss erscheint dann:
```
[🔀 implement]  Provider: Anthropic | Modell: claude-sonnet-4-6 | Runden: 1 | Tool-Calls: 12 | Dauer: ~30s | Token: ~4200
```

---

## Projekte

Alle Projekte entstehen in `/workspace/` als geklonte GitHub-Repos.

```
/workspace/
├── my-api/          ← GitHub: TrendForgeAI/my-api
├── my-dashboard/    ← GitHub: TrendForgeAI/my-dashboard
└── ...
```

Jedes Projekt bekommt eine eigene `CLAUDE.md` — der Kontext für Claude Code
als Entwickler dieses Projekts.

---

## mycoforge verbessern

mycoforge selbst ist ein Projekt wie jedes andere. Verbesserungen werden direkt
im Container entwickelt und über `update.sh` deployed:

```bash
# Auf dem Host:
cd /docker/mycoforge
git pull
# ... Änderungen machen, committen, pushen ...
./update.sh
```

Offene Punkte stehen in `TODO.md`. Architekturentscheidungen in `ARCHITECTURE.md`.
