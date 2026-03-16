# code-style

## Wann laden?
Beim Schreiben von neuem Code, bei Reviews, beim Einrichten von
Linter/Formatter in einem neuen Projekt.

## Kontext

Konsistenter Code-Stil reduziert kognitiven Aufwand beim Lesen.
Formatter (Prettier, Ruff) entscheiden über Formatierung — nie manuell.
Linter (ESLint, Ruff) finden Logik-Probleme — diese ernst nehmen.

## Grundprinzipien

- **Lesbarkeit vor Cleverness** — Code wird öfter gelesen als geschrieben
- **Explizit vor implizit** — klare Namen, keine Abkürzungen
- **Keine Kommentare für offensichtlichen Code** — Code selbst erklären
- **Kommentare für das Warum** — nie für das Was
- **Kleine Funktionen** — eine Funktion, eine Aufgabe

## TypeScript / JavaScript

### Formatter: Prettier
```json
{
  "semi": false,
  "singleQuote": true,
  "printWidth": 100,
  "trailingComma": "all"
}
```

### Linter: ESLint
```bash
npx eslint src/ --fix
npx prettier src/ --write
```

### Konventionen
```typescript
// Benennung
const userName = 'alice'          // camelCase für Variablen
function getUserById() {}         // camelCase für Funktionen
class UserService {}              // PascalCase für Klassen
const MAX_RETRIES = 3             // SCREAMING_SNAKE für Konstanten
type UserId = string              // PascalCase für Types/Interfaces

// Async/Await statt .then()
const user = await getUser(id)    // ✅
getUser(id).then(u => ...)        // ❌ wenn await möglich

// Früh zurückgeben statt verschachteln
if (!user) return null            // ✅
if (user) { ... }                 // ❌ bei einfachem Guard

// Destructuring
const { name, email } = user      // ✅
const name = user.name            // ❌ bei mehreren Properties
```

## Python

### Formatter + Linter: Ruff
```bash
ruff check src/ --fix
ruff format src/
```

### Konventionen
```python
# Benennung
user_name = "alice"           # snake_case für Variablen/Funktionen
class UserService:            # PascalCase für Klassen
MAX_RETRIES = 3               # SCREAMING_SNAKE für Konstanten
_internal_func()              # _prefix für interne Funktionen

# Type hints immer bei Funktionen
def get_user(user_id: str) -> User | None:
    ...

# f-strings statt format()
f"Hello {name}"               # ✅
"Hello {}".format(name)       # ❌
```

## Einrichtung in neuem Projekt

### TypeScript
```bash
npm install -D eslint prettier eslint-config-prettier
npx eslint --init
echo '{}' > .prettierrc.json
```

### Python
```bash
uv add --dev ruff
# pyproject.toml:
# [tool.ruff]
# line-length = 100
```

### Pre-commit Hook (falls gewünscht)
```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.4.0
    hooks:
      - id: ruff
      - id: ruff-format
```

## Beispiele

**Schlecht:**
```typescript
function p(u: any) {
  if (u != null) {
    if (u.active == true) {
      return u.name
    }
  }
  return null
}
```

**Gut:**
```typescript
function getUserName(user: User | null): string | null {
  if (!user?.active) return null
  return user.name
}
```
