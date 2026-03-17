# Anchors: Tester

> Lade diese Datei wenn du als Tester-Agent arbeitest und Testing-Methodiken benötigst.

---

## TDD, London School
**Kategorien:** testing-quality | **Rollen:** tester, developer, reviewer | **Tier:** 3
*Auch bekannt als: Mockist TDD, Outside-In TDD*
**Referenz:** Steve Freeman, Nat Pryce — *Growing Object-Oriented Software, Guided by Tests*

### Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Mock-heavy Testing** | Intensive Nutzung von Test Doubles (Mocks, Stubs) zur Isolation von Units |
| **Outside-In Development** | Entwicklung von außen nach innen — zuerst API/UI, dann Implementierung |
| **Interaction-based Testing** | Verifikation der Interaktionen zwischen Objekten, nicht des Zustands |
| **Interface Discovery** | Tests als Werkzeug zur Entdeckung und Definition von Interfaces |
| **Walking Skeleton** | Frühzeitig End-to-End-Funktionalität aufbauen, dann Details füllen |
| **Behavior Verification** | Prüfen wie Objekte kollaborieren, nicht was ihr Zustand nach der Operation ist |

### Wann einsetzen

- Komplexe Systeme mit vielen kollaborierenden Objekten
- Beim Entwurf von APIs und Interfaces
- Verteilte Systeme, wo Integration teuer ist
- Wenn Interface-Design im Vordergrund steht

### Abgrenzung zu Chicago School

London School = Interaction-based, Mock-heavy, Outside-In
Chicago School = State-based, Minimal Mocks, Inside-Out

---

## TDD, Chicago School
**Kategorien:** testing-quality | **Rollen:** tester, developer | **Tier:** 3
*Auch bekannt als: Classicist TDD, Detroit School*
**Referenz:** Kent Beck — *Test-Driven Development: By Example* (2002), Martin Fowler

### Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **State-based Testing** | Zustand von Objekten nach Operationen verifizieren |
| **Minimal Mocking** | Echte Objekte bevorzugen; nur externe Dependencies mocken |
| **Inside-Out Development** | Beginne mit Kernlogik, baue nach außen |
| **Red-Green-Refactor** | Der fundamentale TDD-Zyklus |
| **YAGNI** | Keine vorzeitigen Abstraktionen — nur was jetzt gebraucht wird |
| **Emergent Design** | Design entsteht durch Refactoring, nicht durch Vorabplanung |

### Wann einsetzen

- Domain-driven Design Projekte mit zentraler Business-Logik
- Kleinere, kohäsive Module
- Wenn Zustandsbasiertes Testen natürlicher ist als Interaktions-Verifikation
- Integration Tests mit realen Dependencies

---

## BDD (Behavior-Driven Development)
**Kategorien:** testing-quality | **Rollen:** tester, developer, product-owner | **Tier:** 3
*Auch bekannt als: Specification by Example, Executable Specifications*
**Referenz:** Dan North — *Introducing BDD* (2006)

### Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Given-When-Then** | Szenario-Format: Precondition → Action → Expected Outcome |
| **Specification by Example** | Konkrete Beispiele als ausführbare Spezifikationen |
| **Three Amigos** | Kollaborative Discovery zwischen Developer, Tester und Business |
| **Gherkin** | Domain-spezifische Sprache für maschinenlesbare Szenarien |
| **Living Documentation** | Tests als immer aktuelle System-Dokumentation |
| **Ubiquitous Language** | Gemeinsames Vokabular zwischen technischen und fachlichen Stakeholdern |
| **Discovery Workshops** | Strukturierte Gespräche zur Anforderungsermittlung durch Beispiele |

### Wann einsetzen

- Cross-funktionale Teams mit Kommunikationslücken zwischen Business und Technik
- Komplexe Business-Regeln die klar dokumentiert sein müssen
- Projekte mit ausführbaren Acceptance Criteria
- Wenn Tests auch als Spezifikation dienen sollen

### Prompt Pattern

```
Beschreibe folgendes Verhalten als BDD-Szenario:
[Feature/Funktion]

Format:
Given [Ausgangssituation]
When [Aktion]
Then [Erwartetes Ergebnis]
```

---

## Test Pyramid
**Kategorien:** testing-quality | **Rollen:** tester, developer, architect | **Tier:** 2
**Referenz:** Mike Cohn — *Succeeding with Agile* (2009), Martin Fowler

### Core Concepts

| Ebene | Typ | Eigenschaften |
|-------|-----|---------------|
| **Basis (viele)** | Unit Tests | Schnell, isoliert, günstig, viel davon |
| **Mitte (wenige)** | Integration Tests | Komponenten-Interaktion, mittelschnell |
| **Spitze (minimal)** | E2E / UI Tests | Langsam, teuer, fragil — so wenig wie möglich |

**Kernprinzip:** Teste nie durch die UI, was in Isolation getestet werden kann.

**Anti-Pattern: Ice Cream Cone** — Invertierte Pyramide: Viele E2E, wenig Unit Tests → langsam, fragil, teuer.

### Wann einsetzen

- Test-Strategie für neue Projekte definieren
- Wenn Test-Suite zu langsam oder zu fragil ist (Diagnose: Ice Cream Cone?)
- Coverage-Ziele pro Ebene festlegen (z.B. 80% Unit, 60% Integration, kritische Flows E2E)

---

## Test Doubles (nach Meszaros)
**Kategorien:** testing-quality | **Rollen:** tester, developer | **Tier:** 2
**Referenz:** Gerard Meszaros — *xUnit Test Patterns* (2007)

### Core Concepts

| Typ | Zweck | Verifikation |
|-----|-------|--------------|
| **Dummy** | Füllt Parameterlisten, wird nicht benutzt | Keine |
| **Stub** | Liefert vorgefertigte Antworten | Keine |
| **Spy** | Stub der Interaktionen aufzeichnet | Im Nachhinein |
| **Mock** | Mit Erwartungen vorprogrammiert | Automatisch beim Verify |
| **Fake** | Echte, vereinfachte Implementierung (z.B. In-Memory-DB) | Keine |

**Oberbegriff:** Test Double = jedes Objekt das eine echte Dependency im Test ersetzt.

**London School** nutzt viele Mocks (Interaction-based).
**Chicago School** bevorzugt Fakes/reale Objekte (State-based).

### Prompt Pattern

```
Welchen Test-Double-Typ soll ich für [Dependency] verwenden?
Kontext: [London School / Chicago School], [was getestet wird]
```
