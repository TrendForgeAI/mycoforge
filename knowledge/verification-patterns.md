# Verification Patterns

## Wann laden?
Beim Code-Review oder bei `/verify` wenn geprüft werden soll ob eine Implementierung
substantiell ist — nicht nur syntaktisch korrekt, sondern tatsächlich funktional verbunden.

## Progressive Verifikations-Ebenen

Jede Ebene setzt die vorherige voraus:

| Ebene | Frage | Prüfung |
|-------|-------|---------|
| 1. Existiert | Ist die Datei/Funktion vorhanden? | `find`, `grep -l` |
| 2. Substantiell | Hat sie echten Inhalt (kein Stub)? | Stub-Patterns unten |
| 3. Verdrahtet | Wird sie tatsächlich aufgerufen? | Import-/Aufruf-Grep |
| 4. Funktional | Tut sie was sie soll (Tests grün)? | Test-Ausführung |

## Stub-Detection Patterns

### TypeScript / JavaScript

```bash
# Leere Funktionen / TODO-Stubs
grep -rn "TODO\|FIXME\|throw new Error.*not implemented\|return null\|return {}" src/

# Unvollständige async-Funktionen
grep -rn "async.*{$\|=> {$" src/ | grep -v test

# Hardcodierte Dummy-Werte
grep -rn "return.*['\"]dummy\|return.*['\"]mock\|return.*['\"]placeholder" src/

# Leere React-Komponenten
grep -rn "return null\|return <></>\|return <div><\/div>" src/components/
```

### Python

```bash
# pass-only Funktionen
grep -rn -A1 "def .*:" src/ | grep -B1 "^\s*pass$"

# NotImplementedError
grep -rn "raise NotImplementedError\|# TODO\|# FIXME" src/

# Hardcodierte Dummy-Returns
grep -rn "return None\|return {}\|return \[\]" src/ | grep -v test
```

### API-Routen (Express / FastAPI)

```bash
# Registrierte aber leere Routen
grep -rn "router\.\(get\|post\|put\|delete\).*{" src/ | grep -v test
# Dann prüfen ob der Route-Handler mehr als einen TODO enthält

# Fehlende Middleware-Verbindung
grep -rn "app\.use\|app\.router\|include_router" src/
```

### Datenbankschemas

```bash
# Migration existiert aber keine tatsächlichen Abfragen
grep -rn "CREATE TABLE\|ALTER TABLE" migrations/
grep -rn "\.query\|\.execute\|\.find\|\.create" src/

# ORM-Models ohne Repository-Nutzung
grep -rn "class.*Model\|@Entity" src/ | grep -v test
grep -rn "Repository\|\.save\|\.findOne" src/ | grep -v test
```

### React Hooks

```bash
# useEffect ohne sinnvollen Body
grep -rn -A3 "useEffect" src/ | grep -B1 "^\s*}\s*,\s*\[\s*\]\s*$"

# State der nie gesetzt wird
grep -rn "const \[.*useState\]" src/ | awk -F',' '{print $2}' | while read setter; do
    count=$(grep -r "${setter// /}" src/ | wc -l)
    [ "$count" -lt 2 ] && echo "Ungenutzter Setter: $setter"
done
```

## Verbindungs-Prüfung (Wiring)

Prüft ob implementierte Teile tatsächlich zusammenhängen:

```bash
# Wird der neue Service importiert?
grep -rn "import.*<ServiceName>\|from.*<module>" src/

# Wird die neue Komponente gerendert?
grep -rn "<ComponentName" src/

# Ist die neue Route registriert?
grep -rn "/<route-path>" src/

# Ist der neue Handler verbunden?
grep -rn "\.use\(<handler>\)\|add_middleware\|include_router" src/
```

## Checkliste für Reviewer

Nach einer Implementierung:

- [ ] Stub-Scan auf neue/geänderte Dateien ausgeführt?
- [ ] Neue Funktionen/Klassen tatsächlich aufgerufen (importiert, gemountet, registriert)?
- [ ] Tests testen Verhalten, nicht Implementierungsdetails?
- [ ] Keine hardcodierten Werte wo dynamische erwartet werden?
