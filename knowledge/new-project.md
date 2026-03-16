# Neues Projekt anlegen

## Wann diese Datei laden?
Lade diese Datei wenn ein neues Projekt gestartet werden soll.

## Phase 1: Informationssammlung

Sammle alle nötigen Informationen vom Nutzer. Du entscheidest wie du fragst –
nutze deinen eigenen Stil, mache sinnvolle Vorschläge, sei kreativ.
Fange erst mit Phase 2 an wenn ALLE Pflichtfragen beantwortet sind.

### Pflichtfragen (immer)

1. **Name** → Repo-Name (lowercase, kebab-case)
2. **Beschreibung** → ein Satz was das Projekt macht
3. **Projekttyp** → Web-App / Backend / Fullstack / CLI Tool / Library / WordPress Plugin / Mobile App / Sonstiges
4. **Tech Stack** → Sprache, Framework, Package Manager, Version
5. **Sichtbarkeit** → Public oder Private?
6. **Lizenz** → MIT / Apache / GPL / proprietär / keine

### Optionale Fragen (je nach Projekttyp vorschlagen)

**Testing:**
- Unit Tests? Welches Framework? (jest, vitest, pytest, ...)
- E2E Tests? (playwright, cypress)
- Coverage-Ziel?

**CI/CD:**
- Automatische Tests bei PR? (GitHub Actions)
- Automatisches Deployment? Wohin? (VPS, Vercel, AWS, ...)

**Code-Qualität:**
- Linter/Formatter? (ESLint, Prettier, Black, ...)
- Pre-commit Hooks?

**Security:**
- Dependabot aktivieren?
- Secret-Scanning aktivieren?
- Branch-Protection auf main?

**Docker:**
- Braucht das Projekt einen eigenen Container?
- Teil von mycoforge oder eigenständig?

### Sinnvolle Defaults je nach Projekttyp vorschlagen

Wenn der Nutzer keine Präferenz hat, schlage sinnvolle Defaults vor:

- **Web-App** → Vitest, GitHub Actions, ESLint + Prettier, Dependabot
- **Backend/API** → Jest/pytest, GitHub Actions, Dependabot
- **Fullstack** → Vitest + Playwright, GitHub Actions, ESLint + Prettier
- **CLI Tool** → Jest/pytest, GitHub Actions
- **WordPress Plugin** → PHPUnit, keine CI/CD nötig
- **Mobile App** → Jest, GitHub Actions, App Store Deployment besprechen

---

## Phase 2: Ausführung

Führe diese Schritte EXAKT in dieser Reihenfolge aus:

### 1. GitHub Repo anlegen
```bash
gh repo create <GH_USER>/<projektname> \
  --description "<beschreibung>" \
  --<public|private> \
  --license <lizenz>
```

### 2. In /workspace/ klonen
```bash
cd /workspace
git clone git@github.com:<GH_USER>/<projektname>.git
cd <projektname>
```

### 3. CLAUDE.md erstellen
```markdown
# <projektname>

<beschreibung>

## Projekttyp
<typ>

## Tech Stack
<tech stack>

## Projektstruktur
(wird beim ersten Build ergänzt)

## Testing
<testing setup>

## Deployment
<deployment info>

## Arbeitsweise
- Atomic Commits
- Keine Secrets in Git
- Tests vor jedem Commit
```

### 4. README.md erstellen
```markdown
# <projektname>

<beschreibung>

## Requirements
<voraussetzungen>

## Installation
(wird ergänzt)

## Usage
(wird ergänzt)

## License
<lizenz>
```

### 5. .gitignore erstellen
Passend zum Tech Stack – nutze gängige .gitignore Templates.

### 6. GitHub Actions einrichten (falls gewünscht)
```bash
mkdir -p .github/workflows
```
CI/CD Workflow passend zum Tech Stack erstellen.

### 7. Ersten Commit machen
```bash
git add -A
git commit -m "init: project scaffold"
git push
```

### 8. MEMORY.md aktualisieren
Neues Projekt unter "Aktive Projekte" eintragen:
```
- <projektname>: <beschreibung> → https://github.com/<GH_USER>/<projektname>
```
