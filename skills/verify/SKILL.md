# verify

## Wann laden?
Nach `/implement`, nach Code-Änderungen oder bevor ein Ergebnis als "fertig" gemeldet wird.
Immer wenn dynamische Prüfung (Ausführen) statt statischer Analyse (Lesen) nötig ist.

## Iron Law

**Kein "es funktioniert" ohne laufende Verifikation.**

Verbotene Formulierungen vor abgeschlossener Verifikation:
- "sollte funktionieren", "müsste grün sein", "wahrscheinlich ok"
- "es ist fertig", "alles grün", "sieht richtig aus"
- "Agent meldet Erfolg" — ist **keine** Verifikation

Verifikation = Code ausführen + Output lesen + Tests explizit grün.

### Gate-Funktion

Vor jeder Fertigstellungs-Aussage prüfen:
- [ ] Checks tatsächlich ausgeführt (nicht nur geplant)?
- [ ] Output vollständig gelesen (nicht nur "no errors reported")?
- [ ] Alle Tests explizit grün (nicht nur "keine Fehlschläge gemeldet")?

---

Prüft nach `/implement` ob die Änderungen tatsächlich funktionieren.
Ergänzt `/review` (statische Analyse) durch dynamische Verifikation.

## Unterschied zu /review

| /review | /verify |
|---------|---------|
| Statisch: Qualität, Security, Architektur | Dynamisch: läuft es, bestehen Tests? |
| Code lesen und urteilen | Code ausführen und prüfen |
| Immer möglich | Setzt ausführbare Umgebung voraus |

## Eingabe

```
Aufgabe:  <was implementiert wurde — oder leer für letzten Commit>
Pfad:     <projektverzeichnis — default: aktuelles Verzeichnis>
```

## Vorgehen

### 1. Kontext bestimmen

Prüfe was geändert wurde:
```bash
git diff HEAD~1 --name-only   # Dateien des letzten Commits
git status                     # Uncommitted Changes
```

Bestimme Projekttyp anhand vorhandener Dateien:
- `package.json` → Node.js / TypeScript
- `pyproject.toml` / `setup.py` / `requirements.txt` → Python
- `composer.json` → PHP
- `go.mod` → Go
- `Cargo.toml` → Rust
- Nur `.md` / `.sh` → mycoforge-intern (Markdown + Shell)

### 2. Checks ausführen (nach Projekttyp)

#### Node.js / TypeScript
```bash
# Syntax / Typen
npx tsc --noEmit 2>&1 | head -20

# Tests
npm test 2>&1 || npx vitest run 2>&1 || npx jest 2>&1

# Lint (falls konfiguriert)
npx eslint . --ext .ts,.tsx 2>&1 | head -20
```

#### Python
```bash
# Syntax
python -m py_compile <geänderte .py dateien>

# Tests
pytest 2>&1 || python -m pytest 2>&1

# Lint (falls konfiguriert)
ruff check . 2>&1 | head -20
```

#### PHP
```bash
php -l <geänderte .php dateien>
./vendor/bin/phpunit 2>&1 | tail -10
```

#### Go
```bash
go build ./... 2>&1
go test ./... 2>&1
```

#### Rust
```bash
cargo build 2>&1 | tail -10
cargo test 2>&1 | tail -20
```

#### mycoforge-intern (Markdown + Shell)
```bash
# Shell-Syntax prüfen
bash -n <geänderte .sh dateien> 2>&1

# Referenzierte Dateien prüfen
# Extrahiere @knowledge/... Referenzen aus Agent-Dateien und prüfe ob sie existieren
grep -r '@knowledge/' claude/agents/ skills/ | grep -oP '@knowledge/[^\s`"]+' | sort -u | while read ref; do
    path="${ref/@/}"
    [ -f "$path" ] || echo "MISSING: $ref"
done
```

### 3. Ergebnis auswerten

Kategorisiere jeden Check:
- ✓ — bestanden
- ✗ — fehlgeschlagen (mit konkreter Fehlermeldung)
- — — nicht anwendbar / nicht konfiguriert

### 4. Ausgabe

```
[Verify] <aufgabe oder letzter commit>
Pfad: <verzeichnis>

Checks:
  Syntax / Typen:  ✓ | ✗ <fehler>
  Tests:           ✓ <n> bestanden | ✗ <n> fehlgeschlagen | — keine Tests
  Lint:            ✓ | ✗ <n> Probleme | — nicht konfiguriert
  Referenzen:      ✓ | ✗ <fehlende dateien>

Ergebnis: ✅ Alles grün | ⚠ <n> Probleme | ❌ Blocker vorhanden

Probleme:
- <konkretes problem mit datei:zeile wenn möglich>
```

### 5. Bei Fehlern

- **Syntax-Fehler / fehlende Referenzen:** Sofort beheben (Critical)
- **Fehlgeschlagene Tests:** Melden, Ursache analysieren, Nutzer fragen ob beheben
- **Lint-Warnungen:** Melden als Suggestion, kein Blocker

## Prinzipien

- Keine Annahmen: wenn ein Check nicht ausführbar ist, dokumentiere warum
- Fehlermeldungen vollständig zeigen (nicht kürzen)
- Reihenfolge: Syntax → Tests → Lint (von kritisch nach unkritisch)
- Nicht blocken wenn nur Lint-Warnungen vorliegen
