# Verfügbare Modelle & Routing

## Wann diese Datei laden?
Lade diese Datei wenn du eine Erklärung zum Routing-System brauchst.
Für die **kanonischen Modellnamen und Tier-Definitionen** lies stattdessen:
→ `config/model-routing.yaml`

---

## Routing-Prinzip

Das kleinste verfügbare Modell analysiert die Aufgabe und wählt Provider + Modell.
Goldene Regel: **Klein wenn möglich, Groß wenn nötig.**

Drei Tiers: `small` → `medium` → `large`
Definitionen und Modellnamen: siehe `config/model-routing.yaml`

---

## Provider-Stärken

- **Anthropic** → Reasoning, Code-Qualität, Sicherheit
- **OpenAI** → Agentic Workflows, Coding-Agents, professionelle Dokumente
- **Google** → Multimodal, große Kontextfenster, günstig bei hohem Volumen

Präferenzen pro Aufgabentyp: siehe `preferences` in `config/model-routing.yaml`

---

## Verfügbare Provider

Aktiv verfügbare Provider und Modelle stehen in `MEMORY.md` (wird beim Start generiert).
