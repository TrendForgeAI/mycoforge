# mycoforge TODO

Alle Punkte des Gesamtoptimierungs-Arbeitsplans sind abgeschlossen.

---

## Erledigt

### Gesamtoptimierung (2026-03-18)
- [x] Externe Referenzen entfernen (GSD, superpowers, Semantic-Anchors)
- [x] Gesamt-Architektur ausarbeiten — ARCHITECTURE.md als Explanation-Dokument neu geschrieben
- [x] Namenskonventionen festlegen & durchsetzen — Regeln in CLAUDE.md, `finish-branch` umbenannt
- [x] Agent-Definitionen normalisieren — alle 12 Agents einheitlich strukturiert
- [x] Security-Audit — secrets-scan.sh gestärkt, JSON-Fix in post-bash hook
- [x] Dokumentation aktualisieren — README.md + docs/usage.md (Anwender-Doku)

### Cleanup & Grundlagen (2026-03-18)
- [x] MEMORY.md aus git-Tracking entfernen — wird bei Container-Start generiert

### Inspiration & Adoption (2026-03-17)
- [x] Externe Inspirationsquellen evaluiert und sinnvolle Patterns übernommen
- [x] `knowledge/semantic-anchors.md` anlegen (Terminologie + Best-Practice-Anchors)
- [x] Context Rot Prevention: STATE.md Konzept evaluieren und implementieren
- [x] `/verify` Command: Implementierung nach /implement auf Funktionsfähigkeit prüfen
- [x] tester-Agent: TDD Workflow RED→GREEN→REFACTOR ergänzen
- [x] Git Worktree Support für isolierte Feature-Entwicklung

### Public Release (2026-03-17)
- [x] Alle persönlichen Daten aus Repo entfernen
- [x] Git-History squashen (orphan branch, force push)
- [x] Repo auf Public gestellt
