# ADR-001 — Manifest-Layer für Commands und Agents einführen

**Status:** Accepted
**Datum:** 2026-03-18

---

## Kontext

Metadaten zu Commands und Agents waren implizit in Markdown-Dateien verteilt.
Beschreibungen wurden aus Headings gescrapt, Tiers über Konventionen erschlossen,
Abhängigkeiten zwischen Commands und Agents nirgends maschinenlesbar erfasst.

Das führte zu Drift zwischen Docs und Verhalten, erschwerter Toolbarkeit
und fehlender Grundlage für einen deterministischen MEMORY.md-Generator.

## Entscheidung

Ein `manifests/`-Verzeichnis mit zwei YAML-Dateien einführen:
- `manifests/commands.yaml` — alle 13 Commands mit Name, Beschreibung, Pattern, Tier, Agents
- `manifests/agents.yaml` — alle 12 Agents mit Name, Beschreibung, Tier, Pattern

Scope bewusst eng gehalten: nur Commands und Agents in v1.
Skills und Hooks folgen in späteren ADRs wenn konkreter Bedarf entsteht.

## Konsequenzen

**Positiv:**
- `scripts/generate-memory.py` kann Manifeste als Datenquelle nutzen (→ ADR-003)
- Neuen Command oder Agent hinzufügen = eine Datei ändern
- Konsistenz zwischen CLAUDE.md, MEMORY.md und tatsächlichen Dateien prüfbar

**Negativ / Tradeoffs:**
- Zwei Quellen müssen synchron gehalten werden: `claude/commands/*.md` + `manifests/commands.yaml`
- Disziplin erforderlich: bei neuem Command beide Dateien aktualisieren

## Alternativen erwogen

| Alternative | Warum verworfen |
|-------------|-----------------|
| Frontmatter in Command-Dateien erweitern | claude/ ist nicht in Git — kein zuverlässiger Parse-Pfad |
| Keine Manifeste, Generator scrapt Markdown | Fragil, bricht bei Formatänderungen still |
| Vollständiges Schema (inkl. Skills, Hooks) | Over-Engineering für v1 — erst wenn zweiter Consumer entsteht |
