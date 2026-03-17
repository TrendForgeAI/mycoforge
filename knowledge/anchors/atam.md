# ATAM (Architecture Tradeoff Analysis Method)

**Kategorien:** software-architecture | **Rollen:** reviewer, architect, team-lead | **Tier:** 3
**Referenz:** Rick Kazman, Mark Klein, Paul Clements — Carnegie Mellon SEI

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Utility Tree** | Hierarchische Struktur der Qualitätsziele: Business Goals → Quality Attributes → Scenarios |
| **Quality Attribute Scenarios** | Stimulus · Source · Environment · Artifact · Response · Response Measure |
| **Tradeoff Points** | Architekturentscheidungen die mehrere Qualitätsattribute gleichzeitig beeinflussen |
| **Sensitivity Points** | Entscheidungen die ein einzelnes Qualitätsattribut stark beeinflussen |
| **Risks** | Architekturentscheidungen die Qualitätsziele gefährden könnten |
| **Non-Risks** | Bewusste Entscheidungen die sicher sind |

## ATAM-Prozess (9 Schritte)

1. ATAM vorstellen
2. Business-Treiber vorstellen
3. Architektur vorstellen
4. Architektur-Ansätze identifizieren
5. Utility Tree erstellen
6. Architekturansätze analysieren
7. Szenarien brainstormen und priorisieren
8. Analyse erneut durchführen
9. Ergebnisse präsentieren

## Wann einsetzen

- Konkurrierende Stakeholder-Anforderungen (z.B. Performance vs. Sicherheit vs. Wartbarkeit)
- Safety-Critical Systems vor der Implementierung
- Große Architekturentscheidungen mit langfristigen Konsequenzen
