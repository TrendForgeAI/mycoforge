# ADR (Architecture Decision Records)

**Kategorien:** software-architecture | **Rollen:** planner, architect, developer, team-lead | **Tier:** 3
*Auch bekannt als: Lightweight Architecture Documentation*
**Referenz:** Michael Nygard — *Documenting Architecture Decisions* (2011)

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Struktur** | Titel · Status · Kontext · Entscheidung · Konsequenzen |
| **Status-Werte** | proposed → accepted → deprecated / superseded |
| **Immutability** | ADRs werden nie gelöscht, nur durch neue ersetzt |
| **Versionskontrolle** | ADRs liegen im Repo neben dem Code |
| **Decision Archaeology** | Warum vergangene Entscheidungen getroffen wurden nachvollziehen |

## Wann einsetzen

- Jedes Software-Projekt (geringer Aufwand, hoher Nutzen)
- Verteilte Teams die gemeinsames Architekturverständnis brauchen
- Komplexe Systeme mit sich entwickelnder Architektur

## Prompt Pattern

```
Erstelle ein ADR für folgende Entscheidung:
Kontext: [warum steht diese Entscheidung an?]
Optionen: [A / B / C]
Entscheidung: [gewählte Option]
Konsequenzen: [was ändert sich dadurch?]
```

## Verwandte Anchors

- MADR (detaillierteres Format): `@knowledge/anchors/madr.md`
