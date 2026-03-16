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

## Ausgabeformat

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Plan: <kurzer Titel>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Ziel:
  <1-2 Sätze was erreicht werden soll>

  Tasks:
  [ ] T1  <task> — <modell-tier: Klein/Mittel/Groß>
  [ ] T2  <task> — <modell-tier>
      └── T2a  <subtask>
      └── T2b  <subtask>
  [ ] T3  <task> — <modell-tier>

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
