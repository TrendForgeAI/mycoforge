# Swarm Skill

## Wann laden?
Wenn eine offene, komplexe Frage ohne klaren Lösungsweg exploriert werden soll —
besonders bei `/explore`. Nicht laden für klar definierte Aufgaben.

## Kontext

Der Swarm ist das teuerste Agent-Muster. Bewusst und selten einsetzen.

### Abgrenzung zu anderen Mustern

| Muster | Wann | Nicht wenn |
|--------|------|-----------|
| **Swarm** | Offene Exploration, kein klarer Lösungsweg, heterogene Expertise nötig | Aufgabe ist klar definiert |
| **Council** | Entscheidung zwischen Optionen, Code Review, Variantenvergleich | Keine klaren Bewertungsmaßstäbe |
| **Orchestrator** | Bekannte Aufgabe, zerlegbar in Subtasks | Problem ist zu offen |

**Faustregel:** Wenn du die Teilaufgaben vorher benennen kannst → Orchestrator.
Wenn du nicht weißt welche Fragen entstehen werden → Swarm.

## Governance-Regeln

### Iterations-Limit

```
Quelle:  --iterations N beim Aufruf  →  N wird als Limit verwendet
Fallback: SWARM_MAX_ITERATIONS aus .env  →  default 3
```

Das Limit ist eine **Leitplanke**, kein Ziel. Früher aufhören wenn Konvergenz erreicht.

### Ablauf pro Iteration

```
1. Coordinator wählt 2–4 Agents aus Pool
2. Agents explorieren ihre Teilfrage
3. Coordinator sammelt Erkenntnisse
4. Council-Swarm bewertet: WEITER | KONVERGIERT | CHECKPOINT
```

### Early Stop (Konvergenz)

Council-Swarm signalisiert KONVERGIERT wenn:
- Erkenntnisgewinn der letzten Iteration minimal war
- Widersprüche sich nicht mehr verändern
- Alle drei Council-Swarm-Perspektiven übereinstimmen

→ Coordinator erstellt sofort Abschlussbericht, weitere Iterationen entfallen.

### HitL-Checkpoint (Limit erreicht)

Wenn Iterations-Limit erreicht und keine Konvergenz:
1. Coordinator gibt Zusammenfassung des aktuellen Stands aus
2. Nutzer entscheidet: weitere Iterationen | abschließen | Fokus ändern
3. Bei "weitere Iterationen": neues Limit = aktuelles Limit (weitere N Runden)

## Agents im Swarm-Pool

| Agent | Stärke im Swarm |
|-------|----------------|
| Developer | Technische Machbarkeit, Implementierungsansätze |
| Backend | Systemarchitektur, Datenmodelle |
| Frontend | Nutzererfahrung, UI-Konzepte |
| Reviewer | Risiken, Gegenargumente, blinde Flecken |
| Planner | Strukturierung, Abhängigkeiten |

Coordinator wählt pro Iteration nur die relevanten — nicht alle gleichzeitig.

## Wann Swarm, wann nicht

- ✅ "Wie könnte eine selbst-verbessernde KI-Umgebung aussehen?"
- ✅ "Was sind mögliche Architekturen für ein verteiltes System?"
- ✅ "Welche Risiken hat dieser Ansatz — aus allen Perspektiven?"
- ❌ "Implementiere Feature X" → Orchestrator
- ❌ "Ist Ansatz A oder B besser?" → Council
- ❌ "Schreibe Tests für Modul Y" → direkt oder Tester-Agent
