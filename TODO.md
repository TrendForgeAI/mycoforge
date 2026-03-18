# mycoforge TODO

## Arbeitsplan

Die Punkte sind in logischer Reihenfolge sortiert: erst aufräumen, dann Fundament legen,
dann darauf aufbauen. Jeden Punkt mit `/commit` abschließen.

---

### ~~1. Externe Referenzen entfernen~~ ✓

---

### ~~2. Gesamt-Architektur ausarbeiten~~ ✓

---

### ~~3. Namenskonventionen festlegen & durchsetzen~~ ✓

---

### ~~4. Agent-Definitionen normalisieren~~ ✓

**Command:** `/implement` — "Alle Agent-Definitionen auf einheitliches Format bringen"

---

### 5. Security-Audit
**Warum vor Doku:** Sicherheitslücken sollten behoben sein bevor das Projekt
dokumentiert und als Referenz genutzt wird.

Aufgaben:
- Hooks und Shell-Skripte auf Command-Injection, unsichere Patterns prüfen
- Secrets-Scan (`hooks/secrets-scan.sh`) auf Vollständigkeit und Korrektheit prüfen
- `.gitignore` und `.env.example` auf Lücken prüfen
- Findings beheben

**Command:** `/review` — "Security-Audit: Hooks, Shell-Skripte, Secrets-Scan"

---

### 6. Dokumentation aktualisieren & Anwender-Doku erstellen
**Warum zuletzt:** Erst wenn alles stabil ist, lohnt sich vollständige Dokumentation —
sonst muss sie nach jedem der vorherigen Schritte angepasst werden.

Aufgaben:
- `README.md`: neue Commands, Skills, Patterns einpflegen
- `CLAUDE.md`: Projektstruktur, Pfade, Arbeitsweise aktualisieren
- Anwender-Dokumentation: "Wie nutze ich mycoforge?" — Commands, Workflows, Beispiele

**Command:** `/implement` — "README.md, CLAUDE.md und Anwender-Doku auf aktuellen Stand bringen"

---

## Erledigt

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
