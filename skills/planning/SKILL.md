# planning

## Wann laden?
Bei neuen, nicht-trivialen Aufgaben — bevor Code geschrieben wird.
Trigger: Nutzer beschreibt ein Feature, eine Refaktorierung oder ein Bug-Fix
der mehr als eine Datei betrifft.

## Kontext

Planung verhindert unnötige Iterationen. Erst verstehen, dann umsetzen.
Das Plan & Solve Muster zerlegt Aufgaben in unabhängige, parallelisierbare Tasks.

## Vorgehen

### 1. Aufgabe verstehen
- Was soll erreicht werden? (Ziel, nicht Implementierung)
- Was ist der aktuelle Stand? (relevante Dateien lesen)
- Gibt es Abhängigkeiten zu anderen Teilen?

### 2. Tasks definieren
```
Aufgabe
├── Task A  (unabhängig)
├── Task B  (unabhängig)
│   ├── SubTask B1
│   └── SubTask B2
└── Task C  (braucht A + B)
```

Für jeden Task:
- Scope: welche Dateien/Module betroffen?
- Abhängigkeiten: was muss vorher fertig sein?
- Modell-Tier: Klein / Mittel / Groß?

### 3. Reihenfolge festlegen
- Unabhängige Tasks → parallel möglich
- Abhängige Tasks → sequentiell
- Kritischen Pfad identifizieren

### 4. Plan mit Nutzer abstimmen (HitL Phase 1)
Plan ausgeben, Bestätigung einholen bevor Umsetzung beginnt.

## Ausgabeformat

```
## Plan: <Aufgabentitel>

**Ziel:** <Ein Satz>

**Tasks:**
1. [ ] <Task A> — <Scope> — <Modell-Tier>
2. [ ] <Task B> — <Scope> — <Modell-Tier>
   2a. [ ] <SubTask B1>
   2b. [ ] <SubTask B2>
3. [ ] <Task C> — braucht 1+2 — <Modell-Tier>

**Parallel möglich:** Task 1 + 2
**Sequentiell:** Task 3 nach 1+2

Soll ich so vorgehen?
```

## Beispiele

**Klein (kein Plan nötig):**
- Einzelne Datei umbenennen
- Typo in Docs fixen
- Einfaches Refactoring einer Funktion

**Mittel (kurzer Plan):**
- Neue Route in einer API
- Komponente mit State hinzufügen
- Tests für ein Modul schreiben

**Groß (ausführlicher Plan mit HitL):**
- Neues Feature über mehrere Module
- Architektur-Änderung
- Migration / Refaktorierung
