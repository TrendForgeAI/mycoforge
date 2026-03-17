# YAGNI

**Kategorien:** design-principles | **Rollen:** developer, architect | **Tier:** 1
*You Aren't Gonna Need It*
**Referenz:** Ron Jeffries, Kent Beck — *Extreme Programming Explained* (1999)

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Don't build for hypothetical futures** | Nur implementieren was jetzt gebraucht wird |
| **Speculative Generality** | Anti-Pattern: Abstraktionen für imaginierte Anforderungen bauen |
| **Incremental Design** | Design entsteht durch echte Anforderungen, nicht Vorabplanung |
| **Cost of Carry** | Ungenutzter Code erhöht Komplexität und Wartungsaufwand |
| **Reversibility** | Einfache, änderbare Entscheidungen statt vorzeitiger Komplexität |

## Wann einsetzen

- Gegen Over-Engineering und vorzeitige Abstraktion
- Agile Projekte mit iterativer Lieferung
- Wenn die Versuchung besteht "für alle Fälle" Konfigurierbarkeit einzubauen
- Refactoring von Legacy-Code mit ungenutzten Features
