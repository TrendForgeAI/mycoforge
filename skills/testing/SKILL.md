# testing

## Wann laden?
Beim Schreiben oder Ausführen von Tests, bei CI/CD-Konfiguration,
bei Coverage-Analysen.

## Kontext

Tests laufen vor jedem Commit. Coverage-Ziele sind projektspezifisch
(siehe Projekt-CLAUDE.md). Frameworks nach Stack-Standard:

| Stack | Unit | E2E | Coverage-Ziel |
|-------|------|-----|---------------|
| Web-App (TS) | Vitest | Playwright | 80% |
| Backend (TS) | Jest | — | 80% |
| Backend (Python) | pytest | — | 80% |
| Fullstack | Vitest | Playwright | 80% |
| CLI (TS) | Jest | — | 70% |
| CLI (Python) | pytest | — | 70% |
| Library | Vitest / pytest | — | 90% |

## Vorgehen

### Test schreiben
```
1. Zu testende Einheit verstehen (lesen!)
2. Testfälle definieren: Happy Path · Edge Cases · Error Cases
3. Test schreiben (Arrange → Act → Assert)
4. Test ausführen, Fehler beheben
5. Coverage prüfen
```

### Guter Test
- **Arrange:** Setup klar und minimal
- **Act:** Eine einzige Aktion testen
- **Assert:** Konkret, kein "truthy" wenn spezifisch möglich
- Name beschreibt Verhalten: `should return 404 when user not found`

### Schlechter Test
- Testet Implementierungsdetails statt Verhalten
- Mehrere unabhängige Assertions die verschiedene Dinge testen
- Zu viel Setup-Boilerplate → Hinweis auf schlechtes Design

## Frameworks

### Vitest (TypeScript)
```typescript
import { describe, it, expect, beforeEach } from 'vitest'

describe('UserService', () => {
  it('should throw when user not found', async () => {
    await expect(service.getUser('unknown')).rejects.toThrow('Not found')
  })
})
```

### Jest (TypeScript/Node)
```typescript
describe('router', () => {
  it('selects haiku for file operations', () => {
    expect(router.select({ type: 'file-op' })).toBe('claude-haiku-4-5')
  })
})
```

### pytest (Python)
```python
def test_router_selects_haiku_for_file_ops():
    result = router.select(task_type="file-op")
    assert result == "claude-haiku-4-5"
```

### Playwright (E2E)
```typescript
test('user can log in', async ({ page }) => {
  await page.goto('/login')
  await page.fill('[name=email]', 'user@example.com')
  await page.fill('[name=password]', 'secret')
  await page.click('[type=submit]')
  await expect(page).toHaveURL('/dashboard')
})
```

## Beispiele

```bash
# Vitest
npx vitest run
npx vitest run --coverage

# Jest
npx jest --coverage

# pytest
pytest --cov=src tests/

# Playwright
npx playwright test
```
