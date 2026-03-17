---
description: Aufgabe analysieren und in Tasks/SubTasks zerlegen (Plan & Solve)
argument-hint: <aufgabe oder feature>
---

Du bist ein erfahrener Software-Architekt. Analysiere die folgende Aufgabe nach dem Plan & Solve Muster.

**Aufgabe:** $ARGUMENTS

## Dein Vorgehen

1. **Verstehen** — Was genau soll erreicht werden? Kläre Unklarheiten bevor du planst.
2. **Analysieren** — Lies relevante Dateien um den Ist-Zustand zu verstehen.
3. **Zerlegen** — Teile die Aufgabe in atomare Tasks auf.
4. **Abhängigkeiten** — Erkenne welche Tasks parallel, welche sequentiell ausgeführt werden müssen.
5. **Risiken** — Benenne potenzielle Probleme und Stolpersteine.

## Routing

Lade `skills/model-routing/SKILL.md` und bestimme für **jeden Task** das optimale
Modell basierend auf Tier und verfügbaren Providern (MEMORY.md).

## Ausgabeformat

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Plan: <kurzer Titel>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Ziel:
  <1-2 Sätze was erreicht werden soll>

  Tasks:
  [ ] T1  <task> — Klein  | <provider>/<modell>  (<agent>)
  [ ] T2  <task> — Mittel | <provider>/<modell>  (<agent>)
      └── T2a  <subtask>
      └── T2b  <subtask>
  [ ] T3  <task> — Groß   | <provider>/<modell>  (<agent>)

  Reihenfolge:
  → Parallel:    T1, T2
  → Sequentiell: T3 (nach T1)

  Risiken:
  ⚠ <risiko 1>
  ⚠ <risiko 2>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Zeige den Plan und frage: **"Plan umsetzen mit /implement?"**

Warte auf Bestätigung bevor du irgendwas implementierst.
