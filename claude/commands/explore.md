---
description: Offene Exploration mit Swarm-Pattern und Council-Governance (Iterations-Limit konfigurierbar)
argument-hint: "<frage> [--iterations N]"
---

Du führst eine strukturierte **Swarm-Exploration** durch.
Mehrere Agents erkunden eine offene Frage iterativ. Der Council-Swarm steuert Konvergenz und Budget.

**Explorations-Frage:** $ARGUMENTS

---

## Schritt 1 — Vorbereitung

### Iterations-Limit bestimmen

Prüfe ob `--iterations N` im Argument übergeben wurde:
- `--iterations N` vorhanden → verwende N als Limit
- nicht vorhanden → lese `SWARM_MAX_ITERATIONS` aus `.env` (default: 3)

Extrahiere die eigentliche Frage (ohne `--iterations` Flag).

### Ausgabe zu Beginn

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Swarm-Exploration
  Frage: <frage>
  Iterations-Limit: <N>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### HitL-Bestätigung

Zeige Budget-Hinweis und frage vor Start:

```
⚠ Swarm ist das teuerste Agent-Muster.
  Jede Iteration spawnt 2–4 Agents.
  Maximal <N> Iterationen — bei Konvergenz früher Stop möglich.

Exploration starten?
```

Warte auf Bestätigung. Erst dann starten.

---

## Schritt 2 — Lade Swarm-Infrastruktur

Lade:
- `claude/agents/swarm-coordinator.md`
- `claude/agents/council-swarm.md`
- `skills/swarm/SKILL.md`

---

## Schritt 3 — Iterations-Schleife

Führe folgende Schleife durch bis KONVERGIERT, CHECKPOINT oder Limit erreicht:

### Pro Iteration

**A) Coordinator aktivieren**

Übergib an `swarm-coordinator.md`:
```
Frage: <explorations-frage>
Iterations-Limit: <N>
Iteration: <aktuelle nummer>
Bisherige Erkenntnisse: <zusammenfassung — leer in Iteration 1>
```

Coordinator wählt Agents, spawnt sie, sammelt Erkenntnisse.

Zeige Fortschritt:
```
── Iteration <N>/<Limit> ──────────────────────
  Agents: <liste der eingesetzten agents>
  Neue Erkenntnisse: <kurze zusammenfassung>
```

**B) Council-Swarm befragen**

Übergib an `council-swarm.md`:
```
Frage: <explorations-frage>
Iteration: <N> von <Limit>
Neue Erkenntnisse: <zusammenfassung>
Offene Fragen: <liste>
Widersprüche: <liste>
```

Zeige Council-Swarm Output vollständig.

**C) Entscheid auswerten**

```
KONVERGIERT  → Schritt 4 (Abschlussbericht)
WEITER       → nächste Iteration (sofern < Limit)
CHECKPOINT   → Schritt 5 (HitL-Checkpoint)
Limit + kein KONVERGIERT → Schritt 5 (HitL-Checkpoint)
```

---

## Schritt 4 — Abschlussbericht (bei Konvergenz)

Coordinator erstellt Abschlussbericht (Format in `swarm-coordinator.md`).

Gib aus:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Swarm konvergiert nach Iteration <N>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
<abschlussbericht>
```

---

## Schritt 5 — HitL-Checkpoint (bei Limit)

Coordinator gibt HitL-Checkpoint aus (Format in `swarm-coordinator.md`):

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Swarm-Checkpoint — Iteration <N>/<N>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  <stand der exploration>
  ...
  Wie weiter?
  → A) Weitere <N> Iterationen durchführen
  → B) Exploration mit aktuellem Stand abschließen
  → C) Fokus ändern — neue Richtung: ___
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Warte auf Nutzer-Entscheidung:

- **A) Weitere Iterationen** → setze Limit auf aktuelles Limit, starte Schleife erneut ab Iteration 1 (mit bisherigen Erkenntnissen als Kontext)
- **B) Abschließen** → erstelle Abschlussbericht mit aktuellem Stand
- **C) Fokus ändern** → lese neue Richtung, starte Schleife neu mit angepasster Frage

---

## Schritt 6 — DEBUG_MODE

Falls `DEBUG_MODE: on` in MEMORY.md, nach jeder Iteration ausgeben:

```
[🔀 swarm-coordinator]  Tier: Mittel | Provider: <provider> | Modell: <modell>
                        Iteration: <N>/<Limit> | Agents eingesetzt: <n> | Token: ~<n> (geschätzt)
[🔀 council-swarm]      Tier: Mittel | Provider: <provider> | Modell: <modell>
                        Entscheid: <WEITER|KONVERGIERT|CHECKPOINT> | Token: ~<n> (geschätzt)
```
