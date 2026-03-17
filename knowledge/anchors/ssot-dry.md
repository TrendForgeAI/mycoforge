# SSOT / DRY

**Kategorien:** design-principles | **Rollen:** developer, architect | **Tier:** 1
*Single Source of Truth / Don't Repeat Yourself*
**Referenz:** Andy Hunt, Dave Thomas — *The Pragmatic Programmer* (1999)

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Single Source of Truth** | Jede Information hat genau eine kanonische Quelle |
| **Don't Repeat Yourself** | Jedes Stück Wissen hat eine einzige, eindeutige Repräsentation im System |
| **Authoritative Source** | Eine vertrauenswürdige Stelle — alle anderen sind abgeleitet |
| **Derived Data** | Andere Repräsentationen werden aus der Quelle generiert, nicht dupliziert |

## Wann einsetzen

- Wenn gleiche Logik an mehreren Stellen auftaucht (Zeichen für DRY-Verletzung)
- Datenbankdesign und Datenarchitektur
- Konfigurationsmanagement
- Dokumentation und Wissensverwaltung

## Wichtige Abgrenzung

DRY ≠ "keine zwei Zeilen dürfen gleich aussehen" — es geht um **Wissen**, nicht syntaktische Ähnlichkeit. Ähnlicher Code mit unterschiedlicher Semantik sollte **nicht** abstrahiert werden (YAGNI-Verletzung).
