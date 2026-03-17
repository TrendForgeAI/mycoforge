# Semantic Anchors

## Wann diese Datei laden?

Lade diese Datei wenn:
- ein Agent Begriffe aus dem mycoforge-Ökosystem korrekt verwenden soll (Teil 1)
- Terminologie-Konsistenz zwischen mehreren Agents wichtig ist

Für rollenspezifische Best-Practice-Anchors (Teil 2): Lade stattdessen die passende Datei direkt.

## Wann aktualisieren?

- Ein neuer Agent wird hinzugefügt → interne Terminologie in Teil 1 prüfen
- Ein Begriff ändert seine Bedeutung im Projekt → entsprechende Zeile anpassen
- Ein neuer Best-Practice-Anchor wird im Projekt relevant → in Teil 2 ergänzen

Referenz: https://github.com/LLM-Coding/Semantic-Anchors (60+ Anchors, 12 Kategorien, 12 Rollen)

---

## Teil 1 — Interne mycoforge-Terminologie

| Begriff | Definition | Abgrenzung zu | Genutzt von |
|---------|-----------|---------------|-------------|
| **Task** | Atomare, abgeschlossene Arbeitseinheit mit klarem In/Output | Step (= Handlungsschritt innerhalb eines Tasks), Subtask (= Teilaufgabe eines Tasks) | planner, developer, orchestrator |
| **Plan** | Geordnete Folge von Tasks mit Abhängigkeiten und Tier-Zuweisung | Roadmap (= langfristige Zielrichtung ohne Implementierungsdetails) | planner, orchestrator |
| **Agent** | Spezialisierter Subprozess mit definierter Rolle und Eingabe/Ausgabe-Format | Skill (= wiederverwendbare Prompt-Vorlage, kein Subprozess) | alle |
| **Skill** | Wiederverwendbare Prompt-Vorlage, die als Slash-Command aufrufbar ist | Agent (= autonomer Subprozess mit eigenen Tool-Calls) | orchestrator, nutzer |
| **Orchestrator** | Koordiniert Agents, verteilt Tasks, integriert Ergebnisse | Planner (= erzeugt nur den Plan, führt nicht aus) | implement-skill |
| **Council** | Strukturierte Diskussion mit drei Perspektiven (Generalist, Developer, Reviewer) | Review (= einseitiges Code Review ohne Gegenpositionen) | discuss-skill, council-agents |
| **Runde** | Eine Iteration im Council, in der alle drei Mitglieder ihre Position äußern | Task (= Arbeitseinheit außerhalb des Council-Kontexts) | council-agents |
| **Tier** | Klassifikation eines Tasks nach Komplexität: Klein / Mittel / Groß | Provider (= technischer Anbieter des Modells) | planner, model-routing |
| **Provider** | KI-Anbieter (Anthropic, OpenAI, Google) mit spezifischen Modell-Stärken | Modell (= konkretes Modell eines Providers, z.B. claude-sonnet-4-6) | model-routing |

---

## Teil 2 — Software Best-Practice Anchors (SSOT)

Jeder Anchor hat eine eigene Datei in `knowledge/anchors/`. Agents laden direkt was sie brauchen.
Welche Anchors für welchen Agent relevant sind steht in den jeweiligen Agent-Definitionen (`## Best Practices`).

### Testing & Quality

| Anchor | Datei |
|--------|-------|
| TDD, London School | `@knowledge/anchors/tdd-london-school.md` |
| TDD, Chicago School | `@knowledge/anchors/tdd-chicago-school.md` |
| BDD / Given-When-Then | `@knowledge/anchors/bdd.md` |
| Gherkin | `@knowledge/anchors/gherkin.md` |
| Test Pyramid | `@knowledge/anchors/testing-pyramid.md` |
| Test Doubles (Meszaros) | `@knowledge/anchors/test-doubles.md` |
| Property-based Testing | `@knowledge/anchors/property-based-testing.md` |
| Mutation Testing | `@knowledge/anchors/mutation-testing.md` |

### Design Principles

| Anchor | Datei |
|--------|-------|
| SOLID Principles | `@knowledge/anchors/solid-principles.md` |
| Clean Code | `@knowledge/anchors/clean-code.md` |
| YAGNI | `@knowledge/anchors/yagni.md` |
| SSOT / DRY | `@knowledge/anchors/ssot-dry.md` |
| KISS | `@knowledge/anchors/kiss.md` |
| Law of Demeter | `@knowledge/anchors/law-of-demeter.md` |
| GoF Design Patterns | `@knowledge/anchors/gof-design-patterns.md` |

### Software Architecture

| Anchor | Datei |
|--------|-------|
| Clean Architecture | `@knowledge/anchors/clean-architecture.md` |
| Hexagonal Architecture | `@knowledge/anchors/hexagonal-architecture.md` |
| C4 Model | `@knowledge/anchors/c4-model.md` |
| ADR (Nygard) | `@knowledge/anchors/adr.md` |
| MADR | `@knowledge/anchors/madr.md` |
| arc42 | `@knowledge/anchors/arc42.md` |
| CQRS | `@knowledge/anchors/cqrs.md` |
| Event-Driven Architecture | `@knowledge/anchors/event-driven-architecture.md` |
| Domain-Driven Design | `@knowledge/anchors/domain-driven-design.md` |
| ATAM | `@knowledge/anchors/atam.md` |

### Development Workflow

| Anchor | Datei |
|--------|-------|
| Conventional Commits | `@knowledge/anchors/conventional-commits.md` |
| Semantic Versioning | `@knowledge/anchors/semantic-versioning.md` |
| Feature Branch Workflow | `@knowledge/anchors/feature-branch-workflow.md` |
| Mikado Method | `@knowledge/anchors/mikado-method.md` |
| Docs-as-Code | `@knowledge/anchors/docs-as-code.md` |
| Diátaxis Framework | `@knowledge/anchors/diataxis-framework.md` |

### Security

| Anchor | Datei |
|--------|-------|
| OWASP Top 10 | `@knowledge/anchors/owasp-top-10.md` |
| STRIDE | `@knowledge/anchors/stride.md` |
| Secure by Design | `@knowledge/anchors/secure-by-design.md` |

### Problem Solving & Strategy

| Anchor | Datei |
|--------|-------|
| Devil's Advocate | `@knowledge/anchors/devils-advocate.md` |
| Five Whys | `@knowledge/anchors/five-whys.md` |
| Cynefin Framework | `@knowledge/anchors/cynefin-framework.md` |
| Feynman Technique | `@knowledge/anchors/feynman-technique.md` |
| Chain of Thought | `@knowledge/anchors/chain-of-thought.md` |
| MECE | `@knowledge/anchors/mece.md` |
| Pugh Matrix | `@knowledge/anchors/pugh-matrix.md` |
| MoSCoW | `@knowledge/anchors/moscow.md` |
| SWOT | `@knowledge/anchors/swot.md` |
| Impact Mapping | `@knowledge/anchors/impact-mapping.md` |
| User Story Mapping | `@knowledge/anchors/user-story-mapping.md` |
