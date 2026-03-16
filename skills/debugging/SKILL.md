# debugging

## Wann laden?
Bei unerwarteten Fehlern, failing Tests, unklarem Verhalten oder
wenn ein Bash-Befehl einen non-zero Exit-Code zurückgibt.

## Kontext

Debugging = Hypothesen bilden und systematisch prüfen.
Nie blind Fixes ausprobieren. Erst verstehen, dann beheben.

## Vorgehen

### 1. Fehler vollständig lesen
- Komplette Fehlermeldung + Stack Trace
- Welche Zeile wirft den Fehler?
- Welcher Aufruf hat ihn ausgelöst?

### 2. Hypothesen bilden
```
Mögliche Ursachen (von wahrscheinlich nach unwahrscheinlich):
1. Falscher Input-Typ / Null-Wert
2. Falsche Annahme über API-Rückgabe
3. Race Condition / async-Problem
4. Umgebungsproblem (fehlende Variable, falsche Version)
```

### 3. Hypothese prüfen
- Kleinsten reproduzierenden Test-Case schreiben
- Logging/Print an der richtigen Stelle ergänzen
- Zwischenwerte inspizieren

### 4. Ursache beheben
- Nur das Nötigste ändern
- Kein Refactoring während Debugging
- Fix beschreiben bevor er geschrieben wird

### 5. Regression-Test
- Test schreiben der genau diesen Bug abdeckt
- Sicherstellen dass alle anderen Tests noch grün sind

## Häufige Fehlertypen

| Fehler | Erste Schritte |
|--------|----------------|
| `TypeError: Cannot read property of undefined` | Herkunft des Wertes prüfen, Null-Check fehlt? |
| `404 Not Found` | URL korrekt? Route registriert? |
| `ENOENT: no such file` | Pfad korrekt? Relative vs. absolute Pfade? |
| `Permission denied` | `ls -la` auf Datei/Verzeichnis |
| `Port already in use` | `lsof -i :<port>` |
| Test schlägt fehl | Test-Output lesen, nicht sofort Code ändern |
| CI grün, lokal rot | Node/Python-Version prüfen, `.env` vorhanden? |
| CI rot, lokal grün | Fehlende env-Variable in CI, nicht committetes File |

## Debugging-Tools

```bash
# Node.js
node --inspect src/index.js
console.log(JSON.stringify(obj, null, 2))

# Python
import pdb; pdb.set_trace()
print(repr(value))

# Prozesse & Ports
lsof -i :3000
ps aux | grep node

# Logs
docker logs <container> --tail 50
journalctl -u service-name -n 50
```

## Anti-Pattern

- **Shotgun-Debugging:** Viele Änderungen auf einmal → unklar was geholfen hat
- **Kommentiertes Code-Graveyard:** Alten Code auskommentieren statt löschen
- **Hope-Driven Development:** `npm install` / `pip install` ohne Verständnis des Fehlers
- **Stack Overflow Copy-Paste:** Lösung nicht verstehen bevor sie eingefügt wird
