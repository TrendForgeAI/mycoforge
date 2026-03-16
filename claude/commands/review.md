---
description: Code Review aus drei Perspektiven (Council-Muster, 3 Runden)
argument-hint: [datei, PR-nummer oder beschreibung]
---

Du führst ein strukturiertes **Code Review** nach dem Council-Muster durch.
Drei Perspektiven beleuchten den Code in bis zu 3 Runden, dann Konsens oder HitL.

**Review-Gegenstand:** $ARGUMENTS

Falls kein Argument angegeben: reviewe die aktuell geänderten Dateien (`git diff --staged` oder `git diff HEAD~1`).

---

## Schritt 1 — Code lesen

Lies alle relevanten Dateien vollständig. Verstehe was geändert wurde und warum.
Zeige zu Beginn:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Code Review: <titel>
  Runden: 3 | Early Stop: aktiv
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Lade die Council-Rollen:
- `claude/agents/council-generalist.md`
- `claude/agents/council-developer.md`
- `claude/agents/council-reviewer.md`

Falls `DEBUG_MODE: on` in MEMORY.md, Routing für alle drei Council-Agents ausgeben:
```
[🔀 council-generalist]  Tier: Groß | Provider: <provider> | Modell: <modell>
[🔀 council-developer]   Tier: Groß | Provider: <provider> | Modell: <modell>
[🔀 council-reviewer]    Tier: Groß | Provider: <provider> | Modell: <modell>
```

---

## Schritt 2 — Council-Diskussion (3 Runden max.)

### Runde 1 — Initiale Positionen

**[Generalist] Runde 1**
*(Gesamtbild, Struktur, Verständlichkeit)*
Ist der Code verständlich und gut strukturiert? Löst er das Problem direkt?
Gibt es unnötige Komplexität?
Votum: ✅ | ⚠ | ❌
Konsens-Signal: möglich | kein Konsens

---

**[Developer] Runde 1**
*(Technische Korrektheit, Edge Cases, Performance)*
Ist die Implementierung korrekt? Edge Cases abgedeckt? Performance-Probleme?
Code-Stil konsistent?
Votum: ✅ | ⚠ | ❌
Konsens-Signal: möglich | kein Konsens

---

**[Reviewer] Runde 1**
*(Security, Fehlerbehandlung, Tests, Deployment-Risiken)*
Security-Probleme (Injection, Auth, Secrets)? Fehlerbehandlung ausreichend?
Tests vorhanden / nötig?
Votum: ✅ | ⚠ | ❌
Konsens-Signal: möglich | kein Konsens

---

**Konsens-Check:** Alle "möglich"? → Early Stop. Sonst → Runde 2.

---

### Runde 2 — Reaktion (falls nötig)

Mitglieder reagieren auf Positionen der anderen. Annäherung oder Beibehaltung mit Begründung.

**[Generalist] Runde 2** — Reaktion
...
Votum: ✅ | ⚠ | ❌ | Konsens-Signal: möglich | kein Konsens

**[Developer] Runde 2** — Reaktion
...
Votum: ✅ | ⚠ | ❌ | Konsens-Signal: möglich | kein Konsens

**[Reviewer] Runde 2** — Reaktion
...
Votum: ✅ | ⚠ | ❌ | Konsens-Signal: möglich | kein Konsens

**Konsens-Check:** Alle "möglich"? → Early Stop. Sonst → Runde 3.

---

### Runde 3 — Finale Positionen (falls nötig)

Finale Konsolidierung. Klares Votum.

**[Generalist] Runde 3** — Finale Position
...
Votum: ✅ | ⚠ | ❌ | Konsens-Signal: möglich | kein Konsens

**[Developer] Runde 3** — Finale Position
...
Votum: ✅ | ⚠ | ❌ | Konsens-Signal: möglich | kein Konsens

**[Reviewer] Runde 3** — Finale Position
...
Votum: ✅ | ⚠ | ❌ | Konsens-Signal: möglich | kein Konsens

---

## Schritt 3 — Konsens oder HitL

### Bei Konsens: Review-Zusammenfassung

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Code Review: <titel>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Urteil: ✅ Approved | ⚠ Approved mit Anmerkungen | ❌ Changes requested

  Muss-Änderungen (Blocker):
  ❌ <issue — datei:zeile wenn möglich>

  Soll-Änderungen:
  ⚠ <issue>

  Kann-Änderungen:
  💡 <suggestion>

  Positives:
  ✓ <was gut ist>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Bei **Approved / Approved mit Anmerkungen**: schlage `/commit` vor.
Bei **Changes requested**: erkläre konkret was geändert werden muss.

### Bei Kein Konsens nach Runde 3 (HitL)

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Kein Konsens — du entscheidest
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Streitpunkt: <worum genau geht es>

  Lager A (<mitglieder>): <position>
  Lager B (<mitglieder>): <position>

  Wie möchtest du vorgehen?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
