# GoF Design Patterns

**Kategorien:** design-principles | **Rollen:** developer, architect | **Tier:** 3
*Gang of Four Design Patterns*
**Referenz:** Gamma, Helm, Johnson, Vlissides — *Design Patterns: Elements of Reusable Object-Oriented Software* (1994)

## Core Concepts

| Kategorie | Muster |
|-----------|--------|
| **Creational** | Abstract Factory, Builder, Factory Method, Prototype, Singleton |
| **Structural** | Adapter, Bridge, Composite, Decorator, Facade, Flyweight, Proxy |
| **Behavioral** | Chain of Responsibility, Command, Iterator, Mediator, Memento, Observer, State, Strategy, Template Method, Visitor |

**Pattern Language:** Gemeinsames Vokabular für wiederkehrende Design-Probleme und bewährte Lösungen.

**Composition over Inheritance:** Objekt-Komposition bevorzugen gegenüber starren Klassenhierarchien.

**Program to an Interface:** Von Abstraktionen abhängen statt konkreten Implementierungen.

## Wann einsetzen

- OO-Design das bewährte Lösungen für wiederkehrende Probleme benötigt
- Kommunikation von Design-Entscheidungen mit gemeinsamen Vokabular
- Refactoring zur Erhöhung von Flexibilität und Wiederverwendbarkeit
- Code Review: Anti-Pattern (z.B. Singleton-Missbrauch) identifizieren

## Prompt Pattern

```
Welches GoF Design Pattern passt für folgendes Problem?
[Problem beschreiben]

Oder: Gibt es ein GoF Pattern das diesen Code verbessern würde?
[Code]
```

## Verwandte Anchors

- SOLID Principles: `@knowledge/anchors/solid-principles.md`
- Clean Architecture: `@knowledge/anchors/clean-architecture.md`
