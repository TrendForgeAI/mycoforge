# mycoforge Architecture

> **Zweck dieser Datei:** Erklärt das *Systemdenken* hinter mycoforge — Warum ist es so gebaut?
> Welche Patterns liegen zugrunde? Was ist bewusst offen?
>
> **Nicht hier:** Dateilisten, Pfade, Commands, Skills → siehe `CLAUDE.md`

---

## Vision

mycoforge ist eine selbst-verbessernde KI-Entwicklungsumgebung.
Ein Multi-Agent-System das Aufgaben intelligent zerlegt, parallelisiert, diskutiert
und mit dem jeweils optimalen Modell ausführt.

---

## Systemarchitektur

Vier Schichten von der Infrastruktur bis zur Nutzer-Interaktion:

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

**Designprinzip:** Jede Schicht kennt nur die Schicht darunter.
Layer 4 (Commands) ruft Layer 3 (Agents) auf — niemals umgekehrt.

---

## Agent-Grundmuster: ReAct

Jeder einzelne Agent arbeitet nach dem **ReAct-Muster** (Reason → Act → Observe):

```
Nutzeranfrage / Teilaufgabe
    ↓
Reasoning  → Agent denkt über Problem nach, entscheidet Handlungsschritt
    ↓
Acting     → Agent nutzt Werkzeuge (Bash, Edit, Read, gh, git, …)
    ↓
Observe    → Agent betrachtet Ergebnis, reichert Kontext an
    ↓
Aufgabe erledigt? → Nein → zurück zu Reasoning
                 → Ja  → Finale Antwort / Übergabe
```

---

## Muster 1: Orchestrator (Plan & Solve)

Für mittlere und große Entwicklungsaufgaben.

```
Nutzeranfrage
    ↓
Orchestrator (großes Modell)
    → erstellt Gesamtplan
    → analysiert Abhängigkeiten zwischen Tasks
    → entscheidet: parallel oder sequentiell
    ↓
Unabhängige Tasks → parallel an Subagenten
Abhängige Tasks   → sequentiell
    ↓
Reviewer prüft Ergebnisse (Two-Stage: Spec + Qualität)
    ↓
Committer → atomarer Commit
```

**Wann Orchestrator:**
- ✅ Klar definierte Aufgabe mit bekanntem Lösungsweg
- ✅ Mehrere Dateien oder Komponenten betroffen
- ❌ Offene Exploration ohne klare Richtung → Swarm

---

## Muster 2: Council (Mehr-Augen-Prinzip)

Für Entscheidungen, Reviews und Variantenvergleiche.

```
Nutzeranfrage / Architektur-Frage
    ↓
Council-Mitglieder (parallel, verschiedene Perspektiven)
    ├── Generalist  → Gesamtbild, Machbarkeit, Konsequenzen
    ├── Developer   → Technische Umsetzung, Aufwand
    └── Reviewer    → Qualität, Security, Risiken
    ↓
Konsens gefunden?
    Ja  → Entscheidung + Nächste Schritte
    Nein → HitL: Nutzer entscheidet
```

### Diskussions-Governance

| Parameter | Default | Beschreibung |
|-----------|---------|-------------|
| `discussion_rounds` | 3 | Maximale Ping-Pong-Runden |
| `min_rounds` | 1 | Mindestens diese Anzahl |
| `early_stop` | true | Stoppe bei Konsens vor Limit |

**Ablauf pro Runde:**
- Runde 1: Initiale Positionen, unabhängig voneinander
- Runde 2: Reaktion, Annäherung oder Widerspruch
- Runde 3: Finale Position, Konsens-Versuch
- Nach max Runden ohne Konsens → HitL

**Wann Council:**
- ✅ Architektur-Entscheidungen mit mehreren validen Optionen
- ✅ Code Reviews, Sicherheitsbewertungen
- ❌ Standardisierte Aufgaben mit klarem Lösungsweg → Orchestrator

---

## Muster 3: Swarm (Exploration)

Nur für offene, komplexe Probleme ohne klaren Lösungsweg.
Das teuerste Muster — bewusst und selten einsetzen.

```
Offene Frage / Architektur-Exploration
    ↓
Swarm-Coordinator (steuert Iteration)
    ├── wählt 2–4 Agents pro Iteration (gezielt, nicht alle)
    ├── sammelt Erkenntnisse, Offene Fragen, Widersprüche
    ↓
Council-Swarm (Governance nach jeder Iteration)
    ├── Erkenntnisgewinn substanziell?
    ├── Konvergiert der Swarm?
    └── Lohnt weitere Iteration? → WEITER | KONVERGIERT | CHECKPOINT
    ↓
WEITER        → nächste Iteration (sofern < Limit)
KONVERGIERT   → Abschlussbericht
CHECKPOINT    → HitL: Nutzer entscheidet ob weitere Iterationen
```

**Iterations-Governance:**
- Limit: konfigurierbar (default: 3), überschreibbar beim Aufruf
- Early Stop: Council-Swarm erkennt Konvergenz vor Limit
- HitL-Checkpoint: Bei Limit ohne Konvergenz → Zusammenfassung + Nutzer entscheidet

**Wann Swarm:**
- ✅ Hohe Problemoffenheit, keine klare Lösungsrichtung
- ✅ Heterogene Expertise nötig, gegenseitige Prüfung erforderlich
- ❌ Klar definierte Aufgaben → Orchestrator
- ❌ Entscheidung zwischen Optionen → Council

---

## Human-in-the-Loop (HitL)

HitL ist ein vollwertiges Muster, kein Übergangszustand.

**Phase 1 — Standard (aktiv):**
Orchestrator und Council legen Entscheidungen dem Nutzer vor.
Der Nutzer hat das finale Wort bei allen wichtigen Entscheidungen.
Ziel: Vertrauen aufbauen, System verstehen lernen.

**Phase 2 — Autonom (explizit aktivierbar):**
Orchestrator entscheidet autonom.
HitL nur bei kritischen oder unbekannten Situationen.
Aktivierung: bewusste Entscheidung des Nutzers.
Kann jederzeit zurück zu Phase 1.

---

## Offene Entscheidungen

### ADR-001: Ab wann wird Phase 2 (autonomer Orchestrator) aktiviert?

**Status:** Offen — bewusst zurückgestellt

**Kontext:**
Phase 2 übergibt Entscheidungsgewalt an den Orchestrator. Das erhöht Geschwindigkeit,
reduziert aber die Kontrollmöglichkeit des Nutzers. Vertrauen muss durch tatsächliche
Nutzung wachsen — es lässt sich nicht vorab definieren.

**Entscheidung:**
Explizite Nutzer-Entscheidung wenn das Systemverhalten durch ausreichend Nutzung
bekannt und vertrauenswürdig ist. Kein automatischer Übergang.

**Konsequenz:**
Bis zur Aktivierung läuft alles in Phase 1. Die Aktivierung erfordert eine bewusste
Konfigurationsänderung — kein impliziter Mechanismus.
