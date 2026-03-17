# MADR (Markdown Architectural Decision Records)

**Kategorien:** software-architecture | **Rollen:** planner, architect, developer | **Tier:** 2
**Referenz:** https://adr.github.io/madr/

## Core Concepts

MADR ist eine strukturiertere Variante von Nygard-ADRs mit expliziten Optionen und Trade-off-Analyse.

| Abschnitt | Inhalt |
|-----------|--------|
| **Title** | Kurze, prägnante Entscheidungsbeschreibung |
| **Status** | proposed / accepted / deprecated / superseded |
| **Context and Problem Statement** | Warum muss diese Entscheidung getroffen werden? |
| **Decision Drivers** | Welche Faktoren leiten die Entscheidung? |
| **Considered Options** | Alle evaluierten Alternativen |
| **Decision Outcome** | Gewählte Option mit Begründung |
| **Pros and Cons of Options** | Explizite Trade-off-Analyse je Option |
| **Links** | Verwandte Entscheidungen |

## Abgrenzung zu Nygard-ADR

| | Nygard ADR | MADR |
|-|-----------|------|
| **Umfang** | Minimal (5 Abschnitte) | Detailliert (8+ Abschnitte) |
| **Optionen** | Implizit | Explizit mit Vor/Nachteilen |
| **Aufwand** | Gering | Mittel |
| **Wann** | Schnelle Entscheidungen | Wichtige, komplexe Entscheidungen |

## Wann einsetzen

- Wichtige Architekturentscheidungen mit mehreren ernsthaften Alternativen
- Wenn Stakeholder Trade-offs nachvollziehen müssen
- Als Standard in größeren Teams wo Dokumentationsqualität wichtig ist
