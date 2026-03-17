# Domain-Driven Design (DDD)

**Kategorien:** software-architecture | **Rollen:** planner, architect, developer | **Tier:** 3
**Referenz:** Eric Evans — *Domain-Driven Design: Tackling Complexity in the Heart of Software* (2003)

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Ubiquitous Language** | Gemeinsames Vokabular zwischen Entwicklern und Domain-Experten |
| **Bounded Context** | Explizite Grenzen wo ein Modell definiert und gültig ist |
| **Aggregate** | Cluster von Domain-Objekten als eine transaktionale Einheit |
| **Entity** | Objekt mit Identität (nicht nur Attributen) |
| **Value Object** | Unveränderliches Objekt das durch seine Attribute definiert ist |
| **Repository** | Abstraktion für Persistenz und Abruf von Aggregates |
| **Domain Event** | Bedeutsames Ereignis in der Domain |
| **Strategic Design** | Context Mapping, Anti-Corruption Layers |
| **Tactical Design** | Bausteine: Entities, Value Objects, Services, Repositories |

## Wann einsetzen

- Komplexe Business-Domains mit vielschichtigen Regeln
- Microservices-Design (Bounded Contexts → Service-Grenzen)
- Langlebige Systeme mit tiefem Domain-Verständnis
- Wenn Business und Technik eng kollaborieren
