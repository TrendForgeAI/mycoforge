# mycoforge TODO

## Offen

### Inspiration & Adoption
- [x] `knowledge/semantic-anchors.md` anlegen — zwei Teile:
      1. Interne mycoforge-Terminologie (Task vs Step vs Plan, Agent vs Skill, …)
      2. Software-Best-Practice-Anchors je Agent-Rolle, angelehnt an LLM-Coding/Semantic-Anchors:
         - Testing & Quality     → tester.md       (TDD London School, BDD Given/When/Then)
         - Software Architecture → planner, reviewer (Clean Architecture, C4, ADR, arc42)
         - Design Principles     → developer, reviewer (SOLID, Clean Code, DRY, YAGNI)
         - Development Workflow  → committer.md    (Conventional Commits)
      → https://github.com/LLM-Coding/Semantic-Anchors
- [x] Context Rot Prevention: STATE.md Konzept evaluieren und implementieren
      → https://github.com/gsd-build/get-shit-done
- [ ] `/verify` Command: Implementierung nach /implement auf Funktionsfähigkeit prüfen
      → https://github.com/gsd-build/get-shit-done
- [x] tester-Agent: TDD Workflow RED→GREEN→REFACTOR ergänzen
      → https://github.com/obra/superpowers
- [ ] Git Worktree Support für isolierte Feature-Entwicklung
      → https://github.com/obra/superpowers

## Erledigt

### Public Release (2026-03-17)
- [x] Alle persönlichen Daten aus Repo entfernen
- [x] Git-History squashen (orphan branch, force push)
- [x] Repo auf Public gestellt
