# Five Whys

**Kategorien:** problem-solving | **Rollen:** developer, devops, team-lead | **Tier:** 2
*Five Whys Root Cause Analysis*
**Referenz:** Taiichi Ohno — Toyota Production System (1950er)

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Iterative Causal Analysis** | "Warum?" ~5x stellen bis zur Ursache |
| **Root Cause vs. Symptom** | Oberflächliche Symptome von tiefen Ursachen trennen |
| **Causal Chain** | Jede Antwort wird zum Subjekt der nächsten Warum-Frage |
| **Actionable Root Cause** | Fortfahren bis eine handlungsrelevante Ursache gefunden ist |
| **Avoid Blame** | Prozessversagen fokussieren, nicht individuelle Schuld |

## Wann einsetzen

- Incident Post-Mortems in Software/DevOps
- Debugging wenn oberflächliche Fixes nicht helfen
- Wiederkehrende Probleme verstehen
- Qualitätsdefekt-Analyse

## Beispiel

```
Problem: Website ist down
Warum? → Datenbankverbindung fehlgeschlagen
Warum? → Connection Pool erschöpft
Warum? → Langläufige Queries ohne Timeout
Warum? → Kein Query-Timeout konfiguriert
Warum? → Default-Konfiguration nie für Produktion geprüft

Root Cause: Kein Konfigurationsreview-Prozess für Production
Maßnahme: Pre-Production-Checkliste einführen
```
