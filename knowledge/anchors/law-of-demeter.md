# Law of Demeter

**Kategorien:** design-principles | **Rollen:** developer, reviewer | **Tier:** 2
*Principle of Least Knowledge*
**Referenz:** Ian Holland — Northeastern University (1987)

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Least Knowledge** | Ein Objekt soll so wenig wie möglich über andere Objekte wissen |
| **Erlaubte Aufrufe** | Eigene Methoden, Parameter, direkt erzeugte Objekte, direkte Attribute |
| **Verbotenes Method-Chaining** | `a.getB().getC().doSomething()` — Verletzung |
| **Tell, Don't Ask** | Befehle geben statt Zustand abfragen und dann entscheiden |
| **Lose Kopplung** | Objekte kommunizieren nur mit direkten Nachbarn |

## Erkennung von Verletzungen

```
// Verletzung:
customer.getAddress().getCity().toUpperCase()

// Konform:
customer.getFormattedCity()  // Customer delegiert intern
```

## Wann einsetzen

- Code Review: übermäßiges Method-Chaining identifizieren
- Refactoring: hohe Kopplung zwischen Klassen reduzieren
- Design: Objektschnittstellen definieren
