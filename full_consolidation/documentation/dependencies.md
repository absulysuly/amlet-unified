# Iraq Compass - Dependencies Management

## Core Dependencies

| Package | Version | Purpose | Alternatives |
|---------|---------|---------|-------------|
| react | ^19.2.0 | UI Library | Preact, SolidJS |
| react-dom | ^19.2.0 | React DOM rendering | - |
| zustand | ^5.0.8 | State management | Redux, Jotai, Recoil |
| react-router-dom | ^6.30.1 | Client-side routing | TanStack Router, Wouter |
| @google/generative-ai | ^0.21.0 | AI/ML capabilities | OpenAI API, Anthropic |

## UI & Styling

| Package | Version | Purpose | Alternatives |
|---------|---------|---------|-------------|
| tailwindcss | ^3.4.18 | Utility-first CSS | Chakra UI, MUI, Chakra |
| framer-motion | ^12.23.22 | Animations | Framer Motion, React Spring |
| lucide-react | ^0.544.0 | Icons | React Icons, Hero Icons |

## Forms & Validation

| Package | Version | Purpose | Alternatives |
|---------|---------|---------|-------------|
| react-hook-form | ^7.62.0 | Form handling | Formik, Final Form |
| zod | ^4.1.9 | Schema validation | Yup, Joi |
| @hookform/resolvers | ^5.2.2 | Form validation | - |

## Development Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| @vitejs/plugin-react | ^5.0.4 | Vite React plugin |
| typescript | ~5.8.2 | Type checking |
| vite | ^6.2.0 | Build tool |
| vitest | ^3.2.4 | Testing |
| @testing-library/* | ^16.3.0 | Testing utilities |

## Adding New Dependencies

1. **Check if the package is already included**
2. **Evaluate alternatives** (see tables above)
3. **Version Policy**:
   - Use `^` for patch/minor updates
   - Pin versions for critical dependencies
   - Avoid `latest` or `*` versions

## Security Audit

Run regularly:
```bash
npm audit
```

## Updating Dependencies

1. Update one package at a time
2. Test thoroughly after each update
3. Document changes in CHANGELOG.md

## Deprecated Packages

- None currently

## Known Issues

- None currently

## Performance Impact

- Framer Motion: Medium (tree-shakeable)
- Tailwind: Low (purgeable)
- Zustand: Very Low

## Bundle Size Impact

- Core: ~45KB (gzipped)
- UI: ~15KB (gzipped)
- Utilities: ~10KB (gzipped)

## Development Scripts

- `npm run dev`: Start development server
- `npm run build`: Production build
- `npm run test`: Run tests
- `npm run validate`: Validate before deployment

## Troubleshooting

### Common Issues
1. **HMR not working**: Try `npm run clean`
2. **Type errors**: Run `npx tsc --noEmit`
3. **Build failures**: Clear cache with `npm cache clean --force`

### Performance Issues
- Run `npm run analyze` for bundle analysis
- Check for large dependencies with `npx why-is-node-running`

## License Compliance

All dependencies are MIT or similarly permissive licensed.

## Security Notices

- Report vulnerabilities to: security@example.com
- Security updates: Weekly
- Dependency updates: Monthly
