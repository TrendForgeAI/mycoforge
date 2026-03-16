# mycoforge Architecture

## Vision

mycoforge ist eine selbst-verbessernde KI-Entwicklungsumgebung mit einem
Multi-Agent System das Aufgaben intelligent zerlegt, parallelisiert, diskutiert
und mit dem jeweils optimalen Modell ausführt.

---

## Schichten
```
┌─────────────────────────────────────────────────────────┐
│  LAYER 4: Commands & Hooks                              │
│  Slash Commands, automatische Trigger                   │
├─────────────────────────────────────────────────────────┤
│  LAYER 3: Multi-Agent System                            │
│  Router → Orchestrator / Council / Swarm                │
├─────────────────────────────────────────────────────────┤
│  LAYER 2: Model Router                                  │
│  Provider- und Modellauswahl pro Task                   │
├─────────────────────────────────────────────────────────┤
│  LAYER 1: Infrastruktur                                 │
│  Docker, Git, GitHub, MEMORY.md, Skills                 │
└─────────────────────────────────────────────────────────┘
```

---

## Agent-Grundmuster

Jeder einzelne Agent in mycoforge arbeitet nach dem **ReAct-Muster**:
```
Nutzeranfrage / Teilaufgabe
    ↓
Reasoning  → Agent "denkt" über Problem nach, entscheidet Handlungsschritt
    ↓
Acting     → Agent nutzt Werkzeuge (Bash, Edit, Read, gh, git, ...)
    ↓
Observe    → Agent betrachtet Ergebnis, reichert Kontext an
    ↓
Aufgabe erledigt? → Nein → zurück zu Reasoning
                 → Ja  → Finale Antwort / Übergabe an Orchestrator
```

---

## Layer 1: Infrastruktur

Bereits vorhanden:
- Docker Container mit Claude Code
- GitHub Integration (gh CLI, SSH)
- MEMORY.md (Systemgedächtnis, beim Start automatisch befüllt)
- knowledge/ (Skills bei Bedarf laden)
- workspace/ (Projekte als geklonte GitHub Repos)

Noch zu bauen:
- Persistente Task/Session Historie
- claude/agents/ (Agent-Definitionen)

---

## Layer 2: Model Router

### Prinzip
Der Router ist selbst ein Agent – aber mit dem **kleinstmöglichen Modell**.
Kein großes LLM nötig für eine Routing-Entscheidung.
Er wählt providerübergreifend: Anthropic, OpenAI, Google.

### Komplexitätsstufen

| Stufe | Beispiele | Modelle |
|-------|-----------|---------|
| Klein | Datei lesen, umbenennen, einfache Edits, Git-Operationen | claude-haiku-4-5, gpt-5.3-instant, gemini-3.1-flash-lite |
| Mittel | Funktion schreiben, Bug fixen, Tests schreiben | claude-sonnet-4-6, gpt-5.4, gemini-3-flash |
| Groß | Architektur, Planung, komplexe Analyse, Council | claude-opus-4-6, gpt-5.4-pro, gemini-3.1-pro |
| Routing | Entscheidung welches Modell | kleinstes verfügbares Modell |

### Provider-Stärken

| Provider | Stärke |
|----------|--------|
| Anthropic | Reasoning, Code-Qualität, lange Kontexte |
| OpenAI | Agentic Workflows, professionelle Dokumente, Coding |
| Google | Multimodal, günstig bei hohem Volumen |

### Verfügbare Provider
Werden beim Container-Start aus .env erkannt und in MEMORY.md geschrieben.
Router wählt nur aus verfügbaren Providern.

---

## Layer 3: Multi-Agent System

### Routing-Entscheidung
```
Nutzeranfrage
    ↓
Router (kleinstes Modell)
    ├── Einfache Task         → direkt an passenden Subagenten
    ├── Mittlere/große Task   → Orchestrator (Plan & Solve)
    ├── Entscheidung/Review   → Council (Mehr-Augen-Prinzip)
    └── Offene Exploration    → Swarm (selten, bewusst, teuer)
```

---

### Muster 1: Orchestrator (Plan & Solve)

Für mittlere und große Entwicklungsaufgaben.
```
Nutzeranfrage
    ↓
Orchestrator (großes Modell)
    → erstellt Gesamtplan (Plan & Solve)
    → analysiert Abhängigkeiten zwischen Tasks
    → entscheidet: parallel oder sequentiell
    ↓
Unabhängige Tasks → parallel an Subagenten
Abhängige Tasks   → sequentiell
    ↓
Reviewer prüft alle Ergebnisse
    ↓
Committer → atomarer Commit
    ↓
Finale Antwort an Nutzer
```

**Subagenten:**

| Agent | Spezialisierung | Modell-Tier |
|-------|----------------|-------------|
| Planner | Aufgabe zerlegen, Abhängigkeiten erkennen | Groß |
| Developer | Code schreiben, implementieren (ReAct) | Mittel |
| Frontend | UI, CSS, UX, Accessibility (ReAct) | Mittel |
| Backend | API, Datenbank, Business Logic (ReAct) | Mittel |
| Tester | Tests schreiben und ausführen (ReAct) | Mittel |
| Reviewer | Code Review, Qualität, Security | Groß |
| Committer | Git-Operationen, Commit Messages | Klein |

---

### Muster 2: Council (Mehr-Augen-Prinzip)

Für Entscheidungen mit klaren Bewertungsmaßstäben:
Code Reviews, Architektur-Entscheidungen, Variantenvergleiche.
```
Nutzeranfrage / Architektur-Frage
    ↓
Council-Mitglieder (parallel, verschiedene Perspektiven)
    ├── Generalist  → Gesamtbild, Machbarkeit
    ├── Developer   → Technische Umsetzung
    └── Reviewer    → Qualität, Security, Risiken
    ↓
Konsens gefunden?
    Ja  → weiter
    Nein → HitL: Nutzer entscheidet (Phase 1)
           Orchestrator entscheidet (Phase 2, wenn aktiviert)
    ↓
Finale Entscheidung
```

### Diskussions-Governance (Ping-Pong)

Jede Agent-Diskussion hat ein konfigurierbares Runden-Limit um endlose Debatten zu verhindern.

| Parameter | Default | Beschreibung |
|-----------|---------|-------------|
| `discussion_rounds` | 3 | Maximale Ping-Pong-Runden zwischen Agents |
| `min_rounds` | 1 | Mindestens diese Anzahl Runden |
| `early_stop` | true | Stoppe früher wenn Konsens erreicht |

**Ablauf pro Runde:**
```
Runde 1: Jedes Council-Mitglied gibt initiale Position
Runde 2: Reaktion auf andere Positionen, Annäherung
Runde 3: Finale Position, Konsens-Versuch
    ↓
Konsens? → weiter
Kein Konsens nach max Runden? → HitL
```

**Konfiguration pro Command:**
- `/review` → 3 Runden (Default)
- `/discuss` → 2-5 Runden (Nutzer wählbar)
- Council im Orchestrator → 2 Runden (Effizienz)
- Swarm → eigene Iterations-Governance (Max-Iterations)

**Wann Council, wann nicht:**
- ✅ Architektur-Entscheidungen, Code Reviews, Variantenvergleiche
- ❌ Standardisierte Aufgaben, einfache Pipelines → Orchestrator effizienter

---

### Muster 3: Swarm (Exploration)

Nur für offene, komplexe Probleme ohne klaren Lösungsweg.
Das teuerste Muster – bewusst und selten einsetzen.
```
Offene Frage / Architektur-Exploration
    ↓
Initialer Agent (zufällig gewählt)
    ↓
Schwarm (alle gleichberechtigt, dezentral)
    ├── Agent spawnt nur bei Bedarf
    ├── Frühes Stoppen bei Konvergenz
    └── Budget/Zeit-Governance: Max-Tokens, Max-Iterations
    ↓
Finale Antwort vom letzten aktiven Agent
```

**Wann Swarm:**
- ✅ Hohe Problemoffenheit, keine klare Lösungsrichtung
- ✅ Heterogene Expertise nötig, gegenseitige Prüfung
- ❌ Klar definierte Aufgaben → Orchestrator
- ❌ Hoher Durchsatz, Kostendruck → Router

---

### Human-in-the-Loop (HitL)

HitL ist ein vollwertiges Muster, kein Übergangszustand.

**Phase 1 (jetzt – Standard):**
- Orchestrator und Council legen Entscheidungen dem Nutzer vor
- Nutzer hat finales Wort bei allen wichtigen Entscheidungen
- Ziel: Vertrauen aufbauen, System verstehen lernen

**Phase 2 (später – explizit aktiviert):**
- Orchestrator entscheidet autonom
- HitL nur bei kritischen/unbekannten Situationen
- Aktivierung: bewusste Entscheidung des Nutzers
- Kann jederzeit zurück zu Phase 1

---

## Layer 4: Commands & Hooks

### Slash Commands

#### Projekt-Management
| Command | Muster | Beschreibung |
|---------|--------|-------------|
| `/new-project` | HitL + Plan&Solve | Interaktiver Wizard + automatische Ausführung |
| `/project-status` | ReAct | Aktuellen Stand zusammenfassen |
| `/project-list` | Klein | Alle aktiven Projekte aus MEMORY.md |

#### Entwicklung
| Command | Muster | Beschreibung |
|---------|--------|-------------|
| `/plan` | Plan&Solve | Aufgabe analysieren, Tasks/SubTasks definieren |
| `/implement` | Orchestrator | Plan umsetzen mit Subagenten |
| `/review` | Council | Code Review aus mehreren Perspektiven |
| `/discuss` | Council | Zwei Ansätze diskutieren, Konsens finden |
| `/commit` | ReAct (Klein) | Intelligenter Commit mit Message-Vorschlag |

#### mycoforge
| Command | Muster | Beschreibung |
|---------|--------|-------------|
| `/update-mycoforge` | Plan&Solve | mycoforge aktualisieren |
| `/add-skill` | HitL + ReAct | Neuen Skill hinzufügen |
| `/status` | Klein | Systemstatus (Provider, Modelle, Projekte) |

### Hooks

#### Session Start
- MEMORY.md laden und Kontext herstellen
- Verfügbare Provider prüfen und anzeigen
- Offene TODOs anzeigen

#### Pre-Commit
- Prüfen ob .env versehentlich gestaged wurde
- Secrets-Scan
- Tests laufen lassen falls vorhanden

#### Post-Commit
- MEMORY.md auf Aktualität prüfen
- Commit in Projekt-Historie eintragen

---

## Skills Struktur

Skills sind SKILL.md-Dateien die Claude bei bestimmten Aufgaben automatisch lädt.
Inspiriert von Superpowers (obra/superpowers).

### Verzeichnisstruktur
```
skills/
├── git-workflow/
│   └── SKILL.md
├── code-style/
│   └── SKILL.md
├── planning/
│   └── SKILL.md
├── testing/
│   └── SKILL.md
├── debugging/
│   └── SKILL.md
├── docker/
│   └── SKILL.md
└── frontend/
    └── SKILL.md
```

### Aufbau einer SKILL.md
```markdown
# Skill-Name

## Wann laden?
[Trigger-Bedingung]

## Kontext
[Was dieser Skill weiß]

## Vorgehen
[Schritt-für-Schritt Anleitung]

## Beispiele
[Konkrete Beispiele]
```

### Trigger-Tabelle

| Trigger | Skill |
|---------|-------|
| Git-Operation | git-workflow |
| Code schreiben | code-style |
| Neue Aufgabe | planning |
| Tests schreiben | testing |
| Fehler debuggen | debugging |
| Container ändern | docker |
| UI/CSS entwickeln | frontend |

---

## Implementierungs-Reihenfolge

### Meilenstein 1: Commands formalisieren ✅
1. `/new-project` als echten Slash Command (project-wizard.md bereits vorhanden)
2. `/plan` und `/implement`
3. `/review` (Council-Muster)
4. `/commit`

### Meilenstein 2: Skills aufbauen ✅
1. Bestehende knowledge/ Dateien in SKILL.md Format überführt (git-workflow, docker)
2. Neue Skills angelegt: planning, testing, debugging, code-style, frontend

### Meilenstein 3: Model Router ✅
1. Router-Agent mit kleinstem Modell (`/route` Slash Command)
2. Komplexitätsstufen Klein/Mittel/Groß definiert
3. Provider-übergreifendes Routing (Anthropic, OpenAI, Google)
4. Skill `skills/model-routing/SKILL.md` für internen Einsatz in anderen Commands

### Meilenstein 4: Orchestrator ✅
1. Plan & Solve implementieren
2. Planner + Committer (einfachste Agents)
3. Developer + Tester
4. Frontend + Backend Agents
5. Reviewer

### Meilenstein 5: Council ✅
1. Council-Agents: council-generalist, council-developer, council-reviewer
2. `/discuss` Command für Architektur-Entscheidungen und Variantenvergleiche
3. `/review` Command mit Runden-Governance (3 Runden, Early Stop)
4. HitL Integration: Kein Konsens nach max Runden → Nutzer entscheidet
5. `skills/council/SKILL.md` für internen Einsatz in anderen Commands

### Meilenstein 6: Hooks
1. Pre-Commit Secrets-Scan
2. Session-Start Kontext
3. Post-Commit MEMORY.md Update

### Meilenstein 7: Swarm (optional, später)
1. Nur wenn Meilensteine 1-6 stabil
2. Budget/Zeit-Governance zuerst
3. Bewusst selten einsetzen

---

## Offene Entscheidungen

- [ ] Wie wird der Orchestrator technisch implementiert?
      → Claude Code Agent SDK / claude/agents/ Definitionen
- [ ] Wie werden parallele Tasks koordiniert?
      → Claude Code Agent Teams (experimentell) / eigene Lösung
- [ ] Wie wird Council-Debatte transparent dargestellt?
      → Ausgabe aller Agent-Antworten vor Konsens-Entscheidung
- [ ] Ab wann wird Phase 2 (autonomer Orchestrator) aktiviert?
      → Explizite Nutzer-Entscheidung, nicht automatisch
- [ ] Swarm Budget-Governance: Wer setzt Max-Tokens/Iterations?
      → Nutzer definiert Budget pro Swarm-Aufruf
