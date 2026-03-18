# Checkpoint-Protokoll

## Wann laden?
Wenn unklar ist ob pausiert oder direkt weitergefahren werden soll.
Als Referenz für Command-Implementierungen: wann welchen Checkpoint-Typ verwenden.

## Grundprinzip

**Claude automatisiert alles was mit CLI/API möglich ist.**

Nie den Nutzer bitten etwas auszuführen das Claude selbst ausführen kann.
Nur drei Situationen erfordern einen echten Stopp.

## Die drei Checkpoint-Typen

### 1. Human-Verify (~90% der Checkpoints)

**Was:** Nutzer bestätigt dass das Ergebnis dem Erwarteten entspricht.

**Wann:** Nach automatisierten Aktionen mit sichtbarem, prüfbarem Ergebnis.

Beispiele:
- Nach `/implement`: sieht der Output wie erwartet aus?
- Nach Datenbankänderung: sind die Daten korrekt migriert?
- Nach Deployment: ist die URL erreichbar?

Format:
```
Bitte prüfen: <was zu sehen sein sollte>
Wo:           <url, datei, oder terminal-befehl zum prüfen>

Bestätigen oder Problem melden — dann weiter mit: /<nächster-command>
```

---

### 2. Decision (~9% der Checkpoints)

**Was:** Architekturentscheidung mit mehreren validen Optionen.

**Wann:** Wenn Claude nicht alleine entscheiden kann — weil die Entscheidung
Kontext braucht der beim Nutzer liegt (Business-Logik, Priorität, externe Abhängigkeiten).

Beispiele:
- Zwei valide Datenbankschemas mit unterschiedlichen Trade-offs
- Externe Abhängigkeit ja/nein (Vendor-Lock-in vs. Eigenentwicklung)
- Feature-Scope unklar

Format: **AskUserQuestion** mit 2–4 klar beschriebenen Optionen.

Nicht als Decision verwenden für:
- Stilfragen (gibt es Best Practices → diese anwenden)
- Dinge die Claude selbst recherchieren kann (erst recherchieren, dann entscheiden)
- Offensichtliche technische Entscheidungen

---

### 3. Human-Action (~1% der Checkpoints)

**Was:** Aktion die Claude technisch nicht ausführen kann oder darf.

**Wann:** Authentifizierung, Berechtigungen, externe Systeme ohne API-Zugang.

Beispiele:
- Passwort-Eingabe für externe Dienste
- E-Mail-Bestätigung
- Manuelles Mergen wenn bewusst gewünscht

Format:
```
Manuelle Aktion nötig: <was zu tun ist>
Danach:               /<nächster-command>
```

## Anti-Patterns

- ❌ Nach CLI-Befehlen fragen die Claude selbst ausführen kann
- ❌ Auf Bestätigung warten wenn die nächste Aktion eindeutig ist
- ❌ Zu viele Checkpoints — jeder unnötige Stopp unterbricht den Flow
- ❌ Decision-Checkpoint für Stilfragen oder recherchierbare Fakten
