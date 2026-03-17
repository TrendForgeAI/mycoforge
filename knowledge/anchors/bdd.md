# BDD (Behavior-Driven Development)

**Kategorien:** testing-quality | **Rollen:** tester, developer, product-owner | **Tier:** 3
*Auch bekannt als: Specification by Example, Executable Specifications*
**Referenz:** Dan North — *Introducing BDD* (2006)

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Given-When-Then** | Szenario-Format: Precondition → Action → Expected Outcome |
| **Specification by Example** | Konkrete Beispiele als ausführbare Spezifikationen |
| **Three Amigos** | Kollaborative Discovery zwischen Developer, Tester und Business |
| **Gherkin** | Domain-spezifische Sprache für maschinenlesbare Szenarien → `@knowledge/anchors/gherkin.md` |
| **Living Documentation** | Tests als immer aktuelle System-Dokumentation |
| **Ubiquitous Language** | Gemeinsames Vokabular zwischen technischen und fachlichen Stakeholdern |
| **Discovery Workshops** | Strukturierte Gespräche zur Anforderungsermittlung durch Beispiele |

## Wann einsetzen

- Cross-funktionale Teams mit Kommunikationslücken zwischen Business und Technik
- Komplexe Business-Regeln die klar dokumentiert sein müssen
- Projekte mit ausführbaren Acceptance Criteria
- Wenn Tests auch als Spezifikation dienen sollen

## Prompt Pattern

```
Beschreibe folgendes Verhalten als BDD-Szenario:
[Feature/Funktion]

Format:
Given [Ausgangssituation]
When [Aktion]
Then [Erwartetes Ergebnis]
```
