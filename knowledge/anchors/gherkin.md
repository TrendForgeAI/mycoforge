# Gherkin

**Kategorien:** testing-quality | **Rollen:** tester, developer, product-owner | **Tier:** 2
**Referenz:** Aslak Hellesøy (2008) — Basis für Cucumber, SpecFlow, Behave

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Feature** | Beschreibung eines zu testenden Features mit Szenarien |
| **Scenario** | Einzelner Testfall mit Given-When-Then-Schritten |
| **Given** | Ausgangszustand / Precondition |
| **When** | Aktion die ausgeführt wird |
| **Then** | Erwartetes Ergebnis / Assertion |
| **And / But** | Erweiterungen von Given/When/Then für mehrere Schritte |
| **Scenario Outline** | Datengesteuertes Szenario mit Beispiel-Tabelle |
| **Background** | Gemeinsame Given-Schritte für alle Szenarien einer Feature-Datei |

## Wann einsetzen

- Kollaborative Acceptance Criteria mit Business und QA
- Ausführbare Dokumentation die stets aktuell bleibt
- Automatisierte Acceptance Tests (Cucumber, SpecFlow, Behave)
- Wenn non-technische Stakeholder Szenarien lesen und validieren sollen

## Beispiel

```gherkin
Feature: Nutzer-Login

  Scenario: Erfolgreicher Login
    Given ein registrierter Nutzer mit E-Mail "user@example.com"
    When der Nutzer sich mit korrektem Passwort einloggt
    Then wird er zum Dashboard weitergeleitet

  Scenario Outline: Login mit verschiedenen Rollen
    Given ein Nutzer mit Rolle "<rolle>"
    When er sich einloggt
    Then sieht er "<startseite>"

    Examples:
      | rolle | startseite  |
      | admin | /admin      |
      | user  | /dashboard  |
```

## Verwandte Anchors

- BDD: `@knowledge/anchors/bdd.md`
