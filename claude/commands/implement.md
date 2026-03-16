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

### 3. Review

Nach allen Implementierungs-Tasks:
- Lade `claude/agents/reviewer.md`
- Review aller geänderten Dateien
- Bei Critical Findings: sofort beheben, dann erneut reviewen
- Bei Warning/Suggestion: dem Nutzer melden

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

### 6. Abschluss

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Implementierung abgeschlossen
  Geänderte Dateien: <liste>
  Commit: <hash> — <message>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
