# Semantic Anchors

## Wann diese Datei laden?

Lade diese Datei wenn:
- ein Agent Begriffe aus dem mycoforge-Ökosystem korrekt verwenden soll (Teil 1)
- ein Agent Code nach etablierten Best Practices schreiben oder reviewen soll (Teil 2)
- Terminologie-Konsistenz zwischen mehreren Agents wichtig ist

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

Semantic Anchors aktivieren etabliertes Wissen im LLM mit minimalem Token-Aufwand.
Format: **Anchor** → was er aktiviert | Genutzt von

### Testing & Quality → `tester.md`

| Anchor | Aktiviert | Hinweis |
|--------|-----------|---------|
| **TDD, London School** | Outside-in Testing, Mock-heavy, Interaction-based Verification, Red-Green-Refactor | Bevorzugt bei isolierten Unit Tests |
| **TDD, Chicago School** | State-based Testing, Inside-out, Real Objects bevorzugt | Bevorzugt bei Integration Tests |
| **BDD, Given/When/Then** | Behavior-driven Development, Gherkin-Syntax, lebende Dokumentation | Wenn Tests auch Spezifikation sein sollen |
| **AAA Pattern** | Arrange-Act-Assert, klare Teststruktur, Lesbarkeit | Standard für alle Unit Tests |
| **Test Pyramid** | Viele Unit Tests, wenige Integration, minimale E2E; Kosten-Nutzen-Verhältnis | Für Test-Strategie-Entscheidungen |

### Software Architecture → `planner.md`, `reviewer.md`

| Anchor | Aktiviert | Hinweis |
|--------|-----------|---------|
| **Clean Architecture** | Uncle Bob, Dependency Rule, Use Cases als Zentrum, Framework-Unabhängigkeit | Für Architekturentscheidungen in neuen Projekten |
| **C4 Model** | Context/Container/Component/Code Diagramme, Simon Brown, hierarchische Visualisierung | Für Architektur-Dokumentation |
| **ADR, Nygard** | Architecture Decision Records, Kontext/Entscheidung/Konsequenzen, Nachvollziehbarkeit | Für wichtige Architekturentscheidungen |
| **arc42** | Strukturierte Architekturdokumentation, 12 Kapitel, ISO 42010 | Für vollständige Systemdokumentation |
| **CQRS** | Command Query Responsibility Segregation, Read/Write-Trennung, Event Sourcing | Bei komplexen Datenmodellen |
| **Hexagonal Architecture** | Ports & Adapters, Alistair Cockburn, Testbarkeit, Framework-Isolation | Alternative zu Clean Architecture |

### Design Principles → `developer.md`, `reviewer.md`

| Anchor | Aktiviert | Hinweis |
|--------|-----------|---------|
| **SOLID Principles** | Single Responsibility, Open/Closed, Liskov, Interface Segregation, Dependency Inversion | Basis für OOP-Design-Reviews |
| **Clean Code** | Robert C. Martin, aussagekräftige Namen, kleine Funktionen, keine Kommentare für Offensichtliches | Standard für Code-Qualität |
| **DRY** | Don't Repeat Yourself, Single Source of Truth, Abstraktion | Bei Duplikaten im Code |
| **YAGNI** | You Ain't Gonna Need It, kein spekulatives Design, minimale Implementierung | Gegen Over-Engineering |
| **KISS** | Keep It Simple Stupid, einfachste korrekte Lösung, Lesbarkeit vor Cleverness | Bei komplexen Lösungsansätzen |
| **Law of Demeter** | Least Knowledge Principle, lose Kopplung, kein Method Chaining über Grenzen | Bei Dependency-Problemen |

### Development Workflow → `committer.md`, `developer.md`

| Anchor | Aktiviert | Hinweis |
|--------|-----------|---------|
| **Conventional Commits** | feat/fix/docs/refactor/test/chore, semantische Versionierung, CHANGELOG-Generierung | Standard für alle Commits in mycoforge |
| **Atomic Commits** | Ein Commit = eine abgeschlossene Einheit, jederzeit revertierbar, klare History | Bereits in committer.md verankert |
| **Feature Branch Workflow** | Isolierte Entwicklung, Pull Requests, Code Review vor Merge | Für Projekte in /workspace/ |

### Security → `reviewer.md`

| Anchor | Aktiviert | Hinweis |
|--------|-----------|---------|
| **OWASP Top 10** | Injection, Broken Auth, XSS, IDOR, Security Misconfiguration, … | Bereits in reviewer.md referenziert |
| **Secure by Design** | Threat Modeling, Principle of Least Privilege, Defense in Depth, Fail Secure | Für Sicherheitsarchitektur-Reviews |
| **Zero Trust** | Never trust, always verify; kein implizites Vertrauen durch Netzwerklage | Bei Infrastruktur- und API-Design |
