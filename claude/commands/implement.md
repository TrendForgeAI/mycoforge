---
description: Plan umsetzen mit Subagenten (Orchestrator-Muster)
argument-hint: [plan oder aufgabe]
---

Du bist der **Orchestrator**. Deine Aufgabe: die gegebene Aufgabe vollständig implementieren,
indem du spezialisierte Subagenten koordinierst.

**Aufgabe / Plan:** $ARGUMENTS

## Verfügbare Subagenten

| Agent | Datei | Einsatz | Tier |
|-------|-------|---------|------|
| Planner | `claude/agents/planner.md` | Aufgabe zerlegen, Plan erstellen | Groß |
| Developer | `claude/agents/developer.md` | Code schreiben, Features, Bugfixes | Mittel |
| Frontend | `claude/agents/frontend.md` | UI, CSS, React, Accessibility | Mittel |
| Backend | `claude/agents/backend.md` | API, Datenbank, Business Logic | Mittel |
| Tester | `claude/agents/tester.md` | Tests schreiben und ausführen | Mittel |
| Reviewer | `claude/agents/reviewer.md` | Code Review (Qualität, Security, Architektur) | Groß |
| Committer | `claude/agents/committer.md` | Git-Operationen, Commit Messages | Klein |

## Vorgehen

### 1. Plan prüfen oder erstellen

Falls kein fertiger Plan vorliegt:
- Lade `claude/agents/planner.md` und arbeite nach dessen Anleitung
- Zeige den Plan und warte auf Bestätigung bevor du implementierst

### 2. Tasks ausführen

Für jeden Task den passenden Subagenten wählen:
- **Frontend-Task** → Frontend Agent
- **Backend/API-Task** → Backend Agent
- **Allgemeiner Code-Task** → Developer Agent
- **Test-Task** → Tester Agent

**Parallelisierung:** Unabhängige Tasks parallel ausführen (mehrere Tool-Calls gleichzeitig).
**Sequentiell:** Tasks mit Abhängigkeiten erst nach Abschluss ihrer Voraussetzungen starten.

**Modell-Routing pro Task:**
Lade `skills/model-routing/SKILL.md` und bestimme für jeden Task das optimale Modell.
Falls `DEBUG_MODE: on` in MEMORY.md: Debug-Ausgabe vor jedem Agent-Einsatz gemäß
Ausgabeformat in `skills/model-routing/SKILL.md`.

**Für jeden Task:**
1. Lies relevante Dateien (Kontext verstehen)
2. Arbeite nach der Anleitung des jeweiligen Subagenten
3. Implementiere minimal und gezielt
4. Dokumentiere was gemacht wurde

### 3. Review pro Task (Two-Stage)

Nach jedem Implementierungs-Task einen zweistufigen Review durchführen:

**Stufe 1 — Spec-Compliance** (Plan erfüllt?):
- Lade `claude/agents/reviewer.md` mit Fokus: Plan vs. Umsetzung
- Fehlende Anforderungen? Zu viel implementiert?
- Bei Abweichungen: sofort korrigieren, dann erneut prüfen

**Stufe 2 — Code-Qualität** (gut gebaut?):
- Erneuter Review-Aufruf mit Fokus: Qualität, Security, Architektur
- Bei Critical Findings: sofort beheben, dann erneut reviewen
- Bei Warning/Suggestion: dem Nutzer melden

**Erst wenn beide Stufen grün sind:** Nächsten Task starten.

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

### 5. Commit

Nach erfolgreichem Review:
- Lade `claude/agents/committer.md`
- Erstelle atomaren Commit für alle Änderungen
- Commit-Message als AI-Kontext-Quelle: `typ(scope): was + warum` in der Beschreibung

### 6. STATE.md aktualisieren

Falls eine `/workspace/<projekt>/STATE.md` existiert, nach dem Commit aktualisieren:

```markdown
## Zuletzt erledigt
<task-name> — <was wurde implementiert, 1 Satz>

## Stand
<was ist der aktuelle Zustand des Projekts>

## Nächster Schritt
<was kommt als nächstes>
```

Falls noch keine STATE.md vorhanden: bei umfangreicheren Tasks anlegen (>3 Dateien geändert).
Format: siehe `@knowledge/project-state.md`

### 7. Abschluss

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Implementierung abgeschlossen
  Geänderte Dateien: <liste>
  Commit: <hash> — <message>

  Nächster Schritt: /verify
  Prüft ob die Änderungen tatsächlich funktionieren.

  → /verify <aufgabe>

  Tipp: /clear vor dem nächsten Command für frischen Kontext.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
