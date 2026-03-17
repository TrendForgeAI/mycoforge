---
description: Intelligenter Commit mit automatisch generierter Commit Message
argument-hint: [optionale hinweis zur änderung]
---

Erstelle einen atomaren Git Commit für die aktuellen Änderungen.

**Hinweis:** $ARGUMENTS

## Vorgehen

1. **Status prüfen**
   ```bash
   git status
   git diff --staged
   git diff
   ```

2. **Änderungen verstehen**
   - Was wurde geändert?
   - Warum? (Kontext aus $ARGUMENTS oder aus den Änderungen ableiten)
   - Typ: `feat` | `fix` | `refactor` | `docs` | `test` | `chore` | `init`

3. **Sicherheits-Check** (IMMER vor dem Stagen)
   - Keine `.env` Dateien gestaged?
   - Keine Secrets, Tokens, Passwörter im Diff?
   - Keine `node_modules/`, `.venv/`, `dist/` versehentlich dabei?

   Bei Fund: **Stopp** — informiere den Nutzer, stage diese Dateien NICHT.

4. **Commit Message generieren**

   Format: `<typ>(<scope>): <kurze beschreibung>`

   Regeln:
   - Imperativ, Präsens: "add feature" nicht "added feature"
   - Max 72 Zeichen erste Zeile
   - Scope optional: Datei, Modul oder Feature-Bereich
   - Bei größeren Änderungen: Body mit Kontext ergänzen

   Beispiele:
   ```
   feat(wizard): add breadcrumb progress bar
   fix(router): handle missing provider gracefully
   refactor: simplify plan-solve orchestrator
   docs(architecture): add Council pattern description
   ```

5. **Stagen und committen**

   Bevorzuge spezifische Dateien über `git add -A`:
   ```bash
   git add <datei1> <datei2> ...
   git commit -m "<message>"
   ```

6. **Bestätigung**

   Zeige den erstellten Commit:
   ```bash
   git log --oneline -1
   ```

Falls keine Änderungen vorhanden: informiere den Nutzer und tue nichts.
