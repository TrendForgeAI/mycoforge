# Per-Projekt STATE.md

## Wann laden?
Wenn eine STATE.md für ein Workspace-Projekt angelegt oder aktualisiert werden soll.

## Zweck

STATE.md ist das projektspezifische Kurzgedächtnis — unter 100 Zeilen.
Beantwortet die Frage "wo stehe ich gerade?" ohne git log lesen zu müssen.

Lebt in: `/workspace/<projekt>/STATE.md`

## Template

```markdown
# STATE — <projektname>

Zuletzt aktualisiert: <YYYY-MM-DD>

## Position

Phase/Milestone: <aktueller Stand im Projekt>
Letzter Commit:  <hash> — <message>

## Zuletzt erledigt

- <was implementiert wurde, 1 Satz pro Task>

## Nächster Schritt

<was als nächstes ansteht — konkret genug für einen direkten Start>
Befehl: /implement <aufgabe> oder /plan <feature>

## Offene Blocker

- <blocker falls vorhanden, sonst: keine>

## Entscheidungen (CONTEXT)

- <wichtige Architekturentscheidungen die nicht re-diskutiert werden sollen>
  Begründung: <warum>
```

## Wann anlegen?

- Bei Projekten mit >1 Session Aufwand
- Automatisch durch `/implement` nach umfangreicheren Tasks (>3 Dateien geändert)
- Manuell über `/pause` (erzeugt CONTINUE-HERE.md + aktualisiert STATE.md)

## Wann aktualisieren?

- Nach jedem `/implement`-Abschluss: "Zuletzt erledigt" + "Nächster Schritt"
- Nach `/discuss`-Konsens: "Entscheidungen" ergänzen
- Nach Blocker-Auflösung: Blocker entfernen

## Zusammenspiel mit anderen Mechanismen

| Mechanismus | Scope | Lebensdauer |
|---|---|---|
| MEMORY.md | mycoforge-Umgebung global | Dauerhaft |
| STATE.md | Einzelnes Workspace-Projekt | Projekt-Lebensdauer |
| CONTINUE-HERE.md | Unterbrochene Session | Bis nächster Session-Start |
| CONTEXT.md | Einzelne Architektur-Entscheidung | Bis Feature fertig |
