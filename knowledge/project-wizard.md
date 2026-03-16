# Project Wizard

## Wann laden?
Wenn ein neues Projekt gestartet werden soll.

---

## Wizard Steps Übersicht

```
Phase 1   Pflichtfragen   Steps 1–6    Name · Beschreibung · Typ · Stack · Sichtbarkeit · Lizenz
Phase 1b  Optional        Blocks A–E   Testing · CI/CD · Code-Qualität · Security · Docker
Phase 2   Ausführung      Steps 1–10   Automatisch
```

---

## Fragetypen

- **Freitext** → Direkt im Chat fragen, Antwort abwarten
- **Auswahl** → AskUserQuestion verwenden

---

## Step-Header Regel

Vor jedem Step/Block ausgeben:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  <Phase>   <Dots>   <N/Total>   <Titel>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
Dots Phase 1: `●○○○○○` → `●●●●●●`
Dots Phase 1b: `●○○○○` → `●●●●●`

---

## Einstieg

```
> "Neues Projekt — ich führe dich Schritt für Schritt durch die Einrichtung.
>  Erst sammle ich alle Infos, dann lege ich alles automatisch an."
```

---

## Phase 1 — Pflichtfragen

---

### Step 1 — Name `●○○○○○`

**Freitext:** "Wie soll das Projekt heißen?"

- Zielformat: `lowercase-kebab-case`
- Auto-Konvertierung: `My Cool Tool` → `my-cool-tool`
- Nur a–z, 0–9, Bindestrich erlaubt
- Konvertiertes Ergebnis bestätigen

---

### Step 2 — Beschreibung `●●○○○○`

**Freitext:** "Ein Satz: Was macht das Projekt?"

- Wird in GitHub, README und CLAUDE.md verwendet
- Bei sehr langem oder unklarem Satz: Verbesserung vorschlagen

---

### Step 3 — Projekttyp `●●●○○○`

**AskUserQuestion** (4 Optionen + Other):

| Option | Description |
|--------|-------------|
| Web-App | React, Vue, Svelte, ... |
| Backend / API | REST, GraphQL, gRPC, ... |
| Fullstack | Frontend + Backend in einem Repo |
| CLI Tool | Kommandozeilen-Werkzeug |

Other → Folgefrage: Library · WordPress Plugin · Mobile App · Sonstiges

Gemerkter Typ steuert Defaults in Phase 1b.

---

### Step 4 — Tech Stack `●●●●○○`

Vorschlag passend zum Typ ausgeben:

| Typ | Vorschlag |
|-----|-----------|
| Web-App | TypeScript · React · npm · Node 22 LTS |
| Backend / API | TypeScript · Express/Fastify · npm · Node 22 LTS  –oder–  Python · FastAPI · uv · Python 3.13 |
| Fullstack | TypeScript · Next.js · npm · Node 22 LTS |
| CLI Tool | TypeScript · Node 22 LTS  –oder–  Python · uv · Python 3.13 |
| Library | TypeScript · npm  –oder–  Python · uv |
| WordPress Plugin | PHP 8.3 · Composer |
| Mobile App | TypeScript · React Native · npm · Node 22 LTS |

**AskUserQuestion** (2 Fragen gleichzeitig):

- **Sprache:** TypeScript | Python | PHP | Other
- **Package Manager:** npm / pnpm | yarn | uv / pip | Other

Runtime ableiten: Node 22 LTS · Python 3.13 · PHP 8.3
Framework nachfragen wenn nicht eindeutig.

---

### Step 5 — Sichtbarkeit `●●●●●○`

**AskUserQuestion:**

| Option | Description |
|--------|-------------|
| Public | Open Source, für alle sichtbar |
| Private | Nur für dich / dein Team |

---

### Step 6 — Lizenz `●●●●●●`

**AskUserQuestion** (+ Other für proprietär):

| Option | Description |
|--------|-------------|
| MIT | Permissiv — Recommended bei Public |
| Apache 2.0 | Permissiv + Patentschutz |
| GPL v3 | Copyleft |
| keine | Kein Lizenz-File — Recommended bei Private |

---

### Zwischenstand

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Name:         <name>
  Beschreibung: <beschreibung>
  Typ:          <typ>
  Stack:        <stack>
  Sichtbarkeit: <public|private>
  Lizenz:       <lizenz>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**AskUserQuestion:**

| Option | Description |
|--------|-------------|
| Weiter mit optionalen Einstellungen | Testing, CI/CD, Code-Qualität, Security, Docker |
| Direkt anlegen | Optional überspringen, sofort loslegen |

---

## Phase 1b — Optionale Einstellungen

---

### Block A — Testing `●○○○○`

Defaults passend zum Typ:

| Typ | Unit | E2E | Coverage |
|-----|------|-----|----------|
| Web-App | Vitest | Playwright | 80 % |
| Backend / API | Jest / pytest | — | 80 % |
| Fullstack | Vitest | Playwright | 80 % |
| CLI Tool | Jest / pytest | — | 70 % |
| Library | Vitest / pytest | — | 90 % |
| WordPress Plugin | PHPUnit | — | — |
| Mobile App | Jest | — | 70 % |

**AskUserQuestion:**

| Option | Description |
|--------|-------------|
| Defaults übernehmen | Vorschlag verwenden |
| Anpassen | Eigene Frameworks / Coverage wählen |

Bei Anpassen: einzeln nachfragen (Unit · E2E · Coverage-Ziel).

---

### Block B — CI/CD `●●○○○`

**AskUserQuestion** (2 Fragen gleichzeitig):

- **GitHub Actions bei PR?** Ja | Nein  _(Default: Ja)_
- **Automatisches Deployment?** Nein | Vercel | VPS | Other  _(Default: Nein; bei Web-App: Vercel zuerst)_

---

### Block C — Code-Qualität `●●●○○`

**AskUserQuestion** (2 Fragen gleichzeitig):

- **Linter / Formatter:** ESLint + Prettier | Ruff | PHP_CodeSniffer | Other
- **Pre-commit Hooks?** Ja | Nein

---

### Block D — Security `●●●●○`

Default: alle Ja bei Public · alle Nein bei Private

**AskUserQuestion** (3 Fragen gleichzeitig):

- **Dependabot?** Ja | Nein
- **Secret-Scanning?** Ja | Nein
- **Branch-Protection auf main?** Ja | Nein

---

### Block E — Docker `●●●●●`

**AskUserQuestion:**

| Option | Description |
|--------|-------------|
| Kein Docker | Kein eigener Container |
| Eigenständiger Container | Eigenes Dockerfile / docker-compose |
| Teil von mycoforge | In mycoforge-Container integriert |

---

### Finale Zusammenfassung

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Name:          <name>
  Beschreibung:  <beschreibung>
  Typ:           <typ>
  Stack:         <stack>
  Sichtbarkeit:  <public|private>
  Lizenz:        <lizenz>

  Testing:       <unit> / <e2e> / Coverage <x>%
  CI/CD:         GitHub Actions <J/N> / Deploy → <ziel|nein>
  Code-Qualität: <linter> / Pre-commit <J/N>
  Security:      Dependabot <J/N> · Secrets <J/N> · Branch-Protection <J/N>
  Docker:        <option>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**AskUserQuestion:**

| Option | Description |
|--------|-------------|
| Jetzt anlegen | Phase 2 starten |
| Änderungen vornehmen | Zurück zu den Fragen |

---

## Phase 2 — Ausführung

Status nach jedem Schritt: `✓ Erledigt` oder `✗ Fehler: <Ursache>`

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Ausführung — 10 Schritte
  [ ] 1  GitHub Repo anlegen
  [ ] 2  Klonen
  [ ] 3  CLAUDE.md
  [ ] 4  README.md
  [ ] 5  .gitignore
  [ ] 6  GitHub Actions
  [ ] 7  Dependabot
  [ ] 8  Branch-Protection
  [ ] 9  Erster Commit + Push
  [ ] 10 MEMORY.md aktualisieren
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### Step 1 — GitHub Repo

```bash
gh repo create TrendForgeAI/<name> \
  --description "<beschreibung>" \
  --<public|private> \
  --license <lizenz|"">
```

Bei Fehler: abbrechen.

---

### Step 2 — Klonen

```bash
git clone https://github.com/TrendForgeAI/<name>.git /workspace/<name>
```

---

### Step 3 — CLAUDE.md

```markdown
# <name>

<beschreibung>

## Projekttyp
<typ>

## Tech Stack
<stack>

## Projektstruktur
(wird beim ersten Build ergänzt)

## Testing
<unit-framework> · <e2e-framework|—> · Coverage <x>%

## CI/CD
GitHub Actions: <J/N>
Deployment: <ziel|nein>

## Code-Qualität
<linter> · Pre-commit Hooks: <J/N>

## Arbeitsweise
- Atomic Commits
- Keine Secrets in Git
- Tests vor jedem Commit
```

---

### Step 4 — README.md

```markdown
# <name>

<beschreibung>

## Requirements
<Node 22+ | Python 3.13+ | PHP 8.3+>

## Installation
(wird ergänzt)

## Usage
(wird ergänzt)

## License
<lizenz>
```

---

### Step 5 — .gitignore

| Stack | Kern |
|-------|------|
| Node.js | `node_modules/` `dist/` `.env` `.env.local` `*.log` |
| Python | `__pycache__/` `*.pyc` `.venv/` `dist/` `.env` `*.egg-info/` |
| PHP | `vendor/` `.env` `*.log` |
| Go | `/bin/` `*.exe` `.env` |
| Rust | `/target/` `.env` |

Immer ergänzen: `.DS_Store` `Thumbs.db` `.idea/` `.vscode/` (außer `settings.json`)

---

### Step 6 — GitHub Actions (falls gewählt)

`mkdir -p .github/workflows` → `ci.yml` passend zum Stack erstellen.

Beispiel Node.js:
```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: npm
      - run: npm ci
      - run: npm test
```

---

### Step 7 — Dependabot (falls gewählt)

`.github/dependabot.yml`:
```yaml
version: 2
updates:
  - package-ecosystem: "<npm|pip|composer|cargo|gomod>"
    directory: "/"
    schedule:
      interval: weekly
```

---

### Step 8 — Branch-Protection (falls gewählt)

```bash
gh api repos/TrendForgeAI/<name>/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["test"]}' \
  --field enforce_admins=false \
  --field required_pull_request_reviews=null \
  --field restrictions=null
```

---

### Step 9 — Erster Commit

```bash
git -C /workspace/<name> add -A
git -C /workspace/<name> commit -m "init: project scaffold"
git -C /workspace/<name> push -u origin main
```

---

### Step 10 — MEMORY.md

`/mycoforge/MEMORY.md` unter "Aktive Projekte" ergänzen:
```
- <name>: <beschreibung> → https://github.com/TrendForgeAI/<name>
```

---

### Abschluss

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Projekt "<name>" ist bereit!
  Repo:  https://github.com/TrendForgeAI/<name>
  Lokal: /workspace/<name>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
