# Neues Projekt anlegen

## Wann diese Datei laden?
Lade diese Datei wenn ein neues Projekt gestartet werden soll.

## Schritte

### 1. GitHub Repo anlegen
- Organisation: TrendForgeAI
- Name: projekt-name (lowercase, kebab-case)
- Beschreibung: kurze, präzise Beschreibung
- Lizenz: MIT
- .gitignore: je nach Technologie

### 2. In workspace/ klonen
```bash
cd /docker/mycoforge/workspace
git clone git@github.com:TrendForgeAI/projekt-name.git
cd projekt-name
```

### 3. Grundstruktur anlegen
Jedes Projekt bekommt mindestens:
- CLAUDE.md → Projektkontext für Claude Code
- README.md → für Menschen
- .gitignore → projektspezifisch

### 4. CLAUDE.md für das neue Projekt
```markdown
# projekt-name

Kurze Beschreibung was dieses Projekt ist.

## Tech Stack
- ...

## Projektstruktur
- ...

## Arbeitsweise
- Atomic Commits
- Keine Secrets in Git
- ...
```

### 5. Erstes Commit
```bash
git add -A
git commit -m "init: project scaffold"
git push
```

## Projekttypen & Besonderheiten

### Personal Assistant
- Qdrant für Langzeitgedächtnis hinzufügen
- MCP-Server für externe Dienste (Mail, Kalender)
- docker-compose.yml mit eigenen Services

### WordPress Plugin
- PHP-Struktur beachten
- Lokale WordPress-Instanz für Tests

### Web-Anwendung
- Framework wählen (Next.js, FastAPI etc.)
- CI/CD via GitHub Actions

### Mobile App
- React Native oder Flutter
- App Store Deployment beachten
