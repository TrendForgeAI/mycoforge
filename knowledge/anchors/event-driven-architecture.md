# Event-Driven Architecture (EDA)

**Kategorien:** software-architecture | **Rollen:** planner, architect, developer | **Tier:** 3
**Referenz:** Gregor Hohpe, Bobby Woolf — *Enterprise Integration Patterns* (2003), Martin Fowler

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Event** | Zustandsänderung oder bedeutsames Ereignis im System |
| **Publisher/Subscriber** | Erzeuger und Empfänger von Events sind entkoppelt |
| **Asynchronous Decoupling** | Kommunikation ohne direkten Aufruf — kein zeitliches Coupling |
| **Message Broker** | Middleware für Event-Transport (Kafka, RabbitMQ, SQS) |
| **Eventual Consistency** | Zustand konvergiert, aber nicht sofort konsistent |
| **At-least-once Delivery** | Events können mehrfach ankommen — Idempotenz erforderlich |
| **Choreography** | Services reagieren auf Events ohne zentralen Koordinator |
| **Orchestration** | Zentraler Koordinator steuert den Ablauf |

## Wann einsetzen

- Systeme mit hohem Entkopplungsbedarf zwischen Services
- Asynchrone Verarbeitung ohne direkte Aufrufe
- Event Sourcing und CQRS (komplementär)
- Microservices-Kommunikation über Service-Grenzen hinweg

## Verwandte Anchors

- CQRS: `@knowledge/anchors/cqrs.md`
- DDD: `@knowledge/anchors/domain-driven-design.md`
