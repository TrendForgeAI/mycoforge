# Semantic Versioning

**Kategorien:** development-workflow | **Rollen:** committer, devops, architect | **Tier:** 2
*SemVer*
**Referenz:** Tom Preston-Werner — https://semver.org

## Core Concepts

**Format:** `MAJOR.MINOR.PATCH`

| Teil | Wann erhöhen |
|------|-------------|
| **MAJOR** | Inkompatible API-Änderungen (Breaking Changes) |
| **MINOR** | Neue Funktionalität rückwärtskompatibel |
| **PATCH** | Bugfixes rückwärtskompatibel |

**Besondere Versionen:**
- `0.y.z` — Initiale Entwicklung, API gilt als instabil
- `1.0.0` — Erste stabile Public API
- Pre-release: `1.0.0-alpha.1`, `1.0.0-rc.1`

**Zusammenspiel mit Conventional Commits:**
- `feat:` → MINOR ↑ | `fix:` → PATCH ↑ | `feat!:` / `BREAKING CHANGE:` → MAJOR ↑
