# PROMPT FOR GOOGLE AI STUDIO TO FIX STYLING

## Current Problem
The frontend is deployed but showing a broken, basic interface instead of the beautiful design. Tailwind CSS styles are not being applied properly.

## What to Send to Google AI Studio:

```
I have a Next.js 14 app deployed to Vercel with Tailwind CSS, but the styles are not loading - it's showing a basic unstyled interface.

Current setup:
- Framework: Next.js 14.1.4
- Styling: Tailwind CSS 3.3.0
- Deployment: Vercel
- App Router structure

My tailwind.config.ts:
```typescript
import type { Config } from 'tailwindcss';

const config: Config = {
  darkMode: ['class'],
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['var(--font-noto-sans)'],
        arabic: ['var(--font-noto-sans-arabic)'],
      },
      colors: {
        'iraqi-red': '#CE1126',
        'iraqi-green': '#007A3D',
        'iraqi-black': '#000000',
        'iraqi-white': '#FFFFFF',
      },
    },
  },
  plugins: [],
};
export default config;
```

My next.config.mjs is minimal:
```javascript
const nextConfig = {
    images: {
        remotePatterns: [
            {
                protocol: 'https',
                hostname: 'avatar.iran.liara.run',
                port: '',
                pathname: '/public/**',
            }
        ]
    }
};
export default nextConfig;
```

The app structure uses:
- app/ directory with [lang] dynamic routes
- globals.css imported in layout
- Components using Tailwind classes

What configuration changes do I need to:
1. Ensure Tailwind processes correctly in production on Vercel?
2. Fix any missing PostCSS or build configuration?
3. Ensure fonts load properly?

Please provide the exact files I need to update or create.
```

---

## Alternative Quick Fixes to Try First:

### Option 1: Update next.config.mjs
Add this to ensure proper CSS handling:

```javascript
const nextConfig = {
    images: {
        remotePatterns: [
            {
                protocol: 'https',
                hostname: 'avatar.iran.liara.run',
                port: '',
                pathname: '/public/**',
            }
        ]
    },
    // Add these:
    experimental: {
        optimizeCss: true,
    },
    compiler: {
        removeConsole: process.env.NODE_ENV === 'production',
    }
};
```

### Option 2: Check app/layout.tsx
Ensure it imports globals.css:
```typescript
import './globals.css'
```

### Option 3: Rebuild on Vercel
1. Go to Vercel dashboard
2. Click "Redeploy" 
3. Check "Clear build cache & deploy"

### Option 4: Check postcss.config.js
Should have:
```javascript
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
```

