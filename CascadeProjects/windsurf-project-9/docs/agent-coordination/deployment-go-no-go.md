PRODUCTION HARDENING — HAMLET PLATFORM (CLOUD EXECUTION)
CONTEXT

Finalize the Hamlet Platform (Next.js 14) MVP for production deployment.
Ensure validation, telemetry, SSR hydration safety, and rollback protection.
Backend: http://localhost:4001 (7,751 candidates).

REPOSITORY

Repo: absulysuly/hamlet-platform-nextjs

Branch: feature/api-validation-hardening

Framework: Next.js 14

Deployment: Vercel Production

CRITICAL FIXES REQUIRED
1. Navbar Crash

File: components/layout/Navbar.tsx

// FIX:
{t?.home || 'Home'}

2. API Validation (Zod)

File: lib/api.ts
Add Zod schemas for API responses and safe fallbacks.

3. Gemini Gating

File: services/geminiService.ts
Implement GEMINI_MODE gating for local stub vs remote integration.

4. Telemetry

File: lib/telemetry.ts
Add lightweight fallback logging using structured JSON (<1 KB).

5. SSR Hydration

File: app/[lang]/layout.tsx
Render <html dir="ltr|rtl"> server-side based on language.

SAFETY PROTOCOL

Backup branch first:

git checkout feature/api-validation-hardening
git branch backup/pre-production-$(date +%Y%m%d)
git push origin backup/pre-production-$(date +%Y%m%d)


Preserve all Codex-authored code (// CODEx-MERGE, // AI-HARDEN).

Add CI rollback job — auto-revert if build/test fails.

Run local tests before deployment:

npm run build && npm test && npm run dev

CI / CD (AUTO-ROLLBACK)

File: .github/workflows/ci.yml

name: CI Build & Deploy
on: [push]

jobs:
  build-test-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 18
      - run: npm ci
      - run: npm run build
      - run: npm test
      - run: node scripts/smoke.js || echo "Smoke optional"
      - name: Deploy to Vercel
        if: success()
        run: vercel --prod --token=${{ secrets.VERCEL_TOKEN }}
      - name: Auto-Rollback if Failed
        if: failure()
        run: |
          echo "❌ Build failed – rolling back."
          git push origin backup/pre-production-* --force
          exit 1

STAGING VERIFICATION (MANDATORY)

Before promoting to production:

Deploy preview build:

vercel --previews --token=$VERCEL_TOKEN


Verify:

/en and /ar load correctly.

No hydration warnings.

Candidates and stats render.

reportApiFallback logs structured JSON on malformed API data.

Promote to production only if all above pass:

vercel promote <deployment-id> --prod

SUCCESS CRITERIA

✅ Frontend loads without crashes
✅ All unit & smoke tests pass
✅ Build succeeds in CI
✅ Fallback telemetry works
✅ Vercel deployment verified
✅ Rollback available (backup branch)

FINAL ACTIONS

Run this task set end-to-end in Cloud executor.

Produce PR → main titled:

feat: production-ready MVP hardening


Attach:

build.log

test results

smoke output

two sample API responses

✅ RESULT

You’ll have:

A production-ready MVP with rollback safety

Codex logic preserved

CI pipeline hardened

Staging verification completed

A clean, auditable PR ready for merge