# Coding Standards Observed

- TypeScript is used for application code; strictness is configured in `tsconfig.json`.
- Path alias `@/*` maps to repository root.
- Domain services and calculations live in `lib/`, not React components.
- Money calculations use `lib/financial/money.ts`; do not use floating-point arithmetic for authoritative financial values.
- Validation is explicit in `lib/data-entry/validation.ts` and import validation services.
- Use bilingual fields/messages where the existing domain requires them (`*_th`, `*_en`).
- Keep route handlers/actions thin and delegate persistence/business behavior to services.
- Tests are executable Node scripts under `tests/` and regression scripts under `scripts/`.

## Not found

No repository-wide ESLint, Prettier, commit-hook, or formal naming standard was found in the inspected root files. Follow local patterns and verify with `npm run typecheck` plus relevant tests.

