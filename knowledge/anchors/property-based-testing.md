# Property-Based Testing

**Kategorien:** testing-quality | **Rollen:** tester, developer | **Tier:** 3
**Referenz:** QuickCheck (Haskell, Claessen & Hughes, 2000); Hypothesis (Python), fast-check (JS)

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Properties** | Invarianten die für alle Inputs gelten müssen |
| **Generators** | Automatische Erzeugung von Testdaten über breite Inputbereiche |
| **Shrinking** | Fehlschlagende Fälle auf den einfachsten reproduzierbaren Input reduzieren |
| **Universal Quantification** | "Für alle Inputs x gilt: f(x) hat Eigenschaft P" |
| **Stateful Testing** | Properties über Sequenzen von Operationen |
| **Model-based Testing** | Vergleich einer einfachen Referenzimplementierung mit der echten |

## Wann einsetzen

- Pure Functions und Algorithmen (Sortierung, Parsing, Serialisierung)
- Business-Regeln mit vielen Randfällen
- Wenn manuelle Test-Cases nicht ausreichen
- Ergänzung zu Example-based Tests (nicht Ersatz)

## Frameworks

| Sprache | Framework |
|---------|-----------|
| Haskell | QuickCheck (Original) |
| Python | Hypothesis |
| JavaScript/TS | fast-check |
| .NET | FsCheck |
| Java | jqwik |

## Verwandte Anchors

- Mutation Testing: `@knowledge/anchors/mutation-testing.md`
