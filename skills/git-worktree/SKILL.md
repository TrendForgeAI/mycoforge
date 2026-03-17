# git-worktree

## Wann laden?
Bei isolierter Feature-Entwicklung: wenn mehrere Features parallel laufen
oder ein Feature ohne Risiko für `main` entwickelt werden soll.

## Was ist ein Worktree?

Ein Git Worktree ist ein zweites (oder drittes) ausgechecktes Verzeichnis
desselben Repos auf einem anderen Branch — gleichzeitig, ohne Stash-Chaos.

```
/workspace/mein-projekt/           ← main (stabil)
/workspace/mein-projekt-feature-x/ ← feature/x (in Arbeit)
/workspace/mein-projekt-fix-y/     ← fix/y (parallel dazu)
```

Beide teilen denselben `.git`-Ordner — Commits, History, Branches sind synchron.

## Wann Worktree, wann Stash?

| Situation | Empfehlung |
|-----------|-----------|
| Kurze Unterbrechung (< 30 Min) | `git stash` |
| Feature dauert Tage / Wochen | Worktree |
| Hotfix während Feature in Arbeit | Worktree |
| Paralleles Testen zweier Ansätze | Worktree |
| Review eines anderen Branches | Worktree |

## Operationen

### Neuen Worktree anlegen

```bash
# Format: git -C <repo-pfad> worktree add <worktree-pfad> <branch>
# Branch wird automatisch angelegt wenn er noch nicht existiert

# Beispiel: Feature-Branch
git -C /workspace/mein-projekt worktree add \
    /workspace/mein-projekt-feature-x \
    feature/x

# Beispiel: Hotfix
git -C /workspace/mein-projekt worktree add \
    /workspace/mein-projekt-fix-login \
    fix/login-bug
```

**Für mycoforge selbst:**
```bash
git -C /mycoforge worktree add \
    /mycoforge-<feature> \
    feature/<feature>
```

### Aktive Worktrees anzeigen

```bash
git -C /workspace/mein-projekt worktree list
```

Ausgabe:
```
/workspace/mein-projekt           abc1234 [main]
/workspace/mein-projekt-feature-x def5678 [feature/x]
```

### Im Worktree arbeiten

Normales Arbeiten — alle git-Kommandos funktionieren im Worktree-Verzeichnis:
```bash
cd /workspace/mein-projekt-feature-x
# ... entwickeln, committen, pushen
git add src/feature.ts
git commit -m "feat(x): implement core logic"
git push -u origin feature/x
```

### Worktree entfernen (nach Merge)

```bash
# 1. Branch mergen (in main)
git -C /workspace/mein-projekt checkout main
git -C /workspace/mein-projekt merge feature/x

# 2. Worktree-Verzeichnis entfernen
git -C /workspace/mein-projekt worktree remove /workspace/mein-projekt-feature-x

# 3. Remote Branch aufräumen (optional)
git -C /workspace/mein-projekt push origin --delete feature/x
```

### Worktree zwangs-entfernen (uncommitted changes)

```bash
git -C /workspace/mein-projekt worktree remove --force /workspace/mein-projekt-feature-x
```

## Namenskonvention

| Typ | Verzeichnis | Branch |
|-----|-------------|--------|
| Feature | `/workspace/<projekt>-<feature>` | `feature/<feature>` |
| Bugfix | `/workspace/<projekt>-fix-<name>` | `fix/<name>` |
| Experiment | `/workspace/<projekt>-exp-<name>` | `exp/<name>` |

## Prinzipien

- Worktrees immer aus dem Haupt-Repo-Verzeichnis erstellen (nicht aus anderen Worktrees)
- Nach dem Merge sofort aufräumen — verwaiste Worktrees verwirren
- Worktree-Pfade nie in `.gitignore` oder Git-History schreiben
- Ein Worktree pro Feature — kein Worktree für mehrere unabhängige Aufgaben
