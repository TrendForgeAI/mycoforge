# SOLID Principles

**Kategorien:** design-principles | **Rollen:** developer, reviewer, architect | **Tier:** 3
**Referenz:** Robert C. Martin ("Uncle Bob") — *Agile Software Development* (2002)

## Core Concepts

| Prinzip | Bedeutung |
|---------|-----------|
| **S — Single Responsibility** | Jede Klasse hat genau eine Verantwortlichkeit / einen Grund sich zu ändern |
| **O — Open/Closed** | Offen für Erweiterung, geschlossen für Modifikation |
| **L — Liskov Substitution** | Unterklassen müssen für ihre Basisklassen einsetzbar sein |
| **I — Interface Segregation** | Clients sollen nicht von Interfaces abhängen die sie nicht nutzen |
| **D — Dependency Inversion** | Von Abstraktionen abhängen, nicht von konkreten Implementierungen |

## Wann einsetzen

- Design von wartbaren und skalierbaren OO-Systemen
- Refactoring von Legacy-Code zur Strukturverbesserung
- Code Reviews auf Design-Probleme prüfen
- Wenn Flexibilität und Testbarkeit wichtig sind

## Prompt Pattern

```
Prüfe diesen Code auf SOLID-Verletzungen:
[Code]

Fokus auf: [SRP / OCP / LSP / ISP / DIP]
```

## Verwandte Anchors

- GoF Design Patterns: `@knowledge/anchors/gof-design-patterns.md`
- Clean Architecture: `@knowledge/anchors/clean-architecture.md`
