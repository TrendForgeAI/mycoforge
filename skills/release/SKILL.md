# release

## Wann laden?
Wenn ein neues Release erstellt werden soll — d.h. wenn `/release` aufgerufen wird
oder wenn nach einem Merge zu main gefragt wird ob eine neue Version veröffentlicht werden soll.

---

## Versionierungsschema

mycoforge verwendet **Semantic Versioning (SemVer)**:

```
v MAJOR . MINOR . PATCH
  │       │       └─ Bugfix / kleine Korrektur — kein API-Bruch
  │       └─ Neue Funktion — rückwärtskompatibel
  └─ Breaking Change — inkompatible Änderung
```

Solange MAJOR = 0: Minor-Bumps für neue Features, Patch für Fixes.

---

## Pre-Release-States

```
v0.2.0-alpha.1   frühe Entwicklung, instabil, aktiv geändert
v0.2.0-beta.1    feature-complete, wird getestet
v0.2.0-rc.1      Release Candidate — nur noch Bugfixes
v0.2.0           Stable Release
```

**Wann welchen State wählen:**

| State  | Wann |
|--------|------|
| alpha  | P0/P1-Issues noch offen, Milestone läuft |
| beta   | Alle Features fertig, Stabilisierung |
| rc     | Bereit für Release, nur noch Bugfixes erlaubt |
| stable | Vollständig getestet, kein offener kritischer Bug |

GitHub markiert alpha/beta/rc automatisch als **Pre-release**.

---

## Pflicht: Doppel-Tag-Guard

Vor jedem Tag-Schritt MUSS geprüft werden ob der Tag bereits existiert:

```bash
TAG="v$VERSION"
if git tag -l "$TAG" | grep -q .; then
  echo "❌ Tag $TAG existiert bereits. Abbrechen."
  exit 1
fi
```

Ohne diese Prüfung niemals fortfahren.

---

## Aktuelle Version ermitteln

```bash
# Letzten SemVer-Tag finden (sortiert nach Version)
git tag -l "v[0-9]*.[0-9]*.[0-9]*" | sort -V | tail -1
```

Falls kein Tag: v0.0.0 als Basis annehmen.

---

## Changelog generieren

Aus Conventional Commits seit dem letzten Tag:

```bash
LAST_TAG=$(git tag -l "v[0-9]*.[0-9]*.[0-9]*" | sort -V | tail -1)

# Nach Typ gruppieren
git log "${LAST_TAG}..HEAD" --pretty="format:%s" | grep "^feat"     # Features
git log "${LAST_TAG}..HEAD" --pretty="format:%s" | grep "^fix"      # Bugfixes
git log "${LAST_TAG}..HEAD" --pretty="format:%s" | grep "^refactor" # Refactoring
git log "${LAST_TAG}..HEAD" --pretty="format:%s" | grep "^docs"     # Docs
git log "${LAST_TAG}..HEAD" --pretty="format:%s" | grep "^chore"    # Chores
```

**Changelog-Format für GitHub Release:**

```markdown
## What's Changed

### Features
- feat(scope): beschreibung

### Bug Fixes
- fix(scope): beschreibung

### Refactoring
- refactor(scope): beschreibung

### Chores & Docs
- chore/docs(scope): beschreibung

**Full Changelog:** https://github.com/TrendForgeAI/mycoforge/compare/vX.Y.Z...vA.B.C
```

---

## Tag erstellen und pushen

```bash
VERSION="0.2.0"          # oder "0.2.0-rc.1" etc.
TAG="v$VERSION"
MESSAGE="v$VERSION — <Titel>"

# Annotated Tag (enthält Metadaten + Signatur)
git tag -a "$TAG" -m "$MESSAGE"
git push origin "$TAG"
```

Nur annotated Tags verwenden — lightweight Tags haben keine Metadaten.

---

## GitHub Release erstellen

```bash
TAG="v0.2.0"
TITLE="v0.2.0 — Operational Hardening"
NOTES="..."   # generierter Changelog

# Stable Release
gh release create "$TAG" --title "$TITLE" --notes "$NOTES"

# Pre-release (alpha/beta/rc)
gh release create "$TAG" --title "$TITLE" --notes "$NOTES" --prerelease
```

Pre-release automatisch erkennen:
```bash
if echo "$TAG" | grep -qE "\-(alpha|beta|rc)"; then
  PRERELEASE_FLAG="--prerelease"
else
  PRERELEASE_FLAG=""
fi
gh release create "$TAG" --title "$TITLE" --notes "$NOTES" $PRERELEASE_FLAG
```

---

## Ausgabe nach Abschluss

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Release: v0.2.0-rc.1
  State:   Pre-release (rc)
  Tag:     09ab3f2
  URL:     https://github.com/TrendForgeAI/mycoforge/releases/tag/v0.2.0-rc.1
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
