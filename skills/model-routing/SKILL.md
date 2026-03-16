# Model Routing

## Wann laden?
Wenn du entscheiden musst, welches Modell oder welcher Provider für einen Task
am besten geeignet ist — z.B. vor dem Starten eines Subagenten, beim Planen
von Tasks mit unterschiedlicher Komplexität, oder wenn der Nutzer fragt welches
Modell genutzt werden soll.

## Kontext

Der Router klassifiziert Tasks in drei Tiers und wählt Provider basierend auf
den in MEMORY.md vermerkten verfügbaren Providern.

**Goldene Regel:** Klein wenn möglich, Groß wenn nötig.
Die Routing-Entscheidung selbst läuft immer mit dem kleinsten verfügbaren Modell.

## Tier-Klassifikation

### Klein
Dateioperationen, Git-Befehle, einfache Edits, Suche, Config-Updates,
MEMORY.md-Aktualisierungen, Formatierungen, Routing selbst.

### Mittel
Funktionen schreiben, Bugs fixen, Tests schreiben, einfaches Refactoring
(< 3 Dateien), API-Integrationen, Code Review einzelner Features.

### Groß
Architektur entwerfen, komplexe Planung, Sicherheits-Audits, Council-Diskussionen,
großes Refactoring (> 3 Dateien), unbekannte Bugs ohne klare Hinweise.

## Provider-Modell-Tabelle

| Tier   | Anthropic         | OpenAI          | Google                |
|--------|-------------------|-----------------|-----------------------|
| Klein  | claude-haiku-4-5  | gpt-5.3-instant | gemini-3.1-flash-lite |
| Mittel | claude-sonnet-4-6 | gpt-5.4         | gemini-3-flash        |
| Groß   | claude-opus-4-6   | gpt-5.4-pro     | gemini-3.1-pro        |

## Provider-Stärken

- **Anthropic** → Reasoning, Code-Qualität, Sicherheit
- **OpenAI** → Agentic Workflows, professionelle Dokumente, Coding-Agents
- **Google** → Multimodal, große Kontextfenster, günstig bei Hochvolumen

## Vorgehen

1. MEMORY.md lesen → verfügbare Provider feststellen
2. Task analysieren → Tier bestimmen (Klein / Mittel / Groß)
3. Aufgabentyp → bevorzugten Provider wählen
4. Falls bevorzugter Provider nicht verfügbar → Fallback auf anderen verfügbaren
5. Routing-Entscheidung ausgeben

## Ausgabeformat

### Debug-Modus (DEBUG_MODE: on in MEMORY.md)

Nach jedem Agent-Einsatz oder Task-Abschluss ausgeben:

```
[🔀 <agent-name>] Tier: <Klein|Mittel|Groß> | Provider: <provider> | Modell: <modell>
                  Dauer: <Xs> | Tool-Calls: <n> | Token: ~<n> (geschätzt)
```

- **Dauer:** Zeit von Task-Start bis Task-Ende, gemessen mit `date +%s` vor/nach dem Task
- **Tool-Calls:** Anzahl der genutzten Tools (Read, Edit, Bash, Grep, ...) im Task
- **Token:** Grobe Schätzung des Kontexts (1 Token ≈ 4 Zeichen), immer als `(geschätzt)` markieren

Beispiele:
```
[🔀 developer]          Tier: Mittel | Provider: Anthropic | Modell: claude-sonnet-4-6
                        Dauer: 12s   | Tool-Calls: 4       | Token: ~2.400 (geschätzt)

[🔀 council-reviewer]   Tier: Groß   | Provider: OpenAI    | Modell: gpt-5.4-pro
                        Dauer: 8s    | Tool-Calls: 1       | Token: ~5.100 (geschätzt)

[🔀 committer]          Tier: Klein  | Provider: OpenAI    | Modell: gpt-5.3-instant
                        Dauer: 3s    | Tool-Calls: 2       | Token: ~800 (geschätzt)
```

### Normal-Modus (DEBUG_MODE: off)

Keine automatische Routing-Ausgabe. Nur bei explizitem `/route` oder wenn es
Teil des Aufgaben-Outputs ist (z.B. in `/plan` pro Task).

### Explizites `/route`

Vollständige Ausgabe mit Alternativen (immer, unabhängig von DEBUG_MODE).

## Beispiele

| Task | Tier | Provider | Modell |
|------|------|----------|--------|
| `git status` prüfen | Klein | Anthropic | claude-haiku-4-5 |
| MEMORY.md aktualisieren | Klein | OpenAI | gpt-5.3-instant |
| Funktion in Python schreiben | Mittel | Anthropic | claude-sonnet-4-6 |
| API-Integration implementieren | Mittel | OpenAI | gpt-5.4 |
| Architektur für neues System planen | Groß | Anthropic | claude-opus-4-6 |
| Council für Code Review leiten | Groß | Anthropic | claude-opus-4-6 |
| Bild analysieren und beschreiben | Mittel | Google | gemini-3-flash |
