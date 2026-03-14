# Verfügbare Modelle & Routing

## Wann diese Datei laden?
Lade diese Datei wenn du eine Entscheidung treffen musst, welches Modell/Provider
für eine Aufgabe genutzt werden soll.

## Routing-Entscheidung

Das kleinste verfügbare Modell (bevorzugt claude-haiku-4-5 oder gpt-5.3-instant)
analysiert die Aufgabe und wählt Provider + Modell nach diesen Kriterien:
1. Aufgabentyp (Planung / Code / Dateiop)
2. Verfügbare Provider (siehe MEMORY.md)
3. Provider-Stärke für diese Aufgabe
4. Kostenpräferenz (klein wenn möglich, groß wenn nötig)

## Anthropic
| Tier   | Modell            | Einsatz |
|--------|-------------------|---------|
| Groß   | claude-opus-4-6   | Planung, Architektur, komplexe Zusammenhänge |
| Mittel | claude-sonnet-4-6 | Code schreiben, Reviews |
| Klein  | claude-haiku-4-5  | Dateioperationen, einfache Edits, Routing |

## OpenAI
| Tier   | Modell          | Einsatz |
|--------|-----------------|---------|
| Groß   | gpt-5.4-pro     | Komplexe Analysen, Planung |
| Mittel | gpt-5.4         | Code, professionelle Workflows |
| Klein  | gpt-5.3-instant | Schnelle einfache Aufgaben |

## Google
| Tier   | Modell                | Einsatz |
|--------|-----------------------|---------|
| Groß   | gemini-3.1-pro        | Komplexe Reasoning-Aufgaben |
| Mittel | gemini-3-flash        | Multimodale Aufgaben |
| Klein  | gemini-3.1-flash-lite | Hochvolumen, günstige Aufgaben |

## Provider-Stärken

- **Anthropic** → Reasoning, Code-Qualität, Sicherheit
- **OpenAI** → Coding-Agents, professionelle Dokumente
- **Google** → Multimodal, große Kontextfenster, günstig bei hohem Volumen
