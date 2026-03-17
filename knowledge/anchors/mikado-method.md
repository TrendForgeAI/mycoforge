# Mikado Method

**Kategorien:** development-workflow | **Rollen:** developer, architect, team-lead | **Tier:** 2
*Auch bekannt als: Mikado Graph Method*
**Referenz:** Ola Ellnestam, Daniel Brolund — *The Mikado Method* (2012)

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Mikado Goal** | Der finale gewünschte Zustand des Codes — Root des Dependency-Graphen |
| **Prerequisite Discovery** | Änderung versuchen, Blocker identifizieren |
| **Revert and Repeat** | Nach Entdeckung eines Prerequisites: revert, dann Prerequisite angehen |
| **Mikado Graph** | Gerichteter azyklischer Graph der Prerequisites |
| **Leaf-first Resolution** | Blätter (keine weiteren Prerequisites) zuerst lösen |
| **Small Reversible Steps** | Jeder Schritt lässt die Codebase funktionsfähig |

## Wann einsetzen

- Große Refactorings in Legacy- oder komplexen Codebasen
- Wenn eine direkte Änderung zu viele Dinge bricht
- Multi-Entwickler-Refactoring ohne den Team-Flow zu blockieren
- Inkrementelle Verbesserungen ohne langen Feature-Freeze

## Visualisierung

```
Mikado-Ziel: [Remove deprecated API]
  └── Prerequisite: [Update Service A]
        └── Prerequisite: [Extract Interface X]
  └── Prerequisite: [Update Service B]
```

Leaf-first: Interface X → Service A → Service B → Ziel
