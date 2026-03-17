# Anchors: Committer

> Lade diese Datei wenn du als Committer-Agent arbeitest und Git-Workflow-Methodiken benötigst.

---

## Conventional Commits
**Kategorien:** development-workflow | **Rollen:** committer, developer, devops | **Tier:** 3
**Referenz:** Benjamin E. Coe, Steve Mao — https://www.conventionalcommits.org

### Core Concepts

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
| `!` | BREAKING CHANGE (im Type oder Footer) | MAJOR ↑ |

**BREAKING CHANGE:** entweder `feat!:` oder `BREAKING CHANGE:` im Footer.

### Wann einsetzen

- Jeder Commit in mycoforge und allen /workspace/-Projekten
- Automatische CHANGELOG-Generierung
- Semantische Versionierung (CI/CD kann SemVer-Bump ableiten)
- Team-Kommunikation über Art der Änderungen

### Beispiele

```
feat(auth): add OAuth2 login flow
fix(api): handle null response from payment provider
docs(readme): update installation instructions
refactor(db): extract connection pool to separate module
feat!: change API response format to JSON:API spec

BREAKING CHANGE: all API consumers must update response parsing
```

---

## Semantic Versioning
**Kategorien:** development-workflow | **Rollen:** committer, devops, architect | **Tier:** 2
*SemVer*
**Referenz:** Tom Preston-Werner — https://semver.org

### Core Concepts

**Format:** `MAJOR.MINOR.PATCH`

| Teil | Wann erhöhen | Beispiel |
|------|-------------|---------|
| **MAJOR** | Inkompatible API-Änderungen (Breaking Changes) | 2.0.0 |
| **MINOR** | Neue Funktionalität rückwärtskompatibel | 1.3.0 |
| **PATCH** | Bugfixes rückwärtskompatibel | 1.2.7 |

**Besondere Versionen:**
- `0.y.z` — Initiale Entwicklung, API gilt als instabil
- `1.0.0` — Erste stabile Public API
- Pre-release: `1.0.0-alpha.1`, `1.0.0-beta.2`, `1.0.0-rc.1`
- Build-Metadata: `1.0.0+20241111` (ignoriert beim Vergleich)

**Zusammenspiel mit Conventional Commits:**
- `feat:` → MINOR ↑
- `fix:` → PATCH ↑
- `feat!:` / `BREAKING CHANGE:` → MAJOR ↑

### Wann einsetzen

- Libraries und APIs mit öffentlichen Interfaces
- Dependency-Management (npm, pip, cargo)
- Release-Planung: Was bedeutet das nächste Release?

---

## Feature Branch Workflow
**Kategorien:** development-workflow | **Rollen:** committer, developer, team-lead | **Tier:** 2
*Auch bekannt als: GitHub Flow (vereinfacht), GitFlow (komplexer)*

### Core Concepts

| Begriff | Bedeutung |
|---------|-----------|
| **Feature Branch** | Jedes Feature / jeder Bugfix auf eigenem Branch |
| **Kurzlebige Branches** | Branches so kurz wie möglich halten — max. 1-2 Tage |
| **Pull Request / Merge Request** | Code Review vor dem Merge in main |
| **main ist immer deploybar** | Kein defekter Code auf main |
| **Atomic Commits** | Jeder Commit = eine abgeschlossene, revertierbare Einheit |
| **Squash vor Merge** | Feature-Branch-Commits zusammenführen für saubere History |

**Branch-Naming Convention:**
```
feature/<kurzbeschreibung>     z.B. feature/oauth-login
fix/<kurzbeschreibung>         z.B. fix/null-pointer-payment
chore/<kurzbeschreibung>       z.B. chore/update-dependencies
docs/<kurzbeschreibung>        z.B. docs/api-reference
```

### Wann einsetzen

- Alle /workspace/-Projekte mit mehr als einem Entwickler
- Isolierte Feature-Entwicklung ohne main zu destabilisieren
- Git Worktree Support (mycoforge TODO: isolierte Feature-Entwicklung)

### Abgrenzung: GitHub Flow vs. GitFlow

| GitHub Flow | GitFlow |
|-------------|---------|
| main + feature branches | main + develop + feature + release + hotfix |
| Einfach, schnell | Komplex, für Release-Zyklen |
| CI/CD-freundlich | Für traditionelle Release-Prozesse |
| **Empfohlen für mycoforge-Projekte** | Nur wenn lange Release-Zyklen nötig |
