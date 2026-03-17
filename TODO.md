# mycoforge TODO

## Offen

### Inspiration & Adoption
- [ ] Prüfen ob alles Sinnvolle von superpowers übernommen wurde
      → https://github.com/obra/superpowers
- [ ] Prüfen ob alles Sinnvolle von get-shit-done übernommen wurde
      → https://github.com/gsd-build/get-shit-done

### mycoforge Gesamtoptimierung
- [ ] Architektur-Review: ARCHITECTURE.md gegen tatsächliche Implementierung abgleichen,
      veraltete Abschnitte korrigieren, fehlende Muster ergänzen
- [ ] Namenskonventionen prüfen: Konsistenz von Agent-, Skill-, Command- und Dateinamen
      über das gesamte Projekt (Deutsch vs. Englisch, Singular/Plural, Schreibweise)
- [ ] Agent-Definitionen normalisieren: Eingabe/Ausgabe-Format, Prinzipien-Abschnitte
      und Best-Practices-Verlinkungen auf einheitlichen Stand bringen
- [ ] Dokumentation: README.md, CLAUDE.md und ARCHITECTURE.md auf Aktualität prüfen
      und fehlende Abschnitte ergänzen (neue Commands, Skills, Patterns)
- [ ] Security-Audit: Hooks, Shell-Skripte und Secrets-Scan auf Lücken prüfen
- [ ] MEMORY.md-Platzhalter bereinigen: alle Platzhalter durch echte Werte ersetzen
      oder entfernen

## Erledigt

### Inspiration & Adoption (2026-03-17)
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
- [x] `/verify` Command: Implementierung nach /implement auf Funktionsfähigkeit prüfen
      → https://github.com/gsd-build/get-shit-done
- [x] tester-Agent: TDD Workflow RED→GREEN→REFACTOR ergänzen
      → https://github.com/obra/superpowers
- [x] Git Worktree Support für isolierte Feature-Entwicklung
      → https://github.com/obra/superpowers

### Public Release (2026-03-17)
- [x] Alle persönlichen Daten aus Repo entfernen
- [x] Git-History squashen (orphan branch, force push)
- [x] Repo auf Public gestellt
