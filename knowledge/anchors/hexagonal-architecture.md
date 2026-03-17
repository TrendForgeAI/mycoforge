# Hexagonal Architecture

**Kategorien:** software-architecture | **Rollen:** planner, architect, developer | **Tier:** 3
*Auch bekannt als: Ports & Adapters, Onion Architecture (Variante)*
**Referenz:** Alistair Cockburn (2005)

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Ports** | Interfaces die definieren wie die Applikation kommuniziert |
| **Adapters** | Implementierungen die an externe Systeme anbinden |
| **Core Domain** | Business-Logik in der Mitte, isoliert von externen Concerns |
| **Primary/Driving Adapters** | Inbound: UI, API, CLI |
| **Secondary/Driven Adapters** | Outbound: Datenbank, Message Queue, externe APIs |
| **Technology Independence** | Core-Logik hängt nicht von Frameworks oder Infrastruktur ab |

## Wann einsetzen

- Applikationen mit hohem Testbarkeitsanspruch
- Systeme die mehrere Interfaces unterstützen müssen (Web, CLI, API)
- Wenn Infrastrukturentscheidungen verzögert werden sollen
- Microservices mit klaren Domain-Grenzen

## Verwandte Anchors

- Clean Architecture: `@knowledge/anchors/clean-architecture.md`
