# Conventional Commits

**Kategorien:** development-workflow | **Rollen:** committer, developer, devops | **Tier:** 3
**Referenz:** https://www.conventionalcommits.org

## Core Concepts

**Schema:**
```
<type>[!][(optional scope)]: <description>

[optional body]

[optional footer(s)]
```

| Type | Bedeutung | SemVer |
|------|-----------|--------|
| `feat` | Neues Feature | MINOR ↑ |
| `fix` | Bug-Fix | PATCH ↑ |
| `docs` | Nur Dokumentation | — |
| `refactor` | Code-Änderung ohne Feature/Fix | — |
| `test` | Tests hinzugefügt oder geändert | — |
| `chore` | Build, Tooling, Dependencies | — |
| `style` | Formatierung (kein Semantik-Impact) | — |
| `perf` | Performance-Verbesserung | — |
| `!` | BREAKING CHANGE | MAJOR ↑ |

## Wann einsetzen

- Jeder Commit in mycoforge und allen /workspace/-Projekten
- Automatische CHANGELOG-Generierung
- Semantische Versionierung in CI/CD

## Verwandte Anchors

- Semantic Versioning: `@knowledge/anchors/semantic-versioning.md`
