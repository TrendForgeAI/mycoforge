# Project Wizard

## Wann diese Datei laden?
Lade diese Datei wenn ein neues Projekt gestartet werden soll.
Sie ersetzt new-project.md als interaktiver Schritt-für-Schritt-Wizard.

---

## Wizard Steps Übersicht

Der Wizard ist in drei Phasen mit klar nummerierten Steps unterteilt:

```
Phase 1 — Pflichtfragen (Wizard Steps 1–6)
  Step 1   Name
  Step 2   Beschreibung
  Step 3   Projekttyp
  Step 4   Tech Stack
  Step 5   Sichtbarkeit
  Step 6   Lizenz
           └─ Zwischenstand → weiter oder direkt anlegen

Phase 1b — Optionale Einstellungen (Wizard Steps A–E)
  Step A   Testing
  Step B   CI/CD
  Step C   Code-Qualität
  Step D   Security
  Step E   Docker
           └─ Finale Zusammenfassung → anlegen

Phase 2 — Ausführung (Setup Steps 1–10)
  1  GitHub Repo anlegen
  2  Klonen
  3  CLAUDE.md erstellen
  4  README.md erstellen
  5  .gitignore erstellen
  6  GitHub Actions einrichten
  7  Dependabot einrichten
  8  Branch-Protection aktivieren
  9  Ersten Commit machen
  10 MEMORY.md aktualisieren
```

---

## Step-Header Template

**Vor jeder Frage / jedem Block** gibt Claude diesen Header aus.
Ersetze die Platzhalter passend zum aktuellen Schritt.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  <Phase-Label>   <Fortschritt-Dots>   Schritt <N> / <Total>
  <Step-Titel>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Fortschritt-Dots** für Phase 1 (6 Schritte):
```
Schritt 1 → ●○○○○○
Schritt 2 → ●●○○○○
Schritt 3 → ●●●○○○
Schritt 4 → ●●●●○○
Schritt 5 → ●●●●●○
Schritt 6 → ●●●●●●
```

**Fortschritt-Dots** für Phase 1b (5 Blöcke, A–E):
```
Block A → ●○○○○
Block B → ●●○○○
Block C → ●●●○○
Block D → ●●●●○
Block E → ●●●●●
```

**Beispiel** für Wizard Step 3:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Pflichtfragen   ●●●○○○   Schritt 3 / 6
  Projekttyp
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Einstieg

Begrüße den Nutzer kurz und kündige den Wizard an:

> "Neues Projekt — ich führe dich durch die Einrichtung. Zuerst sammle ich alle nötigen
> Infos, dann lege ich alles automatisch an. Los geht's!"

Zeige dann die Wizard Steps Übersicht (kompakt):

```
Phase 1   Pflichtfragen     Step 1–6   Name · Beschreibung · Typ · Tech Stack · Sichtbarkeit · Lizenz
Phase 1b  Optional          Step A–E   Testing · CI/CD · Code-Qualität · Security · Docker
Phase 2   Ausführung        10 Schritte automatisch
```

---

## Phase 1: Pflichtfragen

Gehe die Steps EINZELN durch. Zeige vor jeder Frage den **Step-Header**.
Verwende **AskUserQuestion** für alle Auswahlentscheidungen.

---

### Wizard Step 1 — Name

**Step-Header ausgeben:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Pflichtfragen   ●○○○○○   Schritt 1 / 6
  Name
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Stelle als Freitext-Frage (via AskUserQuestion "Other"): "Wie soll das Projekt heißen?"

- Format: lowercase, kebab-case (z. B. `my-cool-tool`)
- Konvertiere automatisch: `My Cool Tool` → `my-cool-tool`
- Prüfe: nur a-z, 0-9, Bindestrich
- Bestätige die konvertierte Form explizit im Text

---

### Wizard Step 2 — Beschreibung

**Step-Header ausgeben:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Pflichtfragen   ●●○○○○   Schritt 2 / 6
  Beschreibung
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Stelle als Freitext-Frage (via AskUserQuestion "Other"): "Ein Satz: Was macht das Projekt?"

- Wird als GitHub-Repo-Description und in README/CLAUDE.md verwendet
- Schlage eine Verbesserung vor wenn der Satz sehr lang oder unklar ist

---

### Wizard Step 3 — Projekttyp

**Step-Header ausgeben:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Pflichtfragen   ●●●○○○   Schritt 3 / 6
  Projekttyp
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

AskUserQuestion mit 4 Optionen (+ automatisches "Other" für Library · WordPress Plugin · Mobile App · Sonstiges):

| Option | Description |
|--------|-------------|
| Web-App | React, Vue, Svelte, ... |
| Backend / API | REST, GraphQL, gRPC, ... |
| Fullstack | Frontend + Backend in einem Repo |
| CLI Tool | Kommandozeilen-Werkzeug |

Bei "Other": Folgefrage mit Library · WordPress Plugin · Mobile App · Sonstiges.

Merke den Typ — er steuert die Defaults in den optionalen Fragen.

---

### Wizard Step 4 — Tech Stack

**Step-Header ausgeben:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Pflichtfragen   ●●●●○○   Schritt 4 / 6
  Tech Stack
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Zeige zuerst den Vorschlag passend zum Typ:

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

Dann AskUserQuestion mit 2 Fragen auf einmal:

- **Sprache:** TypeScript | Python | PHP | Other (JS / Go / Rust / ...)
- **Package Manager:** npm / pnpm | yarn | uv / pip | Other (composer / cargo / go mod / ...)

Runtime-Version aus den Antworten ableiten (Node 22 LTS, Python 3.13, PHP 8.3).
Framework explizit erfragen wenn nicht eindeutig aus Kontext.

---

### Wizard Step 5 — Sichtbarkeit

**Step-Header ausgeben:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Pflichtfragen   ●●●●●○   Schritt 5 / 6
  Sichtbarkeit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

AskUserQuestion:

| Option | Description |
|--------|-------------|
| Public | Open Source, für alle sichtbar |
| Private | Nur für dich / dein Team |

---

### Wizard Step 6 — Lizenz

**Step-Header ausgeben:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Pflichtfragen   ●●●●●●   Schritt 6 / 6
  Lizenz
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

AskUserQuestion mit 4 Optionen (+ "Other" für proprietär):

| Option | Description |
|--------|-------------|
| MIT | Permissiv, empfohlen für Open Source (Recommended bei Public) |
| Apache 2.0 | Permissiv + Patentschutz |
| GPL v3 | Copyleft |
| keine | Kein Lizenz-File (Recommended bei Private) |

---

### Zwischenstand

Zeige Zusammenfassung:

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
```

AskUserQuestion:

| Option | Description |
|--------|-------------|
| Weiter mit optionalen Einstellungen | Testing, CI/CD, Code-Qualität, Security, Docker konfigurieren |
| Direkt anlegen | Optionale Einstellungen überspringen |

---

## Phase 1b: Optionale Fragen

Gehe die Blöcke EINZELN durch. Zeige vor jedem Block den **Step-Header**.
Verwende **AskUserQuestion** für alle Auswahlentscheidungen.

---

### Wizard Step A — Testing

**Step-Header ausgeben:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Optionale Einstellungen   ●○○○○   Block A / E
  Testing
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Zeige berechnete Defaults passend zum Typ:

| Typ             | Unit Tests       | E2E Tests   | Coverage |
|-----------------|------------------|-------------|----------|
| Web-App         | Vitest           | Playwright  | 80 %     |
| Backend / API   | Jest / pytest    | —           | 80 %     |
| Fullstack       | Vitest           | Playwright  | 80 %     |
| CLI Tool        | Jest / pytest    | —           | 70 %     |
| Library         | Vitest / pytest  | —           | 90 %     |
| WordPress Plugin| PHPUnit          | —           | —        |
| Mobile App      | Jest             | —           | 70 %     |

AskUserQuestion:

| Option | Description |
|--------|-------------|
| Defaults übernehmen | Vorgeschlagenes Setup verwenden |
| Anpassen | Eigene Frameworks / Coverage wählen |

Bei "Anpassen": Einzeln nachfragen (Unit · E2E · Coverage-Ziel).

---

### Wizard Step B — CI/CD

**Step-Header ausgeben:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Optionale Einstellungen   ●●○○○   Block B / E
  CI/CD
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

AskUserQuestion mit 2 Fragen auf einmal:

- **GitHub Actions für Tests bei PR?** Ja | Nein
- **Automatisches Deployment?** Nein | Vercel | VPS | Other (AWS / Fly.io / ...)

Default: Tests Ja, Deployment Nein (bei Web-App Vercel als erste Option).

---

### Wizard Step C — Code-Qualität

**Step-Header ausgeben:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Optionale Einstellungen   ●●●○○   Block C / E
  Code-Qualität
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

AskUserQuestion mit 2 Fragen auf einmal:

- **Linter / Formatter:** ESLint + Prettier | Ruff | PHP_CodeSniffer | Other (oder keiner via Other)
- **Pre-commit Hooks?** Ja | Nein

---

### Wizard Step D — Security

**Step-Header ausgeben:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Optionale Einstellungen   ●●●●○   Block D / E
  Security
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

AskUserQuestion mit 3 Fragen auf einmal (Default: alle Ja bei Public, alle Nein bei Private):

- **Dependabot?** Ja | Nein
- **Secret-Scanning?** Ja | Nein
- **Branch-Protection auf main?** Ja | Nein

---

### Wizard Step E — Docker

**Step-Header ausgeben:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Optionale Einstellungen   ●●●●●   Block E / E
  Docker
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

AskUserQuestion:

| Option | Description |
|--------|-------------|
| Kein Docker | Kein eigener Container |
| Eigenständiger Container | Eigenes Dockerfile / docker-compose |
| Teil von mycoforge | In mycoforge-Container integriert |

---

### Finale Zusammenfassung

Zeige alle Einstellungen kompakt:

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
```

AskUserQuestion:

| Option | Description |
|--------|-------------|
| Jetzt anlegen | Phase 2 starten |
| Änderungen vornehmen | Zurück zu den Fragen |

---

## Phase 2: Ausführung

Führe diese Schritte EXAKT in dieser Reihenfolge aus. Melde nach jedem Schritt
kurz den Status (✓ Erledigt / ✗ Fehler + Ursache).

Zeige vor dem Start eine Fortschrittsleiste:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Ausführung   10 Schritte
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [ ] 1  GitHub Repo anlegen
  [ ] 2  Klonen
  [ ] 3  CLAUDE.md erstellen
  [ ] 4  README.md erstellen
  [ ] 5  .gitignore erstellen
  [ ] 6  GitHub Actions einrichten
  [ ] 7  Dependabot einrichten
  [ ] 8  Branch-Protection aktivieren
  [ ] 9  Ersten Commit machen
  [ ] 10 MEMORY.md aktualisieren
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### Setup Step 1 — GitHub Repo anlegen

```bash
gh repo create TrendForgeAI/<name> \
  --description "<beschreibung>" \
  --<public|private> \
  --license <lizenz|"">
```

Bei Fehler: Fehlermeldung ausgeben und abbrechen.

---

### Setup Step 2 — Klonen

```bash
cd /workspace
git clone https://github.com/TrendForgeAI/<name>.git
cd <name>
```

---

### Setup Step 3 — CLAUDE.md erstellen

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

### Setup Step 4 — README.md erstellen

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

### Setup Step 5 — .gitignore erstellen

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

### Setup Step 6 — GitHub Actions (falls CI/CD gewählt)

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

### Setup Step 7 — Dependabot einrichten (falls gewählt)

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

### Setup Step 8 — Branch-Protection aktivieren (falls gewählt)

```bash
gh api repos/TrendForgeAI/<name>/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["test"]}' \
  --field enforce_admins=false \
  --field required_pull_request_reviews=null \
  --field restrictions=null
```

---

### Setup Step 9 — Ersten Commit machen

```bash
git add -A
git commit -m "init: project scaffold"
git push -u origin main
```

---

### Setup Step 10 — MEMORY.md aktualisieren

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
