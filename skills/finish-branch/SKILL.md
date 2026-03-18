# finish-branch

## Wann laden?
Wenn ein Feature- oder Bugfix-Branch abgeschlossen werden soll —
nach Fertigstellung der Implementierung, bevor der Branch gelöscht wird.

## Vorgehen

### 1. Tests prüfen

Vor allen anderen Schritten Tests ausführen:

```bash
# Im aktuellen Verzeichnis (Worktree oder Main-Repo)
npm test 2>&1 || npx vitest run 2>&1 || pytest 2>&1 || go test ./... 2>&1
```

Bei Testfehlern:
- Fehler anzeigen
- Nutzer fragen ob beheben oder trotzdem fortfahren

### 2. Uncommitted Changes prüfen

```bash
git status
git diff --stat
```

Falls uncommitted Changes vorhanden: erst committen oder stashen.

### 3. Branch-Zusammenfassung

Zeige was auf dem Branch gemacht wurde:

```bash
git log main..HEAD --oneline 2>/dev/null || git log --oneline -10
git diff main...HEAD --stat 2>/dev/null
```

### 4. Optionen präsentieren

Zeige dem Nutzer exakt diese 4 Optionen (AskUserQuestion):

| Option | Beschreibung |
|--------|--------------|
| Lokal mergen | Branch in main mergen, Branch-Ref löschen |
| Pull Request öffnen | PR auf GitHub erstellen, Branch behalten |
| Branch behalten | Nichts weiter tun, Branch bleibt bestehen |
| Branch verwerfen | Alle Änderungen verwerfen und Branch löschen |

### 5. Ausführen

#### Option A — Lokal mergen

```bash
# Aktuellen Branch merken
BRANCH=$(git branch --show-current)

# Zu main wechseln
git checkout main
git pull origin main

# Mergen
git merge --no-ff "$BRANCH" -m "merge: $BRANCH"

# Branch löschen
git branch -d "$BRANCH"

# Falls Worktree: Worktree entfernen
# git worktree remove <worktree-pfad>
```

#### Option B — Pull Request

```bash
BRANCH=$(git branch --show-current)
git push -u origin "$BRANCH"
gh pr create --fill
```

Danach PR-URL anzeigen, Branch behalten.

#### Option C — Behalten

Keine Aktion. Branch und Worktree bleiben bestehen.
Kurze Zusammenfassung ausgeben wo der Branch ist.

#### Option D — Verwerfen

**ACHTUNG: Alle Änderungen gehen verloren.**

Sicherheitsbestätigung einholen — Nutzer muss explizit "verwerfen" tippen:

```
Um alle Änderungen zu verwerfen, tippe: verwerfen
```

Erst nach Bestätigung:

```bash
BRANCH=$(git branch --show-current)

# Zu main wechseln
git checkout main

# Branch force-löschen (uncommitted work geht verloren)
git branch -D "$BRANCH"

# Falls Worktree vorhanden
git worktree list
# git worktree remove <pfad> --force
```

### 6. Worktree aufräumen (falls vorhanden)

Nach Merge oder Verwerfen:

```bash
git worktree list
# Nicht mehr benötigte Worktrees entfernen
git worktree remove <pfad>
```

## Ausgabe nach Abschluss

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Branch: <branch-name>
  Aktion: <Gemergt | PR #N erstellt | Behalten | Verworfen>
  Tests:  <✅ grün | ⚠ Warnungen | ❌ Fehlgeschlagen>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Nach Merge zu main einmalig ausgeben (kein Pflichtschritt):

```
Neues Release fällig? → /release
```
