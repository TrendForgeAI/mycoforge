# Neues Projekt anlegen

## Wann diese Datei laden?
Lade diese Datei wenn ein neues Projekt gestartet werden soll.

## Pflichtfragen vor dem Start

Bevor du irgendetwas anlegst, frage den Nutzer nach diesen Informationen:

1. **Projektname** → wird als Repo-Name verwendet (lowercase, kebab-case)
2. **Kurzbeschreibung** → ein Satz, was das Projekt macht
3. **Projekttyp** → Web-App / Mobile App / WordPress Plugin / CLI Tool / Library / Assistent / Sonstiges
4. **Tech Stack** → welche Sprachen, Frameworks, Datenbanken?
5. **Sichtbarkeit** → Public oder Private?
6. **Besonderheiten** → braucht es eine Datenbank, externe APIs, Docker?

Erst wenn alle Antworten vorliegen → mit dem Anlegen beginnen.

## Schritte

### 1. GitHub Repo anlegen
```bash
gh repo create TrendForgeAI/<projektname> \
  --description "<beschreibung>" \
  --<public|private> \
  --license mit
```

### 2. In workspace/ klonen
```bash
cd /workspace
git clone git@github.com:TrendForgeAI/<projektname>.git
cd <projektname>
```

### 3. Grundstruktur anlegen
Jedes Projekt bekommt mindestens:
- `CLAUDE.md` → Projektkontext für Claude Code
- `README.md` → für Menschen
- `.gitignore` → projektspezifisch

### 4. CLAUDE.md für das neue Projekt
```markdown
# <projektname>

<beschreibung>

## Tech Stack
<tech stack>

## Projektstruktur
(wird beim ersten Build ergänzt)

## Arbeitsweise
- Atomic Commits
- Keine Secrets in Git
- Tests vor jedem Commit
```

### 5. README.md
```markdown
# <projektname>

<beschreibung>

## Installation
(wird ergänzt)

## Usage
(wird ergänzt)
```

### 6. Erstes Commit
```bash
git add -A
git commit -m "init: project scaffold"
git push
```

### 7. MEMORY.md aktualisieren
Neues Projekt in der MEMORY.md unter "Aktive Projekte" eintragen:
```
- <projektname>: <beschreibung> → https://github.com/TrendForgeAI/<projektname>
```

## Projekttypen & Besonderheiten

### Personal Assistant
- Qdrant für Langzeitgedächtnis als Service in docker-compose.yml
- MCP-Server für externe Dienste (Mail, Kalender)

### WordPress Plugin
- PHP-Struktur: includes/, templates/, assets/
- Lokale WordPress-Instanz für Tests empfehlen

### Web-Anwendung
- Framework abfragen (Next.js, FastAPI, Laravel etc.)
- CI/CD via GitHub Actions vorschlagen

### Mobile App
- React Native oder Flutter abfragen
- App Store / Play Store Deployment beachten

### CLI Tool / Library
- Package Manager abfragen (npm, pip, cargo etc.)
- Versionierung und Release-Workflow besprechen
