# C4 Model

**Kategorien:** software-architecture | **Rollen:** planner, architect, technical-writer | **Tier:** 3
**Referenz:** Simon Brown — *Software Architecture for Developers* (2018)

## Core Concepts — 4 Abstraktionsebenen

| Ebene | Frage | Zielgruppe |
|-------|-------|------------|
| **L1 — Context** | Was ist das System? Wer nutzt es? Externe Systeme? | Alle Stakeholder |
| **L2 — Container** | Welche deploybare Einheiten? Apps, DBs, APIs? | Technische Stakeholder |
| **L3 — Component** | Welche Komponenten innerhalb eines Containers? | Entwicklungsteam |
| **L4 — Code** | Klassen, Entities (optional) | Entwickler |

**Progressive Disclosure:** Zoom in je nach Bedarf und Zielgruppe.
**Einfache Notation:** Boxes und Pfeile — kein UML erforderlich.

## Wann einsetzen

- Architektur für diverse Stakeholder kommunizieren
- Onboarding neuer Teammitglieder
- Architektur-Dokumentation und Reviews
- Als Ergänzung oder Ersatz für UML
