---
name: nextjs-hydration-mismatch
description: |
  Debug Next.js hydration errors "Text content did not match" or "Hydration failed
  because the initial UI does not match". Triggers on React hydration mismatch,
  server/client content difference, or useEffect not running on server.
version: 1.0.0
author: auto-extracted
date: 2024-01-15
---

# Next.js Hydration Mismatch Debugging

Diagnose and fix React hydration errors in Next.js applications.

## Problem

React hydration fails when server-rendered HTML doesn't match client-rendered output.
The error is often cryptic and the actual cause can be far from where the error appears.

**Error messages:**
```
Warning: Text content did not match. Server: "X" Client: "Y"
Error: Hydration failed because the initial UI does not match what was rendered on the server.
Error: There was an error while hydrating. Because the error happened outside of a Suspense boundary, the entire root will switch to client rendering.
```

## Trigger Conditions

- Using Next.js with App Router or Pages Router
- Dynamic content that differs between server and client
- Browser-only APIs (window, localStorage, Date)
- Extensions modifying DOM (Grammarly, password managers)
- Invalid HTML nesting

## Solution

### Step 1: Identify the Source

Enable React's detailed hydration warnings:

```typescript
// next.config.js
module.exports = {
  reactStrictMode: true,
  onDemandEntries: {
    maxInactiveAge: 25 * 1000,
    pagesBufferLength: 2,
  },
}
```

Check console for the specific mismatch location.

### Step 2: Common Causes & Fixes

**Date/Time rendering:**
```tsx
// Bad - different on server vs client
<span>{new Date().toLocaleString()}</span>

// Good - render client-side only
const [mounted, setMounted] = useState(false)
useEffect(() => setMounted(true), [])
if (!mounted) return <span>Loading...</span>
return <span>{new Date().toLocaleString()}</span>
```

**localStorage/sessionStorage:**
```tsx
// Bad - doesn't exist on server
const theme = localStorage.getItem('theme')

// Good - check for window
const [theme, setTheme] = useState('light')
useEffect(() => {
  setTheme(localStorage.getItem('theme') || 'light')
}, [])
```

**Random/dynamic IDs:**
```tsx
// Bad - different each render
<div id={Math.random().toString()}>

// Good - stable ID
import { useId } from 'react'
const id = useId()
<div id={id}>
```

**Invalid HTML nesting:**
```tsx
// Bad - p cannot contain div
<p><div>Content</div></p>

// Good
<div><div>Content</div></div>
```

### Step 3: Suppress for Third-Party Issues

If caused by browser extensions (last resort):

```tsx
// app/layout.tsx
<body suppressHydrationWarning>
  {children}
</body>
```

Or for specific elements:
```tsx
<time suppressHydrationWarning dateTime={date}>
  {formattedDate}
</time>
```

### Step 4: Use Dynamic Import

For components that must be client-only:

```tsx
import dynamic from 'next/dynamic'

const ClientOnlyComponent = dynamic(
  () => import('./ClientOnlyComponent'),
  { ssr: false }
)
```

## Verification

1. Run `next build` - should complete without hydration warnings
2. Open browser DevTools console - no hydration errors
3. Test with extensions disabled to isolate third-party issues
4. View page source and compare with rendered DOM

## Example

### Before
```tsx
export default function Page() {
  return <p>Current time: {Date.now()}</p>  // Different every render!
}
```

### After
```tsx
'use client'
import { useState, useEffect } from 'react'

export default function Page() {
  const [time, setTime] = useState<number | null>(null)

  useEffect(() => {
    setTime(Date.now())
  }, [])

  return <p>Current time: {time ?? 'Loading...'}</p>
}
```

## Notes

- `suppressHydrationWarning` should be last resort, not first solution
- Browser extensions like Grammarly inject elements causing mismatches
- Empty string vs null/undefined can cause mismatches
- Check for conditional rendering based on `typeof window`

## References

- [Next.js Hydration Errors](https://nextjs.org/docs/messages/react-hydration-error)
- [React Hydration Documentation](https://react.dev/reference/react-dom/client/hydrateRoot)
