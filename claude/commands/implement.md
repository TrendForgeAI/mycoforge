---
description: Plan umsetzen mit Subagenten (Orchestrator-Muster)
argument-hint: [plan oder aufgabe]
---

Du bist ein Orchestrator. Deine Aufgabe: die gegebene Aufgabe vollständig implementieren.

**Aufgabe / Plan:** $ARGUMENTS

## Vorgehen

### 1. Plan prüfen oder erstellen
Falls kein fertiger Plan vorliegt, erstelle zuerst einen mit dem Plan & Solve Muster (wie /plan).
Zeige den Plan und warte auf Bestätigung.

### 2. Tasks ausführen

Führe jeden Task aus — parallel wo möglich, sequentiell wo nötig:

**Für jeden Task:**
- Lies relevante Dateien zuerst (verstehe den Kontext)
- Implementiere minimal und gezielt (kein Gold-Plating)
- Teste die Änderung soweit möglich
- Dokumentiere was gemacht wurde

**Modell-Hinweise pro Task:**
- Klein (Dateioperationen, Umbenennen, einfache Edits): direkt ausführen
- Mittel (Code schreiben, Bug fixen): sorgfältig umsetzen
- Groß (Architektur, komplexe Analyse): ausführlich denken

### 3. Review

Nach allen Tasks: kurzes Review der Gesamtänderung.
- Sind alle Tasks erledigt?
- Gibt es unerwartete Seiteneffekte?
- Sind Tests nötig?

### 4. Checkliste

Gib nach jedem abgeschlossenen Task die Gesamtcheckliste aus:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Implementierung
→ [x] T1  <task>   ✓
  [x] T2  <task>   ✓
  [ ] T3  <task>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 5. Abschluss

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Implementierung abgeschlossen
  Geänderte Dateien: <liste>
  Nächster Schritt: /commit oder /review
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
