# frontend

## Wann laden?
Bei UI-Entwicklung: Komponenten, CSS, Layouts, Accessibility,
React/Vue/Svelte, responsive Design.

## Kontext

Frontend-Entwicklung in mycoforge-Projekten nutzt TypeScript.
Standard-Stack: React + Vite/Next.js + Tailwind CSS.
Accessibility ist kein Bonus — sie ist Pflicht.

## Vorgehen

### Neue Komponente
```
1. Props-Interface definieren
2. Kleinste sinnvolle Einheit — keine God-Components
3. Styles: Tailwind utility-first, keine inline-styles
4. Accessibility: semantisches HTML, aria-Attribute wo nötig
5. Test: render + user interaction
```

### Layout-Hierarchie
```
Page        → Route-Level, holt Daten
  Layout    → Wrapper (Header, Sidebar, Footer)
    Section → semantische Bereiche
      Component → wiederverwendbare Einheit
        Element → atom (Button, Input, Badge)
```

## React Konventionen

```typescript
// Props Interface immer definieren
interface ButtonProps {
  label: string
  onClick: () => void
  variant?: 'primary' | 'secondary'
  disabled?: boolean
}

// Funktionale Komponenten, kein class
export function Button({ label, onClick, variant = 'primary', disabled = false }: ButtonProps) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`btn btn-${variant}`}
      type="button"        // immer explizit
    >
      {label}
    </button>
  )
}

// Hooks: eigene Hooks für Logik extrahieren
function useUserData(userId: string) {
  const [user, setUser] = useState<User | null>(null)
  // ...
  return { user, isLoading, error }
}
```

## CSS / Tailwind

```tsx
// Tailwind: utility-first
<div className="flex items-center gap-4 p-6 rounded-lg shadow-md bg-white">

// Klassen-Varianten mit clsx/cva
import { cva } from 'class-variance-authority'

const button = cva('px-4 py-2 rounded font-medium', {
  variants: {
    variant: {
      primary: 'bg-blue-600 text-white hover:bg-blue-700',
      secondary: 'bg-gray-100 text-gray-900 hover:bg-gray-200',
    },
  },
})
```

## Accessibility

```tsx
// Semantisches HTML first
<nav>        // nicht <div className="nav">
<main>       // nicht <div id="main">
<button>     // nicht <div onClick=...>
<a href="…"> // nicht <span onClick=...>

// Labels für Formular-Elemente
<label htmlFor="email">E-Mail</label>
<input id="email" type="email" aria-required="true" />

// Alt-Text für Bilder
<img src="…" alt="Beschreibung" />   // informativ
<img src="…" alt="" />               // dekorativ → leer lassen

// Fokus-Management bei Modals
// Focus-Trap implementieren, ESC schließt
```

## Performance-Regeln

- Bilder: immer `width` + `height` setzen (verhindert Layout Shift)
- Lazy Loading: `loading="lazy"` für Bilder below the fold
- Code Splitting: dynamische Imports für große Routen
- Keine unnötigen Re-Renders: `useMemo`/`useCallback` nur wenn messbar nötig

## Testing (Frontend)

```typescript
import { render, screen, userEvent } from '@testing-library/react'

it('calls onClick when button is clicked', async () => {
  const handleClick = vi.fn()
  render(<Button label="Save" onClick={handleClick} />)

  await userEvent.click(screen.getByRole('button', { name: 'Save' }))

  expect(handleClick).toHaveBeenCalledOnce()
})
```

**Testing Library Prinzip:** Teste wie ein Nutzer — über Rollen, Labels, Text.
Nicht über CSS-Klassen oder interne State.
