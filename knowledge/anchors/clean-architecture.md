# Clean Architecture

**Kategorien:** software-architecture | **Rollen:** planner, architect, reviewer | **Tier:** 3
*Auch bekannt als: Onion Architecture, Screaming Architecture*
**Referenz:** Robert C. Martin — *Clean Architecture* (2017)

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Dependency Rule** | Dependencies zeigen nur nach innen — nie nach außen |
| **Konzentrische Kreise** | Entities → Use Cases → Interface Adapters → Frameworks & Drivers |
| **Framework-Unabhängigkeit** | Architektur hängt nicht von Bibliotheken ab |
| **Testbarkeit** | Business-Regeln testbar ohne UI, Datenbank oder externe Systeme |
| **UI-Unabhängigkeit** | UI kann sich ändern ohne Business-Regeln zu berühren |
| **Screaming Architecture** | Architektur kommuniziert den Systemzweck, nicht das Framework |

## Wann einsetzen

- Enterprise-Applikationen mit komplexer Business-Logik
- Systeme die langfristige Wartbarkeit erfordern
- Wenn Business-Regeln vor Technologiewechseln geschützt werden müssen

## Verwandte Anchors

- Hexagonal Architecture: `@knowledge/anchors/hexagonal-architecture.md`
- SOLID Principles: `@knowledge/anchors/solid-principles.md`
- DDD: `@knowledge/anchors/domain-driven-design.md`
