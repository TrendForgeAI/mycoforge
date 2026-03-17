# TDD, Chicago School

**Kategorien:** testing-quality | **Rollen:** tester, developer | **Tier:** 3
*Auch bekannt als: Classicist TDD, Detroit School*
**Referenz:** Kent Beck — *Test-Driven Development: By Example* (2002), Martin Fowler

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **State-based Testing** | Zustand von Objekten nach Operationen verifizieren |
| **Minimal Mocking** | Echte Objekte bevorzugen; nur externe Dependencies mocken |
| **Inside-Out Development** | Beginne mit Kernlogik, baue nach außen |
| **Red-Green-Refactor** | Der fundamentale TDD-Zyklus |
| **YAGNI** | Keine vorzeitigen Abstraktionen — nur was jetzt gebraucht wird |
| **Emergent Design** | Design entsteht durch Refactoring, nicht durch Vorabplanung |

## Wann einsetzen

- Domain-driven Design Projekte mit zentraler Business-Logik
- Kleinere, kohäsive Module
- Integration Tests mit realen Dependencies
- Wenn Zustandsbasiertes Testen natürlicher ist als Interaktions-Verifikation

## Abgrenzung

Chicago School = State-based, Minimal Mocks, Inside-Out
London School = Interaction-based, Mock-heavy, Outside-In → `@knowledge/anchors/tdd-london-school.md`
