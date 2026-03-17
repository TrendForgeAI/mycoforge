# Chain of Thought

**Kategorien:** dialogue-interaction | **Rollen:** alle Agents | **Tier:** 2
*CoT Prompting*
**Referenz:** Wei et al. — Google Research (2022)

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Intermediate Reasoning Steps** | LLM zeigt Zwischenschritte explizit statt direkt zur Antwort zu springen |
| **Zero-Shot CoT** | "Let's think step by step" — keine Beispiele nötig |
| **Few-Shot CoT** | Beispiele mit Reasoning-Ketten als Kontext |
| **Tree of Thoughts** | Verzweigtes Reasoning mit Backtracking |
| **Self-Consistency** | Mehrere Reasoning-Pfade, dann häufigste Antwort wählen |
| **Least-to-Most Prompting** | Problem in Teilprobleme zerlegen, von einfach zu komplex |

## Wann einsetzen

- Multi-Step-Mathematik und Logikprobleme
- Planungsaufgaben mit Abhängigkeiten
- Code-Debugging wenn die Ursache unklar ist
- Architekturentscheidungen mit mehreren Faktoren
- Eigenes Reasoning transparenter machen

## Prompt Pattern

```
[Problem oder Frage]

Denke Schritt für Schritt:
1. Was ist das eigentliche Problem?
2. Welche Faktoren sind relevant?
3. Welche Optionen gibt es?
4. Was ist die beste Lösung?
```
