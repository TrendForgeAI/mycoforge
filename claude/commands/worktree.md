---
description: Git Worktree für isolierte Feature-Entwicklung anlegen, auflisten oder entfernen
argument-hint: new <feature> | list | remove <feature>
---

Lade `skills/git-worktree/SKILL.md` und führe die gewünschte Worktree-Operation durch.

**Eingabe:** $ARGUMENTS

## Operationen

### `new <feature>` — Neuen Worktree anlegen

1. Aktuelles Projekt bestimmen (Verzeichnis in dem gearbeitet wird)
2. Worktree anlegen nach Namenskonvention aus SKILL.md
3. Ausgabe:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Worktree angelegt
  Branch:     feature/<feature>
  Verzeichnis: <pfad>
  Weiter:     cd <pfad> und dort entwickeln
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### `list` — Aktive Worktrees anzeigen

```bash
git worktree list
```

Formatierte Ausgabe aller aktiven Worktrees mit Branch und Pfad.

### `remove <feature>` — Worktree entfernen

1. Prüfen ob uncommitted Changes vorhanden (warnen falls ja)
2. Prüfen ob Branch gemergt wurde (warnen falls nein)
3. `git worktree remove <pfad>`
4. Optional: Remote Branch löschen (nachfragen)

Ausgabe:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Worktree entfernt
  Branch:      feature/<feature>
  Verzeichnis: <pfad> (gelöscht)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
