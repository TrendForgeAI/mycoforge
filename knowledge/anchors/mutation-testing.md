# Mutation Testing

**Kategorien:** testing-quality | **Rollen:** tester, developer | **Tier:** 3
*Auch bekannt als: Mutation Analysis, Fault-Based Testing*
**Referenz:** Richard Lipton (1971), Richard DeMillo, Timothy Budd

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Mutation** | Kleine syntaktische Änderung im Quellcode (z.B. `>` → `>=`) |
| **Killed Mutant** | Mutation wird von einem fehlschlagenden Test erkannt (gut) |
| **Survived Mutant** | Mutation nicht erkannt — zeigt Test-Schwäche |
| **Mutation Score** | `(killed / (total - equivalent)) × 100%` |
| **Equivalent Mutant** | Mutation die das Verhalten nicht ändert (false positive) |
| **Mutation Operator** | Regel zur Erstellung von Mutanten |

## Wann einsetzen

- Test-Suite-Qualität jenseits von Coverage-Metriken evaluieren
- Assertion-Lücken in Tests identifizieren
- Kritische Systeme mit hohem Testvertrauensanspruch
- Legacy-Code mit bestehenden Tests refactoren

## Tools

| Sprache | Tool |
|---------|------|
| Java | PITest |
| JS/TS, C# | Stryker |
| Python | Mutmut |
| PHP | Infection |

## Kernaussage

Hohe Code Coverage ≠ gute Tests. Mutation Testing beantwortet die Frage: "Würden meine Tests einen Bug erkennen?"
