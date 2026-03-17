# CQRS

**Kategorien:** software-architecture | **Rollen:** planner, architect, developer | **Tier:** 3
*Command Query Responsibility Segregation*
**Referenz:** Greg Young (CQRS), Bertrand Meyer — *Object-Oriented Software Construction* (1988, CQS)

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Commands** | Schreib-Operationen die Zustand ändern und void zurückgeben |
| **Queries** | Lese-Operationen die Daten zurückgeben ohne Seiteneffekte |
| **Separate Read/Write Models** | Unabhängige Datenmodelle je nach Zweck optimiert |
| **Eventual Consistency** | Read-Modell kann hinter Write-Modell hinken |
| **Independent Scalability** | Read- und Write-Seite unabhängig skalierbar |
| **Event Sourcing (optional)** | CQRS erfordert kein Event Sourcing — komplementär aber unabhängig |

## Wann einsetzen

- Asymmetrische Read/Write-Workloads
- Komplexe Domains wo Read- und Write-Modelle divergieren
- High-Performance-Systeme mit unabhängigem Scaling

## Verwandte Anchors

- Event-Driven Architecture: `@knowledge/anchors/event-driven-architecture.md`
- DDD: `@knowledge/anchors/domain-driven-design.md`
