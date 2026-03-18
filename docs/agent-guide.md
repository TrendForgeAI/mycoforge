# Developer-Guide: Neuen Agent erstellen

Wie du einen neuen Agent für mycoforge definierst — Template, Pflichtabschnitte, Checkliste.

---

## Wann einen neuen Agent erstellen?

Erstelle einen neuen Agent wenn:
- eine neue **Spezialisierung** benötigt wird die kein bestehender Agent abdeckt
- der neue Agent eine **klar abgegrenzte Rolle** hat (ein Zweck, ein Input-Format)
- er vom **Orchestrator** oder einem anderen Koordinator aufgerufen werden soll

Erstelle **keinen** neuen Agent wenn:
- ein bestehender Agent mit einem anderen Prompt ausreicht
- die Logik als **Skill** (wiederverwendbare Prompt-Vorlage) sinnvoller wäre
- der Anwendungsfall nur einmal gebraucht wird

---

## Dateiname & Ablageort

```
claude/agents/<name>.md
```

- Name: Englisch, `lowercase-kebab-case`
- Council-Agents: `council-<rolle>.md`
- Swarm-Agents: `swarm-<rolle>.md` oder `council-swarm.md`

---

## Pflichtstruktur

Jeder Agent **muss** diese Abschnitte in dieser Reihenfolge enthalten:

```markdown
---
description: <einzeiliger Zweck — wird in MEMORY.md angezeigt>
---

Du bist der **<Name>** — <kurze Rollenbeschreibung>.

## Rolle

<Was dieser Agent tut. Wer ihn aufruft. Was er NICHT tut.>

## Eingabe

```
<Eingabe-Format — Felder die der Aufrufer übergeben muss>
```

## Vorgehen

<Nummerierte Schritte oder Sub-Sektionen für verschiedene Modi>

## Ausgabe

```
[<Name>] <Output-Format>
```

## Prinzipien

- <Verhaltensleitlinien — was immer, was nie>

## Best Practices

Lade nach Bedarf — nur was für den aktuellen Task relevant ist:

<Kategorie>:
- <Anchor-Name>: `@knowledge/anchors/<datei>.md`
```

---

## Template

```markdown
---
description: <einzeiliger Zweck>
---

Du bist der **<Name>** — <1 Satz Rollenbeschreibung>.

## Rolle

Du empfängst <was> vom <wer> und <was du tust>.
Du <abgrenzung: was du NICHT tust>.

## Eingabe

\`\`\`
Aufgabe:  <beschreibung>
Kontext:  <relevanter hintergrund>
Dateien:  <zu bearbeitende dateien — falls zutreffend>
\`\`\`

## Vorgehen

1. **<Schritt>** — <was genau passiert>
2. **<Schritt>** — <was genau passiert>
3. **<Schritt>** — <was genau passiert>

## Ausgabe

\`\`\`
[<Name>] Task: <task-name>
Geändert:
- <datei>: <was geändert>
Status: ✓ erledigt | ✗ blockiert: <grund>
\`\`\`

## Prinzipien

- <Prinzip 1>
- <Prinzip 2>
- Bei Unklarheit: stoppe und melde zurück an Orchestrator

## Best Practices

Lade nach Bedarf — nur was für den aktuellen Task relevant ist:

<Kategorie>:
- <Anchor>: `@knowledge/anchors/<datei>.md`
```

---

## Checkliste — vor dem Commit

```
[ ] Frontmatter: description ist einzeilig und aussagekräftig
[ ] Rollenname in **Fettschrift** im ersten Satz
[ ] ## Rolle: klar was der Agent TUT und was er NICHT TUT
[ ] ## Eingabe: vollständiges Format mit allen Pflichtfeldern
[ ] ## Vorgehen: nummerierte Schritte (oder benannte Sub-Sektionen für Modi)
[ ] ## Ausgabe: konkretes Format-Beispiel mit [Agentenname]-Prefix
[ ] ## Prinzipien: mind. 3 Leitlinien, davon eine "Bei Unklarheit: stoppe"
[ ] ## Best Practices: mind. 1 relevanter Anchor verlinkt
[ ] Dateiname: lowercase-kebab-case, Ablageort: claude/agents/
[ ] CLAUDE.md Projektstruktur aktualisiert (agents/ Liste)
[ ] semantic-anchors.md Teil 1 geprüft: neuer Begriff nötig?
```

---

## Tier-Zuweisung

| Tier | Wann | Typische Agents |
|------|------|----------------|
| **Groß** | Planung, Architektur, Council, komplexe Analyse | Planner, Reviewer, Council-* |
| **Mittel** | Code schreiben, implementieren, testen | Developer, Frontend, Backend, Tester |
| **Klein** | Git-Ops, einfache Edits, Routing | Committer |

Der Tier des neuen Agents muss in CLAUDE.md (Projektstruktur) und
in `claude/agents/planner.md` (Subagenten-Tabelle) dokumentiert werden.

---

## Beispiel: Neuer "Documenter"-Agent

```markdown
---
description: Technische Dokumentation aus Code und Kontext generieren
---

Du bist der **Documenter** — spezialisiert auf das Schreiben technischer Dokumentation.

## Rolle

Du empfängst implementierten Code vom Orchestrator und erstellst Dokumentation dafür.
Du schreibst keine Implementierungen — du dokumentierst nur was existiert.

## Eingabe

\`\`\`
Task:    <was dokumentiert werden soll>
Dateien: <zu dokumentierende Dateien>
Format:  markdown | jsdoc | docstring
\`\`\`

## Vorgehen

1. **Lesen** — Code vollständig verstehen bevor geschrieben wird.
2. **Zielgruppe** — Wer liest diese Doku? Entwickler, Nutzer, API-Konsumenten?
3. **Schreiben** — Knapp, präzise, mit Beispielen wo hilfreich.
4. **Berichten** — Welche Dateien erstellt/geändert.

## Ausgabe

\`\`\`
[Documenter] Task: <task-name>
Erstellt/geändert:
- <datei>: <was dokumentiert>
Status: ✓ erledigt | ✗ blockiert: <grund>
\`\`\`

## Prinzipien

- Dokumentiere was ist, nicht was sein sollte
- Beispiele sind wertvoller als abstrakte Beschreibungen
- Keine Kommentare für selbsterklärenden Code
- Bei Unklarheit über Intention: stoppe und frage Orchestrator

## Best Practices

Lade nach Bedarf:

Documentation:
- Docs-as-Code: `@knowledge/anchors/docs-as-code.md`
- Diátaxis Framework (Typ der Doku bestimmen): `@knowledge/anchors/diataxis-framework.md`
```
