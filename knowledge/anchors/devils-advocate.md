# Devil's Advocate

**Kategorien:** problem-solving | **Rollen:** reviewer, architect, team-lead | **Tier:** 3
*Advocatus Diaboli, Red Teaming*
**Referenz:** Katholische Kirche (Promotor Fidei, formalisiert 1587)

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Systematic Counter-Argumentation** | Gegenpositionen einnehmen auch wenn man sie nicht persönlich vertritt |
| **Assumption Challenging** | Prämissen hinterfragen, versteckte Annahmen aufdecken |
| **Steelmanning** | Das stärkste Argument für die Gegenposition — kein Strohmann |
| **Pre-Mortem Thinking** | Szenarien des Scheiterns imaginieren bevor etwas passiert |
| **Dialectical Reasoning** | These + Antithese → Synthese |
| **Intellectual Honesty** | Idee von Ego trennen — Kritik an der Idee ist kein persönlicher Angriff |

## Wann einsetzen

- Kritische Architektur- oder Design-Entscheidungen
- Security Threat Modeling (Red Teaming)
- Code Reviews: Annahmen im Code challengen
- Hochriskante Entscheidungen wo Irrtum teuer ist

## Prompt Pattern

```
Ich schlage vor: [Idee / Design / Entscheidung].
Spiele Devil's Advocate: Was sind die stärksten Argumente GEGEN diesen Ansatz?
Steelmann die Gegenposition.
```
