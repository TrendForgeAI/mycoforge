# TDD, London School

**Kategorien:** testing-quality | **Rollen:** tester, developer, reviewer | **Tier:** 3
*Auch bekannt als: Mockist TDD, Outside-In TDD*
**Referenz:** Steve Freeman, Nat Pryce — *Growing Object-Oriented Software, Guided by Tests* (2009)

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Mock-heavy Testing** | Intensive Nutzung von Test Doubles zur Isolation von Units |
| **Outside-In Development** | Entwicklung von außen nach innen — zuerst API/UI, dann Implementierung |
| **Interaction-based Testing** | Verifikation der Interaktionen zwischen Objekten, nicht des Zustands |
| **Interface Discovery** | Tests als Werkzeug zur Entdeckung und Definition von Interfaces |
| **Walking Skeleton** | Frühzeitig End-to-End-Funktionalität aufbauen, dann Details füllen |
| **Behavior Verification** | Prüfen wie Objekte kollaborieren, nicht was ihr Zustand nach der Operation ist |

## Wann einsetzen

- Komplexe Systeme mit vielen kollaborierenden Objekten
- Beim Entwurf von APIs und Interfaces
- Verteilte Systeme, wo Integration teuer ist
- Wenn Interface-Design im Vordergrund steht

## Abgrenzung

London School = Interaction-based, Mock-heavy, Outside-In
Chicago School = State-based, Minimal Mocks, Inside-Out → `@knowledge/anchors/tdd-chicago-school.md`
