# Council Skill

## Wann laden?
Wenn eine Entscheidung, ein Code Review oder ein Architekturvergleich durch mehrere
Perspektiven bewertet werden soll — besonders bei `/review` und `/discuss`.

## Kontext

Das Council-Muster bringt drei Perspektiven zusammen:

| Rolle | Fokus | Agent |
|-------|-------|-------|
| Generalist | Gesamtbild, Machbarkeit, langfristige Konsequenzen | `claude/agents/council-generalist.md` |
| Developer | Technische Umsetzung, Implementierungsaufwand | `claude/agents/council-developer.md` |
| Reviewer | Qualität, Security, Risiken | `claude/agents/council-reviewer.md` |

## Vorgehen

### Runden-Governance

| Kontext | Runden | Early Stop |
|---------|--------|-----------|
| `/review` | 3 | ja |
| `/discuss` | 2–5 (Nutzer wählbar) | ja |
| Council im Orchestrator | 2 | ja |

**Early Stop:** Wenn alle drei Mitglieder in einer Runde "Konsens-Signal: möglich" geben,
wird die Diskussion vorzeitig beendet.

### Ablauf pro Runde

```
Runde 1: Alle drei Mitglieder geben initiale Position (unabhängig voneinander)
Runde 2: Reaktion auf andere Positionen, Annäherung
Runde N: Finale Position, Konsens-Versuch
```

**Ausgabe-Reihenfolge in jeder Runde:**
1. [Generalist] Position
2. [Developer] Position
3. [Reviewer] Position
→ Dann: Konsens-Auswertung

### Konsens-Auswertung

Nach jeder Runde:
```
Alle drei "möglich"?       → Konsens erreicht → Weiter
Mindestens einer "kein Konsens" + letzte Runde? → HitL
Nicht letzte Runde?        → Nächste Runde starten
```

## Konsens-Zusammenfassung (bei Einigkeit)

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Council-Entscheidung: <thema>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Konsens nach Runde <N>: ✅ | ⚠ | ❌

  Begründung:
  <1-3 Sätze — warum diese Entscheidung>

  Auflagen / Bedingungen (bei ⚠):
  - <bedingung>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## HitL — Kein Konsens nach max Runden

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Kein Konsens — Nutzer entscheidet
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Dissens-Punkt: <worum geht es>

  Position A — <generalist/developer/reviewer>:
  <zusammenfassung>

  Position B — <andere mitglieder>:
  <zusammenfassung>

  Was ist deine Entscheidung?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Wann Council, wann nicht

- ✅ Architektur-Entscheidungen (zwei Ansätze vergleichen)
- ✅ Code Reviews (besonders bei komplexem oder risikoreichem Code)
- ✅ Variantenvergleiche (A vs. B)
- ❌ Standardisierte Aufgaben → Orchestrator effizienter
- ❌ Einfache Implementierungen → direkt umsetzen
