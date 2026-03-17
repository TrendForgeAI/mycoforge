# Anchors: Planner

> Lade diese Datei wenn du als Planner-Agent arbeitest und Architektur-/Planungsmethodiken benötigst.

---

## ADR (Architecture Decision Records)
**Kategorien:** software-architecture | **Rollen:** planner, architect, developer, team-lead | **Tier:** 3
*Auch bekannt als: Lightweight Architecture Documentation*
**Referenz:** Michael Nygard — *Documenting Architecture Decisions* (2011)

### Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Lightweight Documentation** | Kurze, fokussierte Aufzeichnungen — kein Overhead |
| **Struktur** | Titel · Status · Kontext · Entscheidung · Konsequenzen |
| **Status-Werte** | proposed → accepted → deprecated / superseded |
| **Immutability** | ADRs werden nie gelöscht, nur durch neue ersetzt (superseded) |
| **Versionskontrolle** | ADRs liegen im Repo neben dem Code |
| **Decision Archaeology** | Warum vergangene Entscheidungen getroffen wurden nachvollziehen |

### Wann einsetzen

- Jedes Software-Projekt (geringer Aufwand, hoher Nutzen)
- Verteilte Teams die gemeinsames Architekturverständnis brauchen
- Beim Onboarding neuer Teammitglieder
- Komplexe Systeme mit sich entwickelnder Architektur

### Prompt Pattern

```
Erstelle ein ADR für folgende Entscheidung:
Kontext: [warum steht diese Entscheidung an?]
Optionen: [A / B / C]
Entscheidung: [gewählte Option]
Konsequenzen: [was ändert sich dadurch?]
```

---

## arc42
**Kategorien:** software-architecture | **Rollen:** planner, architect, technical-writer | **Tier:** 3
**Referenz:** Gernot Starke, Peter Hruschka — https://arc42.org

### Core Concepts — 12 Kapitel

| Kapitel | Inhalt |
|---------|--------|
| **1 — Introduction & Goals** | Anforderungen, Stakeholder, Qualitätsziele |
| **2 — Constraints** | Technische und organisatorische Randbedingungen |
| **3 — Context & Scope** | Systemgrenzen, externe Schnittstellen |
| **4 — Solution Strategy** | Kernentscheidungen, Lösungsansatz |
| **5 — Building Block View** | Statische Struktur, Komponenten |
| **6 — Runtime View** | Dynamisches Verhalten, Szenarien |
| **7 — Deployment View** | Infrastruktur, Deployments |
| **8 — Crosscutting Concepts** | Übergreifende Konzepte (Security, Logging, …) |
| **9 — Architecture Decisions** | ADRs |
| **10 — Quality Requirements** | Quality Scenarios, Qualitätsbaum |
| **11 — Risks & Technical Debt** | Bekannte Risiken, technische Schulden |
| **12 — Glossary** | Domänenspezifische Begriffe |

**Pragmatisches Prinzip:** Nur dokumentieren was nötig ist. Leere Kapitel weglassen.

### Wann einsetzen

- Mittlere bis große Software-Projekte
- Wenn Stakeholder-Kommunikation kritisch ist
- Langlebige Systeme die Wartbarkeit erfordern

---

## C4 Model
**Kategorien:** software-architecture | **Rollen:** planner, architect, technical-writer | **Tier:** 3
**Referenz:** Simon Brown — *Software Architecture for Developers* (2018)

### Core Concepts — 4 Abstraktionsebenen

| Ebene | Frage | Zielgruppe |
|-------|-------|------------|
| **L1 — Context** | Was ist das System? Wer nutzt es? Welche externen Systeme? | Alle Stakeholder |
| **L2 — Container** | Welche deploybare Einheiten? Apps, Datenbanken, APIs? | Technische Stakeholder |
| **L3 — Component** | Welche Komponenten innerhalb eines Containers? | Entwicklungsteam |
| **L4 — Code** | Klassen, Entities (optional) | Entwickler |

**Progressive Disclosure:** Zoom in je nach Bedarf und Zielgruppe.
**Einfache Notation:** Boxes und Pfeile — minimaler Overhead, kein UML erforderlich.

### Wann einsetzen

- Architektur für diverse Stakeholder kommunizieren
- Onboarding neuer Teammitglieder
- Architektur-Dokumentation und Reviews
- Als Ergänzung oder Ersatz für UML

---

## Clean Architecture
**Kategorien:** software-architecture | **Rollen:** planner, architect, reviewer | **Tier:** 3
*Auch bekannt als: Onion Architecture, Screaming Architecture*
**Referenz:** Robert C. Martin — *Clean Architecture* (2017)

### Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Dependency Rule** | Dependencies zeigen nur nach innen — nie nach außen |
| **Konzentrische Kreise** | Entities → Use Cases → Interface Adapters → Frameworks & Drivers |
| **Framework-Unabhängigkeit** | Architektur hängt nicht von Bibliotheken ab |
| **Testbarkeit** | Business-Regeln testbar ohne UI, Datenbank oder externe Systeme |
| **UI-Unabhängigkeit** | UI kann sich ändern ohne Business-Regeln zu berühren |
| **Screaming Architecture** | Architektur kommuniziert den Systemzweck, nicht das Framework |

### Wann einsetzen

- Enterprise-Applikationen mit komplexer Business-Logik
- Systeme die langfristige Wartbarkeit erfordern
- Wenn Business-Regeln vor Technologiewechseln geschützt werden müssen

---

## Domain-Driven Design (DDD)
**Kategorien:** software-architecture | **Rollen:** planner, architect, developer | **Tier:** 3
**Referenz:** Eric Evans — *Domain-Driven Design: Tackling Complexity in the Heart of Software* (2003)

### Core Concepts

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

### Wann einsetzen

- Komplexe Business-Domains mit vielschichtigen Regeln
- Langlebige Systeme mit tiefem Domain-Verständnis
- Wenn Business und Technik eng kollaborieren
- Microservices-Design (Bounded Contexts → Service-Grenzen)

---

## CQRS
**Kategorien:** software-architecture | **Rollen:** planner, architect, developer | **Tier:** 3
*Command Query Responsibility Segregation*
**Referenz:** Greg Young (CQRS), Bertrand Meyer — *Object-Oriented Software Construction* (1988, CQS)

### Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Commands** | Schreib-Operationen die Zustand ändern und void zurückgeben |
| **Queries** | Lese-Operationen die Daten zurückgeben ohne Seiteneffekte |
| **Separate Read/Write Models** | Unabhängige Datenmodelle je nach Zweck optimiert |
| **Eventual Consistency** | Read-Modell kann hinter Write-Modell hinken — akzeptabler Trade-off |
| **Independent Scalability** | Read- und Write-Seite unabhängig skalierbar und deploybar |
| **Event Sourcing (optional)** | CQRS erfordert kein Event Sourcing — komplementär aber unabhängig |

### Wann einsetzen

- Asymmetrische Read/Write-Workloads
- Komplexe Domains wo Read- und Write-Modelle divergieren
- High-Performance-Systeme mit unabhängigem Scaling
- Event-sourced Systeme

---

## Hexagonal Architecture
**Kategorien:** software-architecture | **Rollen:** planner, architect, developer | **Tier:** 3
*Auch bekannt als: Ports & Adapters, Onion Architecture (Variante)*
**Referenz:** Alistair Cockburn (2005)

### Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Ports** | Interfaces die definieren wie die Applikation kommuniziert |
| **Adapters** | Implementierungen die an externe Systeme anbinden |
| **Core Domain** | Business-Logik in der Mitte, isoliert von externen Concerns |
| **Primary/Driving Adapters** | Inbound: UI, API, CLI |
| **Secondary/Driven Adapters** | Outbound: Datenbank, Message Queue, externe APIs |
| **Dependency Inversion** | Dependencies zeigen nach innen zur Domain |
| **Technology Independence** | Core-Logik hängt nicht von Frameworks oder Infrastruktur ab |

### Wann einsetzen

- Applikationen mit hohem Testbarkeitsanspruch
- Systeme die mehrere Interfaces unterstützen müssen (Web, CLI, API)
- Wenn Infrastrukturentscheidungen verzögert werden sollen
- Microservices mit klaren Domain-Grenzen
