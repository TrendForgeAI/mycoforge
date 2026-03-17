# Clean Code

**Kategorien:** design-principles | **Rollen:** developer, reviewer | **Tier:** 2
**Referenz:** Robert C. Martin — *Clean Code: A Handbook of Agile Software Craftsmanship* (2008)

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Aussagekräftige Namen** | Namen sollen Absicht offenbaren — keine Abkürzungen, kein Noise |
| **Kleine Funktionen** | Eine Funktion tut eine Sache. Eine Ebene der Abstraktion. |
| **Keine Kommentare für Offensichtliches** | Guter Code erklärt sich selbst — Kommentare für das Warum, nicht das Was |
| **DRY** | Keine Duplizierung von Logik oder Wissen |
| **Error Handling** | Fehlerbehandlung trennen von Business-Logik (Exceptions statt Error Codes) |
| **Boy Scout Rule** | Code immer ein bisschen sauberer hinterlassen als man ihn vorgefunden hat |

## Wann einsetzen

- Code Review: Lesbarkeit, Wartbarkeit, Komplexität beurteilen
- Refactoring: Legacy-Code schrittweise verbessern
- Standard für neue Features und Bugfixes

## Prompt Pattern

```
Refactore diesen Code nach Clean Code Prinzipien:
[Code]

Fokus: [Namen / Funktionsgröße / Duplikate / Kommentare]
```
