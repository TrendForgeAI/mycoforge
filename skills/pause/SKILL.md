# /pause — Session-Zustand sichern

Speichere den aktuellen Session-Zustand damit die nächste Session nahtlos fortsetzen kann.

## Wann einsetzen?

- Kontext-Warnung erscheint (Context Rot)
- Session bewusst beenden aber Arbeit fortführen wollen
- Längere Unterbrechung bei laufender Aufgabe

## Vorgehen

### 1. Zustand analysieren

Prüfe:
- Welche Aufgabe ist in Bearbeitung?
- Was wurde erledigt, was steht noch aus?
- Welche Dateien wurden geändert (noch nicht committed)?
- Gibt es offene Entscheidungen oder Blockaden?

### 2. CONTINUE-HERE.md schreiben

Erstelle oder aktualisiere `/mycoforge/CONTINUE-HERE.md`:

```markdown
# CONTINUE HERE

Erstellt: <datum uhrzeit>

## Aufgabe

<was gerade in Bearbeitung ist — ein Satz>

## Status

<was fertig ist>
- [x] <erledigte schritte>

<was noch aussteht>
- [ ] <nächster schritt> ← HIER WEITERMACHEN
- [ ] <folgeschritte>

## Kontext

<wichtige Entscheidungen, Hintergründe, Abhängigkeiten — 3-5 Sätze>

## Geänderte Dateien (uncommitted)

<liste der uncommitted changes, oder "keine">

## Nächste Aktion

<konkreter erster schritt für die nächste Session — ein Satz>
```

### 3. WIP-Commit (falls uncommitted Changes vorhanden)

Falls es uncommitted Änderungen gibt:

```bash
git add <geänderte dateien>
git commit -m "wip: <kurze beschreibung des stands>"
```

Kein WIP-Commit wenn nichts geändert wurde.

### 4. Bestätigung

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Session gesichert
  Aufgabe: <aufgabe>
  Status:  <erledigte schritte>/<gesamt> Schritte
  Datei:   CONTINUE-HERE.md
  <WIP-Commit: <hash> — wip: <nachricht> | kein WIP-Commit nötig>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Beim nächsten Start zeigt dir der Session-Hook automatisch wo du weitermachst.
```

## Hinweis

CONTINUE-HERE.md wird beim nächsten Session-Start automatisch angezeigt
und nach der Bestätigung gelöscht.
