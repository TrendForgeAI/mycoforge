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

Vor jedem Step/Block die **Fortschrittsleiste** ausgeben.
Abgeschlossene Schritte: `✓`, aktueller Schritt: `▶□`, ausstehend: `□`.

**Phase 1 — Pflichtfragen (6 Schritte):**
```
← □ Name  □ Beschreibung  □ Typ  □ Stack  □ Sichtbarkeit  □ Lizenz  →
```
Beispiel nach Step 2 (Typ ist aktuell):
```
← ✓ Name  ✓ Beschreibung  ▶□ Typ  □ Stack  □ Sichtbarkeit  □ Lizenz  →
```

**Phase 1b — Optionale Einstellungen (5 Blöcke):**
```
← □ Testing  □ CI/CD  □ Code-Qualität  □ Security  □ Docker  →
```

Darunter immer den Titel des aktuellen Schritts als Überschrift:
```
  <Titel>
```

---

## Einstieg

```
> "Neues Projekt — ich führe dich Schritt für Schritt durch die Einrichtung.
>  Erst sammle ich alle Infos, dann lege ich alles automatisch an."
```

---

## Phase 1 — Pflichtfragen

---

### Step 1 — Name

**Freitext:** "Wie soll das Projekt heißen?"

- Original-Eingabe als `<displayName>` merken (z.B. `My Cool Tool`)
- Repo-/Verzeichnisname `<name>` daraus ableiten: `lowercase-kebab-case`
- Auto-Konvertierung: `My Cool Tool` → `my-cool-tool`
- Nur a–z, 0–9, Bindestrich erlaubt
- Konvertiertes Ergebnis bestätigen: „Name: **my-cool-tool** (angezeigt als: **My Cool Tool**)"

---

### Step 2 — Beschreibung

**Freitext:** "Ein Satz: Was macht das Projekt?"

- Wird in GitHub, README und CLAUDE.md verwendet
- Bei sehr langem oder unklarem Satz: Verbesserung vorschlagen

---

### Kontext-Analyse (intern — keine Nutzerfrage)

Nachdem Name **und** Beschreibung vorliegen: Analysiere beide Felder und leite Signale ab, die alle Folgeschritte informieren. Keine Extra-Frage stellen — Ergebnis intern merken.

**Was extrahieren:**
- Technologie-Keywords: `python`, `react`, `api`, `cli`, `mobile`, `scraper`, `dashboard`, `bot`, ...
- Domäne: Datenverarbeitung, Web-UI, Backend-Service, CLI-Tool, Automatisierung, ...
- Komplexität: Einzel-Script vs. Service vs. Plattform
- Laufzeithinweise: "täglich", "scheduled", "real-time", "webhook", ...

**Wie nutzen:**
- **Step 3 (Typ):** Den wahrscheinlichsten Typ als Empfehlung kennzeichnen: `★ Empfohlen`
- **Step 4 (Stack):** Statt generischen Typ-Defaults einen auf Name+Beschreibung zugeschnittenen Vorschlag ausgeben, mit kurzem „Warum" (1 Satz)
- **Phase 1b:** Defaults anpassen wenn sinnvoll — z.B. kein E2E-Framework für ein reines Backend-Script, hohe Coverage für eine Library

**Beispiele:**
- Name `yahoo-finance-crawler`, Beschreibung „lädt täglich Kursdaten von Yahoo Finance" → Python, CLI Tool, kein E2E, pytest
- Name `team-dashboard`, Beschreibung „Web-App für Team-KPIs mit Charts" → TypeScript, Web-App, Vitest + Playwright
- Name `auth-service`, Beschreibung „REST API für Authentifizierung und JWT" → TypeScript oder Python, Backend/API, Jest/pytest, kein E2E

---

### Step 3 — Projekttyp

**AskUserQuestion** (4 Optionen + Other):

| Option | Description |
|--------|-------------|
| Web-App | Browserbasierte Oberfläche — React, Vue, Svelte, ... |
| Backend / API | Server-seitige Logik & Schnittstellen — REST, GraphQL, gRPC, ... |
| Fullstack | Frontend + Backend in einem Repo — Next.js, SvelteKit, ... |
| CLI Tool | Kommandozeilen-Werkzeug — direkt im Terminal ausführbar |

Other → Folgefrage: Library · WordPress Plugin · Mobile App · Sonstiges

Den aus der Kontext-Analyse abgeleiteten Typ in der Description mit `★ Empfohlen aufgrund deiner Beschreibung` kennzeichnen.

Gemerkter Typ steuert Defaults in Phase 1b.

---

### Step 4 — Tech Stack

Vor den Fragen einen **Vorschlag-Block** ausgeben — angepasst an Name + Beschreibung (nicht nur den Typ):

**Format des Vorschlag-Blocks:**
```
Mein Vorschlag für "<name>":

  Sprache:        TypeScript — typsicheres JavaScript, weniger Laufzeitfehler
  Framework:      React — UI-Bibliothek, riesiges Ökosystem, bewährt
  Package Mgr:    npm — Standardwahl für Node.js, größtes Registry
  Runtime:        Node 22 LTS — aktueller Langzeitsupport, stabil

  Warum dieser Stack: <1 Satz bezogen auf Name + Beschreibung>
```

**Erklärungsformat pro Komponente:** `Name — was es ist (2-3 Wörter), warum empfohlen (2-3 Wörter)`

**Basis-Vorschläge (werden durch Kontext-Analyse verfeinert):**

| Typ | Sprache | Framework | Package Mgr | Runtime |
|-----|---------|-----------|-------------|---------|
| Web-App | TypeScript | React | npm | Node 22 LTS |
| Backend / API | TypeScript oder Python | Express/Fastify oder FastAPI | npm oder uv | Node 22 oder Python 3.13 |
| Fullstack | TypeScript | Next.js | npm | Node 22 LTS |
| CLI Tool | TypeScript oder Python | — | npm oder uv | Node 22 oder Python 3.13 |
| Library | TypeScript oder Python | — | npm oder uv | Node 22 oder Python 3.13 |
| WordPress Plugin | PHP 8.3 | — | Composer | PHP 8.3 |
| Mobile App | TypeScript | React Native | npm | Node 22 LTS |

**AskUserQuestion** (2 Fragen gleichzeitig):

- **Sprache:** TypeScript — typsicheres JS, IDE-Unterstützung | Python — lesbar & schnell, ideal für Daten/Scripts | PHP — bewährt für Web/CMS | Other
- **Package Manager:** npm — Standard, größtes Registry | pnpm — schnell & sparsam, Monorepos | yarn — bewährt, gute Workspaces | uv / pip — Python-Standard | Other

Runtime ableiten: Node 22 LTS · Python 3.13 · PHP 8.3
Framework nachfragen wenn nicht eindeutig — dabei ebenfalls kurz erklären was es ist und warum es passt.

---

### Step 5 — Sichtbarkeit

**AskUserQuestion:**

| Option | Description |
|--------|-------------|
| Public | Open Source, für alle sichtbar |
| Private | Nur für dich / dein Team |

---

### Step 6 — Lizenz

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

### Block A — Testing

Vorschlag basierend auf Typ **und** Kontext-Analyse ausgeben:

**Format:**
```
Vorschlag für "<name>":

  Unit-Tests:  Vitest — schneller Test-Runner, Vite-nativ
  E2E-Tests:   Playwright — Browser-Automatisierung, zuverlässig
  Coverage:    80 % — guter Ausgangspunkt für Web-Apps

  Warum: <1 Satz bezogen auf Beschreibung, z.B. "Da dein Dashboard UI-Logik hat, lohnt sich E2E">
```

Kein E2E vorschlagen wenn die Kontext-Analyse zeigt, dass kein Browser-Frontend existiert (reines Backend, CLI, Script, Library).

**Basis-Defaults (werden durch Kontext verfeinert):**

| Typ | Unit | E2E | Coverage |
|-----|------|-----|----------|
| Web-App | Vitest — schnell, Vite-nativ | Playwright — Browser-Auto, zuverlässig | 80 % |
| Backend / API | Jest / pytest — bewährt, große Community | — | 80 % |
| Fullstack | Vitest — schnell, Vite-nativ | Playwright — Browser-Auto, zuverlässig | 80 % |
| CLI Tool | Jest / pytest — bewährt, einfach | — | 70 % |
| Library | Vitest / pytest — schnell, isoliert | — | 90 % — Libraries brauchen hohe Abdeckung |
| WordPress Plugin | PHPUnit — PHP-Standard, WP-Ökosystem | — | — |
| Mobile App | Jest — JS-Standard, einfach | — | 70 % |

**AskUserQuestion:**

| Option | Description |
|--------|-------------|
| Defaults übernehmen | Vorschlag verwenden |
| Anpassen | Eigene Frameworks / Coverage wählen |

Bei Anpassen: einzeln nachfragen (Unit · E2E · Coverage-Ziel) — dabei jede Option kurz erklären.

---

### Block B — CI/CD

**AskUserQuestion** (2 Fragen gleichzeitig):

- **GitHub Actions bei PR?** Ja | Nein  _(Default: Ja)_
- **Automatisches Deployment?** Nein | Vercel | VPS | Other  _(Default: Nein; bei Web-App: Vercel zuerst)_

---

### Block C — Code-Qualität

**AskUserQuestion** (2 Fragen gleichzeitig):

- **Linter / Formatter:** ESLint + Prettier | Ruff | PHP_CodeSniffer | Other
- **Pre-commit Hooks?** Ja | Nein

---

### Block D — Security

Default: alle Ja bei Public · alle Nein bei Private

**AskUserQuestion** (3 Fragen gleichzeitig):

- **Dependabot?** Ja | Nein
- **Secret-Scanning?** Ja | Nein
- **Branch-Protection auf main?** Ja | Nein

---

### Block E — Docker

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

### Checklisten-Regel (WICHTIG)

Nach **jedem** abgeschlossenen Schritt die **gesamte Checkliste neu ausgeben** mit:
- `[x]` für erledigte Schritte
- `[-]` für übersprungene Schritte
- `[ ]` für noch ausstehende Schritte
- `→` vor dem aktuell gerade abgeschlossenen Schritt (Ergebnis dahinter)

Beispiel nach Step 2:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Ausführung — 10 Schritte
  [x] 1  GitHub Repo anlegen
→ [x] 2  Klonen               ✓
  [ ] 3  CLAUDE.md
  ...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Bei Fehler: `→ [x] N  Titel   ✗ Fehler: <Ursache>` → abbrechen.

Initiale Ausgabe vor Step 1 (alle `[ ]`):
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
gh repo create ${GH_ORG}/<name> \
  --description "<beschreibung>" \
  --<public|private> \
  --license <lizenz|"">
```

Bei Fehler: abbrechen.

---

### Step 2 — Klonen

```bash
git clone https://github.com/${GH_ORG}/<name>.git /workspace/<name>
```

Direkt nach dem Clone `.mycoforge.json` erstellen — wird von der Web-UI gelesen um den lesbaren Namen anzuzeigen:

```bash
echo '{"displayName":"<displayName>"}' > /workspace/<name>/.mycoforge.json
```

(`<displayName>` = Original-Eingabe aus Step 1, z.B. `My Cool Tool`)

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
- README.md und CLAUDE.md nach strukturellen Änderungen aktualisieren
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
gh api repos/${GH_ORG}/<name>/branches/main/protection \
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
- <name>: <beschreibung> → https://github.com/${GH_ORG}/<name>
```

---

### Abschluss

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Projekt "<name>" ist bereit!
  Repo:  https://github.com/${GH_ORG}/<name>
  Lokal: /workspace/<name>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
