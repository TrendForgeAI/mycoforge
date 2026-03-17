# Anchors: Developer

> Lade diese Datei wenn du als Developer-Agent arbeitest und Code-Qualitätsprinzipien benötigst.

---

## SOLID Principles
**Kategorien:** design-principles | **Rollen:** developer, reviewer, architect | **Tier:** 3
**Referenz:** Robert C. Martin ("Uncle Bob") — *Agile Software Development* (2002)

### Core Concepts

| Prinzip | Bedeutung |
|---------|-----------|
| **S — Single Responsibility** | Jede Klasse hat genau eine Verantwortlichkeit / einen Grund sich zu ändern |
| **O — Open/Closed** | Offen für Erweiterung, geschlossen für Modifikation |
| **L — Liskov Substitution** | Unterklassen müssen für ihre Basisklassen einsetzbar sein |
| **I — Interface Segregation** | Clients sollen nicht von Interfaces abhängen die sie nicht nutzen |
| **D — Dependency Inversion** | Von Abstraktionen abhängen, nicht von konkreten Implementierungen |

### Wann einsetzen

- Design von wartbaren und skalierbaren OO-Systemen
- Refactoring von Legacy-Code zur Strukturverbesserung
- Wenn Flexibilität und Testbarkeit wichtig sind
- Code Reviews auf Design-Probleme prüfen

### Prompt Pattern

```
Prüfe diesen Code auf SOLID-Verletzungen:
[Code]

Fokus auf: [SRP / OCP / LSP / ISP / DIP]
```

---

## YAGNI
**Kategorien:** design-principles | **Rollen:** developer, architect | **Tier:** 1
*You Aren't Gonna Need It*
**Referenz:** Ron Jeffries, Kent Beck — *Extreme Programming Explained* (1999)

### Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Don't build for hypothetical futures** | Nur implementieren was jetzt gebraucht wird |
| **Speculative Generality** | Anti-Pattern: Abstraktionen für imaginierte Anforderungen bauen |
| **Incremental Design** | Design entsteht durch echte Anforderungen, nicht Vorabplanung |
| **Cost of Carry** | Ungenutzter Code erhöht Komplexität und Wartungsaufwand |
| **Reversibility** | Einfache, änderbare Entscheidungen statt vorzeitiger Komplexität |

### Wann einsetzen

- Gegen Over-Engineering und vorzeitige Abstraktion
- Agile Projekte mit iterativer Lieferung
- Wenn die Versuchung besteht "für alle Fälle" Konfigurierbarkeit einzubauen
- Refactoring von Legacy-Code mit ungenutzten Features

---

## SSOT / DRY
**Kategorien:** design-principles | **Rollen:** developer, architect | **Tier:** 1
*Single Source of Truth / Don't Repeat Yourself*
**Referenz:** Andy Hunt, Dave Thomas — *The Pragmatic Programmer* (1999)

### Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Single Source of Truth** | Jede Information hat genau eine kanonische Quelle |
| **Don't Repeat Yourself** | Jedes Stück Wissen hat eine einzige, eindeutige Repräsentation im System |
| **Authoritative Source** | Eine vertrauenswürdige Stelle — alle anderen sind abgeleitet |
| **Derived Data** | Andere Repräsentationen werden aus der Quelle generiert, nicht dupliziert |
| **Code Duplication** | Duplizierter Code = dupliziertes Wissen = Synchronisierungsproblem |

### Wann einsetzen

- Wenn gleiche Logik an mehreren Stellen auftaucht (Zeichen für DRY-Verletzung)
- Datenbankdesign und Datenarchitektur
- Konfigurationsmanagement
- Dokumentation und Wissensverwaltung

### Abgrenzung

DRY ≠ "keine zwei Zeilen dürfen gleich aussehen" — es geht um **Wissen**, nicht um syntaktische Ähnlichkeit. Ähnlicher Code mit unterschiedlicher Semantik sollte NICHT abstrahiert werden (das wäre YAGNI-Verletzung).

---

## Clean Code
**Kategorien:** design-principles | **Rollen:** developer, reviewer | **Tier:** 2
**Referenz:** Robert C. Martin — *Clean Code: A Handbook of Agile Software Craftsmanship* (2008)

### Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Aussagekräftige Namen** | Namen sollen Absicht offenbaren — keine Abkürzungen, kein Noise |
| **Kleine Funktionen** | Eine Funktion tut eine Sache. Eine Ebene der Abstraktion. |
| **Keine Kommentare für Offensichtliches** | Guter Code erklärt sich selbst — Kommentare für das Warum, nicht das Was |
| **DRY** | Keine Duplizierung von Logik oder Wissen |
| **Error Handling** | Fehlerbehandlung trennen von Business-Logik (Exceptions statt Error Codes) |
| **Boy Scout Rule** | Code immer ein bisschen sauberer hinterlassen als man ihn vorgefunden hat |
| **SOLID** | Clean Code baut auf SOLID-Prinzipien auf |
| **Tests** | Sauberer Code ist testbarer Code |

### Wann einsetzen

- Code Review: Lesbarkeit, Wartbarkeit, Komplexität beurteilen
- Refactoring: Legacy-Code schrittweise verbessern
- Standard für neue Features und Bugfixes
- Onboarding: gemeinsames Qualitätsverständnis im Team

### Prompt Pattern

```
Refactore diesen Code nach Clean Code Prinzipien:
[Code]

Fokus: [Namen / Funktionsgröße / Duplikate / Kommentare]
```

---

## KISS
**Kategorien:** design-principles | **Rollen:** developer, reviewer | **Tier:** 1
*Keep It Simple, Stupid*
**Referenz:** Kelly Johnson (US Navy, 1960), in Software popularisiert durch XP-Bewegung

### Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Einfachste korrekte Lösung** | Die simpelste Implementierung die den Anforderungen genügt |
| **Lesbarkeit vor Cleverness** | Verständlicher Code schlägt cleveren Code |
| **Akkretives Design** | Komplexität nur einführen wenn sie durch echte Anforderungen erzwungen wird |
| **Keine Magie** | Implizites Verhalten vermeiden — explizit ist besser als implizit |

### Wann einsetzen

- Wenn komplexe Lösungsansätze für einfache Probleme entstehen
- Code Review: "Gibt es einen einfacheren Weg?"
- Architekturentscheidungen: einfachste Architektur die funktioniert
- Komplementär zu YAGNI: YAGNI = keine unnötigen Features, KISS = einfache Implementierung

---

## Law of Demeter
**Kategorien:** design-principles | **Rollen:** developer, reviewer | **Tier:** 2
*Principle of Least Knowledge*
**Referenz:** Ian Holland — Northeastern University (1987)

### Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Least Knowledge** | Ein Objekt soll so wenig wie möglich über andere Objekte wissen |
| **Erlaubte Aufrufe** | Eigene Methoden, Parameter, direkt erzeugte Objekte, direkte Attribute |
| **Verbotenes Method-Chaining** | `a.getB().getC().doSomething()` — Verletzung der Law of Demeter |
| **Lose Kopplung** | Objekte kommunizieren nur mit direkten Nachbarn |
| **Tell, Don't Ask** | Befehle geben statt Zustand abfragen und dann entscheiden |

### Erkennung von Verletzungen

```
// Verletzung:
customer.getAddress().getCity().toUpperCase()

// Konform:
customer.getFormattedCity()  // Customer delegiert intern
```

### Wann einsetzen

- Code Review: übermäßiges Method-Chaining identifizieren
- Refactoring: hohe Kopplung zwischen Klassen reduzieren
- Design: Objektschnittstellen definieren
