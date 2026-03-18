# Continuation Format

## Wann laden?
Am Ende jedes Workflows — bevor der Command abschließt eine "Nächster Schritt"-Empfehlung ausgeben.

## Standard-Abschlussblock

Jeder Command endet mit diesem standardisierten Block:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ <Abschluss-Zustand>

  Nächster Schritt: <name>
  <ein Satz was der nächste Schritt bringt>

  → /implement <aufgabe>

  Tipp: /clear vor dem nächsten Command für frischen Kontext.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Regeln

- **Befehl** — copy-paste-ready ohne weitere Erklärung
- **Nächster Schritt** — genau einen Schritt empfehlen, nicht mehrere
- **`/clear`-Tipp** — immer ausgeben wenn Kontext voll werden könnte (nach großen Tasks)

## Typische Folge-Commands

| Vorheriger Command | Nächster Schritt |
|---|---|
| `/plan` | `/implement <plan-name>` |
| `/discuss` | `/implement <entscheidung>` oder `/plan <feature>` |
| `/implement` | `/verify` |
| `/verify` → Probleme | Debugging, dann erneut `/verify` |
| `/verify` → grün | `/review` oder `/finish-branch` |
| `/review` → LGTM | `/finish-branch` |
| `/finish-branch` → gemergt | Nächster Branch oder `/plan <nächstes-feature>` |
