# Test Pyramid

**Kategorien:** testing-quality | **Rollen:** tester, developer, architect | **Tier:** 2
**Referenz:** Mike Cohn — *Succeeding with Agile* (2009), Martin Fowler

## Core Concepts

| Ebene | Typ | Eigenschaften |
|-------|-----|---------------|
| **Basis (viele)** | Unit Tests | Schnell, isoliert, günstig |
| **Mitte (wenige)** | Integration Tests | Komponenten-Interaktion, mittelschnell |
| **Spitze (minimal)** | E2E / UI Tests | Langsam, teuer, fragil |

**Kernprinzip:** Teste nie durch die UI, was in Isolation getestet werden kann.

**Anti-Pattern: Ice Cream Cone** — Invertierte Pyramide: Viele E2E, wenig Unit Tests → langsam, fragil, teuer.

## Wann einsetzen

- Test-Strategie für neue Projekte definieren
- Wenn Test-Suite zu langsam oder zu fragil ist (Diagnose: Ice Cream Cone?)
- Coverage-Ziele pro Ebene festlegen (z.B. 80% Unit, 60% Integration, kritische Flows E2E)
