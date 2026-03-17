# Test Doubles (Meszaros)

**Kategorien:** testing-quality | **Rollen:** tester, developer | **Tier:** 2
**Referenz:** Gerard Meszaros — *xUnit Test Patterns* (2007)

## Core Concepts

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

## Wann einsetzen

- Externe Dependencies isolieren (Datenbank, API, Filesystem)
- Tests deterministisch und schnell machen
- Interaction-based Testing (London School)

## Prompt Pattern

```
Welchen Test-Double-Typ soll ich für [Dependency] verwenden?
Kontext: [London School / Chicago School], [was getestet wird]
```
