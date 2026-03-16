# git-workflow

## Wann laden?
Bei jeder Git-Operation: commit, push, branch, merge, neues Repo anlegen.

## Kontext

- Atomic Commits — ein Commit pro abgeschlossener Aufgabe
- Keine Secrets in Git — immer `.env.example` statt `.env`
- Commit-Messages auf Englisch, Imperativ, Präsens
- Nach jedem Commit pushen
- mycoforge selbst: direkt auf `main` arbeiten (solo-Projekt)

## Vorgehen

### Standard-Änderung
```
1. Änderung verstehen und planen
2. Umsetzen
3. Testen
4. git add <dateien>        ← spezifische Dateien, nicht -A
5. git commit -m "typ(scope): beschreibung"
6. git push
```

### mycoforge selbst
```
1–6. wie oben
7. ./update.sh ausführen
```

### Neues Repo anlegen
```
1. gh repo create TrendForgeAI/<name> --public|--private
2. git clone https://github.com/TrendForgeAI/<name>.git /workspace/<name>
3. Grundstruktur anlegen (CLAUDE.md, README.md, .gitignore)
4. git -C /workspace/<name> add -A
5. git -C /workspace/<name> commit -m "init: project scaffold"
6. git -C /workspace/<name> push -u origin main
```

## Commit-Message Format

```
typ(scope): kurze beschreibung   ← max 72 Zeichen

Typen:
init      → erstes Setup
feat      → neue Funktion
fix       → Bugfix
docs      → Dokumentation
refactor  → Umstrukturierung ohne Funktionsänderung
test      → Tests
chore     → Wartung, Dependencies
```

## Branches

| Branch | Zweck |
|--------|-------|
| `main` | stabiler Stand, immer deploybar |
| `feature/name` | neue Features |
| `fix/name` | Bugfixes |

## Sicherheits-Check vor jedem Commit

- `.env` nicht gestaged?
- Keine Tokens/Passwörter im Diff?
- Keine `node_modules/`, `.venv/`, `dist/` dabei?

Bei Fund: **Stopp** — `.gitignore` prüfen, Datei entstagen.

## Beispiele

```bash
git add src/router.ts tests/router.test.ts
git commit -m "feat(router): add provider fallback on timeout"
git push

git add knowledge/git-workflow.md
git commit -m "docs(git): add branch naming conventions"
git push
```
