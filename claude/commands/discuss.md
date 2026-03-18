---
description: Architektur-Entscheidung oder zwei Ansätze durch Council diskutieren
argument-hint: [frage, zwei optionen oder architekturfrage]
---

Du führst eine strukturierte **Council-Diskussion** durch.
Drei Perspektiven beleuchten die Frage in mehreren Runden und suchen Konsens.

**Diskussions-Gegenstand:** $ARGUMENTS

---

## Setup

**Schritt 1 — Gegenstand verstehen:**
- Lies alle relevanten Dateien wenn Code oder Architektur betroffen ist
- Formuliere die Kernfrage in einem Satz
- Falls zwei Optionen erkennbar: benenne sie als **Option A** und **Option B**

**Schritt 2 — Runden festlegen:**
Standard sind 3 Runden. Falls der Nutzer eine andere Zahl (2–5) angegeben hat, verwende diese.

Zeige zu Beginn:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Council-Diskussion: <kernfrage>
  Runden: <n> | Early Stop: aktiv
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Council-Mitglieder

Lade die Rollen aus den Agent-Definitionen:
- `claude/agents/council-generalist.md` → Gesamtbild, Machbarkeit
- `claude/agents/council-developer.md` → Technische Umsetzung
- `claude/agents/council-reviewer.md` → Qualität, Security, Risiken

Falls `DEBUG_MODE: on` in MEMORY.md, nach jeder Runde pro Agent ausgeben (Format aus `skills/model-routing/SKILL.md`):
```
[🔀 council-generalist]  Tier: Groß | Provider: <provider> | Modell: <modell>
                         Dauer: <Xs> | Tool-Calls: <n> | Token: ~<n> (geschätzt)
```

---

## Diskussions-Ablauf

Für jede Runde (1 bis max):

### Runde N / max

Gib für alle drei Mitglieder die Position aus. Ab Runde 2 reagieren sie auf die vorigen Positionen.

**[Generalist] Runde N**
*(Perspektive: Gesamtbild, Machbarkeit, Konsequenzen)*
<analyse/reaktion>
Votum: ✅ | ⚠ | ❌
Konsens-Signal: möglich | kein Konsens

---

**[Developer] Runde N**
*(Perspektive: Technische Umsetzung, Implementierungsaufwand)*
<analyse/reaktion>
Votum: ✅ | ⚠ | ❌
Konsens-Signal: möglich | kein Konsens

---

**[Reviewer] Runde N**
*(Perspektive: Qualität, Security, Risiken)*
<analyse/reaktion>
Votum: ✅ | ⚠ | ❌
Konsens-Signal: möglich | kein Konsens

---

**Konsens-Check nach Runde N:**
Alle drei "Konsens-Signal: möglich"? → Early Stop, Konsens erreicht.
Mindestens einer "kein Konsens" + letzte Runde? → HitL.
Sonst → nächste Runde.

---

## Abschluss — Konsens

Wenn Konsens erreicht:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Entscheidung: <thema>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Konsens nach Runde <N>: ✅ <option/ansatz>

  Begründung:
  <2-3 Sätze warum diese Entscheidung>

  Auflagen (falls ⚠):
  - <bedingung>

  Nächste Schritte:
  → <was als nächstes zu tun ist>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Abschluss — Kein Konsens (HitL)

Wenn nach max Runden kein Konsens:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Kein Konsens — du entscheidest
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Streitpunkt: <worum geht es konkret>

  Lager A (<mitglieder>):
  → <position in 1-2 Sätzen>
  Pro: <vorteil>
  Con: <risiko>

  Lager B (<mitglieder>):
  → <position in 1-2 Sätzen>
  Pro: <vorteil>
  Con: <risiko>

  Meine Empfehlung (wenn vorhanden): <empfehlung>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Warte auf Nutzer-Entscheidung. Danach: Empfehle `/implement` oder `/plan` als nächsten Schritt.

---

## CONTEXT.md schreiben (bei Konsens)

Nach einem Konsens-Abschluss: Entscheidung als CONTEXT.md im Projektverzeichnis sichern.

Falls `/workspace/<projekt>/` existiert oder das aktuelle Verzeichnis ein Workspace-Projekt ist:

```markdown
# CONTEXT.md — <thema>

Entscheidung getroffen: <datum>

## Entscheidung

<entscheidung in 1-2 Sätzen>

## Begründung

<warum diese Option — aus dem Council-Konsens>

## Auflagen / Einschränkungen

<falls vorhanden>

## Nicht-Entschieden

<was bewusst offen gelassen wurde>
```

Diese Datei wird von nachfolgenden `/implement`- und `/plan`-Calls geladen um
Re-Diskussionen bereits getroffener Entscheidungen zu vermeiden.
