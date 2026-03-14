# Git Workflow

## Wann diese Datei laden?
Lade diese Datei wenn du Git-Operationen durchführen musst.

## Grundprinzipien

- Atomic Commits – ein Commit pro abgeschlossener Aufgabe
- Keine Secrets in Git – immer .env.example statt .env
- Commit-Messages auf Englisch, präzise und aussagekräftig
- Immer pushen nach dem Commit

## Commit-Message Format
```
typ: kurze beschreibung

Typen:
init     → erstes Setup
feat     → neue Funktion
fix      → Bugfix
docs     → Dokumentation
refactor → Umstrukturierung ohne Funktionsänderung
test     → Tests
chore    → Wartung, Dependencies
```

## Workflow für Änderungen
```
1. Änderung verstehen und planen
2. Umsetzen
3. Testen
4. git add <dateien>
5. git commit -m "typ: beschreibung"
6. git push
```

## Workflow für mycoforge selbst
```
1-6. wie oben
7. ./update.sh ausführen
```

## Neue Repos anlegen
```
1. GitHub Repo unter TrendForgeAI anlegen
2. git clone git@github.com:TrendForgeAI/projekt-name.git
3. cd workspace/projekt-name
4. Grundstruktur anlegen
5. git add -A
6. git commit -m "init: project scaffold"
7. git push
```

## Branches

- main → stabiler Stand, immer deploybar
- feature/name → neue Features
- fix/name → Bugfixes

Für mycoforge selbst: direkt auf main arbeiten (solo-Projekt)
