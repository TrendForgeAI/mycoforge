---
description: Neues Release erstellen — Version bestimmen, Tag setzen, GitHub Release veröffentlichen
argument-hint: [version z.B. 0.2.0 oder 0.2.0-rc.1]
---

Lade `skills/release/SKILL.md` und erstelle ein neues Release.

**Gewünschte Version:** $ARGUMENTS

## Vorgehen

### 1. Aktuellen Stand prüfen

```bash
# Letzten Tag ermitteln
git tag -l "v[0-9]*.[0-9]*.[0-9]*" | sort -V | tail -1

# Commits seit letztem Tag
LAST_TAG=$(git tag -l "v[0-9]*.[0-9]*.[0-9]*" | sort -V | tail -1)
git log "${LAST_TAG}..HEAD" --oneline

# Uncommitted Changes prüfen
git status
```

Falls uncommitted Changes vorhanden: **Stopp** — erst committen, dann Release.

### 2. Version bestimmen

Falls $ARGUMENTS leer:
- Aktuelle Version und Commits seit letztem Tag anzeigen
- Nutzer per AskUserQuestion fragen:

| Option | Beschreibung |
|--------|--------------|
| Patch (x.y.Z+1) | Bugfixes, kleine Korrekturen |
| Minor (x.Y+1.0) | Neue Features, rückwärtskompatibel |
| Major (X+1.0.0) | Breaking Changes |

Dann State wählen:

| Option | Beschreibung |
|--------|--------------|
| stable | Produktionsreif, vollständig getestet |
| rc.1   | Release Candidate — nur noch Bugfixes |
| beta.1 | Feature-complete, wird getestet |
| alpha.1 | Frühe Entwicklung, instabil |

### 3. Doppel-Tag-Guard (PFLICHT)

```bash
TAG="v$VERSION"
if git tag -l "$TAG" | grep -q . || git ls-remote --tags origin "refs/tags/$TAG" | grep -q .; then
  echo "❌ Tag $TAG existiert bereits (lokal oder remote). Abbrechen."
  exit 1
fi
```

Bei Fund: Nutzer informieren und abbrechen. Niemals überschreiben.
Der Guard prüft **lokal und remote** — kein Durchrutschen nach frischem Clone.

### 4. Changelog generieren

```bash
LAST_TAG=$(git tag -l "v[0-9]*.[0-9]*.[0-9]*" | sort -V | tail -1)
RANGE="${LAST_TAG}..HEAD"

git log $RANGE --pretty="format:%s" | grep "^feat"
git log $RANGE --pretty="format:%s" | grep "^fix"
git log $RANGE --pretty="format:%s" | grep "^refactor"
git log $RANGE --pretty="format:%s" | grep -vE "^(feat|fix|refactor)"
```

Changelog im Format aus `skills/release/SKILL.md` aufbereiten.
Zeige Changelog dem Nutzer und bestätige bevor Tag gesetzt wird.

### 5. Release erstellen

```bash
TAG="v$VERSION"

# Annotated Tag setzen
git tag -a "$TAG" -m "$TAG — $TITLE"
git push origin "$TAG"

# Pre-release automatisch erkennen
if echo "$TAG" | grep -qE "\-(alpha|beta|rc)"; then
  PRERELEASE_FLAG="--prerelease"
else
  PRERELEASE_FLAG=""
fi

# GitHub Release
gh release create "$TAG" \
  --title "$TAG — $TITLE" \
  --notes "$CHANGELOG" \
  $PRERELEASE_FLAG
```

### 6. Abschluss

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Release: <tag>
  State:   <Stable | Pre-release (alpha|beta|rc)>
  Tag:     <commit-hash>
  URL:     <github-release-url>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
