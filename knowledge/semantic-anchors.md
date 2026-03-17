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

## Teil 2 — Software Best-Practice Anchors je Agent-Rolle

Detaillierte Anchors sind in rollenspezifischen Dateien — nur die relevante Datei laden:

| Datei | Enthält | Für Agent |
|-------|---------|-----------|
| `@knowledge/anchors/tester.md` | TDD London/Chicago School, BDD, Testing Pyramid, Test Doubles | tester |
| `@knowledge/anchors/developer.md` | SOLID, Clean Code, YAGNI, SSOT/DRY, KISS, Law of Demeter | developer |
| `@knowledge/anchors/reviewer.md` | OWASP Top 10, STRIDE, Devil's Advocate, Secure by Design | reviewer |
| `@knowledge/anchors/planner.md` | ADR, arc42, C4 Model, Clean Architecture, DDD, CQRS, Hexagonal Architecture | planner |
| `@knowledge/anchors/committer.md` | Conventional Commits, Semantic Versioning, Feature Branch Workflow | committer |
