# Project Wizard

## Wann diese Datei laden?
Lade diese Datei wenn ein neues Projekt gestartet werden soll.
Sie ersetzt new-project.md als interaktiver Schritt-für-Schritt-Wizard.

---

## Einstieg

Begrüße den Nutzer kurz und kündige den Wizard an:

> "Neues Projekt — ich führe dich durch die Einrichtung. Zuerst sammle ich alle nötigen
> Infos, dann lege ich alles automatisch an. Los geht's!"

Zeige dann diese Übersicht:

```
Pflichtfragen  (6):  Name · Beschreibung · Typ · Tech Stack · Sichtbarkeit · Lizenz
Optionale Fragen:    Testing · CI/CD · Code-Qualität · Security · Docker
```

---

## Phase 1: Pflichtfragen

Gehe die Fragen EINZELN durch — stelle die nächste Frage erst nachdem die vorherige
beantwortet wurde. Akzeptiere Abkürzungen und ergänze sinnvoll.

---

### Frage 1 — Name

> "Wie soll das Projekt heißen?"

- Format: lowercase, kebab-case (z. B. `my-cool-tool`)
- Konvertiere automatisch wenn nötig: `My Cool Tool` → `my-cool-tool`
- Prüfe ob der Name gültig ist (nur a-z, 0-9, Bindestrich)

---

### Frage 2 — Beschreibung

> "Ein Satz: Was macht das Projekt?"

- Soll prägnant und klar sein
- Wird als GitHub-Repo-Description und in README/CLAUDE.md verwendet
- Schlage eine Verbesserung vor wenn der Satz sehr lang oder unklar ist

---

### Frage 3 — Projekttyp

> "Welcher Projekttyp passt am besten?"

Zeige Auswahlmenü:

```
[1] Web-App          (React, Vue, Svelte, ...)
[2] Backend / API    (REST, GraphQL, gRPC, ...)
[3] Fullstack        (Frontend + Backend in einem Repo)
[4] CLI Tool         (Kommandozeilen-Werkzeug)
[5] Library          (wiederverwendbares Paket / npm / PyPI / ...)
[6] WordPress Plugin
[7] Mobile App       (React Native, Flutter, ...)
[8] Sonstiges        → Kurzbeschreibung eingeben
```

Merke den gewählten Typ — er steuert die Defaults in den optionalen Fragen.

---

### Frage 4 — Tech Stack

> "Welchen Tech Stack nutzt du?"

Zeige Vorschläge passend zum Projekttyp:

| Typ             | Vorschlag                                              |
|-----------------|--------------------------------------------------------|
| Web-App         | TypeScript · React · npm · Node 22 LTS                 |
| Backend / API   | TypeScript · Express / Fastify · npm · Node 22 LTS     |
|                 | Python · FastAPI · uv · Python 3.13                    |
| Fullstack       | TypeScript · Next.js · npm · Node 22 LTS               |
| CLI Tool        | TypeScript · Node 22 LTS  /  Python · uv · Python 3.13 |
| Library         | TypeScript · npm  /  Python · uv                       |
| WordPress Plugin| PHP 8.3 · Composer                                     |
| Mobile App      | TypeScript · React Native · npm · Node 22 LTS          |

Frage nach:
1. **Sprache** (TypeScript / JavaScript / Python / PHP / Go / Rust / Sonstiges)
2. **Framework** (oder "keins")
3. **Package Manager** (npm / pnpm / yarn / uv / pip / composer / cargo / go mod)
4. **Runtime-Version** (Node / Python / PHP / ...)

---

### Frage 5 — Sichtbarkeit

> "Public oder Private?"

```
[1] Public   — Open Source, für alle sichtbar
[2] Private  — nur für dich / dein Team
```

---

### Frage 6 — Lizenz

> "Welche Lizenz soll das Repo bekommen?"

```
[1] MIT          — permissiv, empfohlen für Open Source
[2] Apache 2.0   — permissiv + Patentschutz
[3] GPL v3       — Copyleft
[4] proprietär   — kein Open Source
[5] keine        — kein Lizenz-File
```

Default: MIT bei Public, keine bei Private.

---

### Zwischenstand

Nachdem alle 6 Pflichtfragen beantwortet sind, zeige eine Zusammenfassung:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Projekt-Zusammenfassung
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Name:         <name>
  Beschreibung: <beschreibung>
  Typ:          <typ>
  Tech Stack:   <stack>
  Sichtbarkeit: <public|private>
  Lizenz:       <lizenz>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Weiter mit den optionalen Einstellungen? [J/n]
```

Bei "n" → direkt zu Phase 2.
Bei "J" → optionale Fragen durchgehen.

---

## Phase 1b: Optionale Fragen

Frage die Blöcke in dieser Reihenfolge ab. Schlage jeweils den Default vor —
der Nutzer kann mit Enter bestätigen oder überschreiben.

---

### Block A — Testing

> "Testing-Setup — ich schlage passende Defaults vor:"

Zeige Default passend zum Typ:

| Typ             | Unit Tests       | E2E Tests   | Coverage |
|-----------------|------------------|-------------|----------|
| Web-App         | Vitest           | Playwright  | 80 %     |
| Backend / API   | Jest / pytest    | —           | 80 %     |
| Fullstack       | Vitest           | Playwright  | 80 %     |
| CLI Tool        | Jest / pytest    | —           | 70 %     |
| Library         | Vitest / pytest  | —           | 90 %     |
| WordPress Plugin| PHPUnit          | —           | —        |
| Mobile App      | Jest             | —           | 70 %     |

Fragen:
```
Unit Tests:     [<default>] → Enter zum Übernehmen oder eigenes Framework eingeben
E2E Tests:      [<default>] → Enter / "nein"
Coverage-Ziel:  [<default>%] → Enter / eigenen Wert eingeben
```

---

### Block B — CI/CD

> "CI/CD — automatisierte Workflows:"

Fragen:
```
Tests bei Pull Request automatisch (GitHub Actions)?  [J/n]
Automatisches Deployment?                             [n/J]
  → Wohin? (Vercel / VPS / AWS / Fly.io / Sonstiges)
```

Default: Tests ja, Deployment nein (außer bei Web-App → Vercel als Option anbieten).

---

### Block C — Code-Qualität

> "Code-Qualität:"

Zeige Defaults:

| Typ                        | Linter/Formatter          | Pre-commit |
|----------------------------|---------------------------|------------|
| TypeScript / JavaScript    | ESLint + Prettier         | J          |
| Python                     | Ruff                      | J          |
| PHP                        | PHP_CodeSniffer           | n          |

Fragen:
```
Linter / Formatter:  [<default>] → Enter / eigenes Tool
Pre-commit Hooks:    [<default>] → J/n
```

---

### Block D — Security

> "Security-Einstellungen:"

```
Dependabot (automatische Dependency-Updates)?  [J/n]
Secret-Scanning aktivieren?                    [J/n]
Branch-Protection auf main?                    [J/n]
```

Default: alle J bei Public, alle n bei Private.

---

### Block E — Docker

> "Braucht das Projekt Docker?"

```
Eigener Container?               [n/J]
  → Teil von mycoforge oder eigenständig?  [eigenständig/mycoforge]
```

Default: nein.

---

### Finale Zusammenfassung

Zeige alle gesammelten Einstellungen kompakt:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Finale Konfiguration
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Name:            <name>
  Beschreibung:    <beschreibung>
  Typ:             <typ>
  Tech Stack:      <stack>
  Sichtbarkeit:    <public|private>
  Lizenz:          <lizenz>

  Testing:         <unit> / <e2e> / Coverage <x>%
  CI/CD:           <github actions J/n> / Deploy → <ziel|nein>
  Code-Qualität:   <linter> / Pre-commit <J/n>
  Security:        Dependabot <J/n> / Secrets <J/n> / Branch-Protection <J/n>
  Docker:          <J/n>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Alles korrekt? Jetzt anlegen? [J/n]
```

Bei "n" → zurück zu den Fragen (welche Frage soll geändert werden?).
Bei "J" → Phase 2 starten.

---

## Phase 2: Ausführung

Führe diese Schritte EXAKT in dieser Reihenfolge aus. Melde nach jedem Schritt
kurz den Status (✓ Erledigt / ✗ Fehler + Ursache).

---

### Schritt 1 — GitHub Repo anlegen

```bash
gh repo create TrendForgeAI/<name> \
  --description "<beschreibung>" \
  --<public|private> \
  --license <lizenz|"">
```

Bei Fehler: Fehlermeldung ausgeben und abbrechen.

---

### Schritt 2 — Klonen

```bash
cd /workspace
git clone git@github.com:TrendForgeAI/<name>.git
cd <name>
```

---

### Schritt 3 — CLAUDE.md erstellen

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
<unit-framework> für Unit Tests
<e2e-framework> für E2E Tests (falls gewählt)
Coverage-Ziel: <x>%

## CI/CD
<GitHub Actions J/n — was wird automatisiert>
<Deployment-Ziel oder "kein automatisches Deployment">

## Code-Qualität
<linter/formatter>
Pre-commit Hooks: <J/n>

## Arbeitsweise
- Atomic Commits
- Keine Secrets in Git
- Tests vor jedem Commit
```

---

### Schritt 4 — README.md erstellen

```markdown
# <name>

<beschreibung>

## Requirements

<passend zum Tech Stack — z. B. Node 22+, Python 3.13+, PHP 8.3+>

## Installation

(wird ergänzt)

## Usage

(wird ergänzt)

## License

<lizenz>
```

---

### Schritt 5 — .gitignore erstellen

Wähle Template passend zum Tech Stack:

| Stack        | .gitignore-Inhalt (Kern)                                              |
|--------------|-----------------------------------------------------------------------|
| Node.js      | node_modules/ · dist/ · .env · .env.local · *.log                    |
| Python       | __pycache__/ · *.pyc · .venv/ · dist/ · .env · *.egg-info/           |
| PHP          | vendor/ · .env · *.log                                                |
| Go           | /bin/ · *.exe · .env                                                  |
| Rust         | /target/ · .env                                                       |

Ergänze stets: `.DS_Store`, `Thumbs.db`, `.idea/`, `.vscode/` (außer settings.json).

---

### Schritt 6 — GitHub Actions (falls CI/CD gewählt)

```bash
mkdir -p .github/workflows
```

Erstelle `ci.yml` passend zum Stack. Beispiel für Node.js + Vitest:

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

Passe `runs-on`, Setup-Action und Testbefehl an den tatsächlichen Stack an.

---

### Schritt 7 — Dependabot einrichten (falls gewählt)

```bash
mkdir -p .github
```

Erstelle `.github/dependabot.yml`:

```yaml
version: 2
updates:
  - package-ecosystem: "<npm|pip|composer|cargo|gomod>"
    directory: "/"
    schedule:
      interval: weekly
```

---

### Schritt 8 — Branch-Protection aktivieren (falls gewählt)

```bash
gh api repos/TrendForgeAI/<name>/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["test"]}' \
  --field enforce_admins=false \
  --field required_pull_request_reviews=null \
  --field restrictions=null
```

---

### Schritt 9 — Ersten Commit machen

```bash
git add -A
git commit -m "init: project scaffold"
git push -u origin main
```

---

### Schritt 10 — MEMORY.md aktualisieren

Trage das neue Projekt in `/mycoforge/MEMORY.md` unter "Aktive Projekte" ein:

```
- <name>: <beschreibung> → https://github.com/TrendForgeAI/<name>
```

---

### Abschluss

Gib eine kurze Erfolgsmeldung aus:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Projekt "<name>" ist bereit!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Repo:      https://github.com/TrendForgeAI/<name>
  Lokal:     /workspace/<name>
  Nächster Schritt: cd /workspace/<name> und loslegen
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
