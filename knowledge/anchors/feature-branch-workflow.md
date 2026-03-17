# Feature Branch Workflow

**Kategorien:** development-workflow | **Rollen:** committer, developer, team-lead | **Tier:** 2
*Auch bekannt als: GitHub Flow (vereinfacht)*

## Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Feature Branch** | Jedes Feature / jeder Bugfix auf eigenem Branch |
| **Kurzlebige Branches** | Branches so kurz wie möglich — max. 1-2 Tage |
| **Pull Request** | Code Review vor dem Merge in main |
| **main ist immer deploybar** | Kein defekter Code auf main |
| **Atomic Commits** | Jeder Commit = eine abgeschlossene, revertierbare Einheit |

**Branch-Naming:**
```
feature/<kurzbeschreibung>   z.B. feature/oauth-login
fix/<kurzbeschreibung>       z.B. fix/null-pointer-payment
chore/<kurzbeschreibung>     z.B. chore/update-dependencies
```

## Wann einsetzen

- Alle /workspace/-Projekte mit mehr als einem Entwickler
- Isolierte Feature-Entwicklung ohne main zu destabilisieren
- Git Worktree Support (mycoforge TODO)
