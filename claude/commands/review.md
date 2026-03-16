---
description: Code Review aus drei Perspektiven (Council-Muster, 3 Runden)
argument-hint: [datei, PR-nummer oder beschreibung]
---

Du führst ein strukturiertes Code Review nach dem **Council-Muster** durch.
Drei Perspektiven beleuchten den Code nacheinander, dann wird ein Konsens gebildet.

**Review-Gegenstand:** $ARGUMENTS

Falls kein Argument angegeben: reviewe die aktuell geänderten Dateien (`git diff --staged` oder `git diff HEAD~1`).

---

## Schritt 1 — Code lesen

Lies alle relevanten Dateien. Verstehe was geändert wurde und warum.

---

## Schritt 2 — Drei Perspektiven (je 3 Runden max.)

Analysiere den Code aus drei Blickwinkeln. Gib für jede Perspektive eine klare Einschätzung:

### Perspektive 1: Generalist
*Gesamtbild, Machbarkeit, Verständlichkeit*
- Ist der Code verständlich und gut strukturiert?
- Löst er das Problem auf direktem Weg?
- Gibt es unnötige Komplexität?

### Perspektive 2: Developer
*Technische Umsetzung, Qualität*
- Ist die Implementierung korrekt?
- Edge Cases abgedeckt?
- Performance-Probleme?
- Code-Stil konsistent?

### Perspektive 3: Reviewer
*Qualität, Security, Risiken*
- Security-Probleme (Injection, Auth, Secrets)?
- Fehlerbehandlung ausreichend?
- Tests vorhanden / nötig?
- Deployment-Risiken?

---

## Schritt 3 — Konsens

Fasse die drei Perspektiven zusammen:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Code Review: <titel>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Urteil: ✅ Approved | ⚠ Approved mit Anmerkungen | ❌ Changes requested

  Muss-Änderungen (Blocker):
  ❌ <issue 1>
  ❌ <issue 2>

  Soll-Änderungen (wichtig, aber kein Blocker):
  ⚠ <issue>

  Kann-Änderungen (nice-to-have):
  💡 <suggestion>

  Positives:
  ✓ <was gut ist>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Bei **Blocker**: Erkläre konkret was geändert werden muss.
Bei **Approved**: Schlage `/commit` vor.
