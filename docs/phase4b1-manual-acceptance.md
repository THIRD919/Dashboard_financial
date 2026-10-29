# Phase 4B.1 Manual Acceptance

## Actual causes

Manual use was blocked by configuration and runtime gaps rather than the financial-entry service itself:

- no explicit one-command path enabled both demo identity and database dashboard mode;
- the demo identity selector was not protected by a production-safe environment gate;
- a fresh local database lacked the synthetic supporting rows required by the complete executive dashboard shape;
- PGlite was bundled by Next.js instead of remaining server-only, causing extension-path failures at runtime;
- Turbopack could not spawn its CSS worker in the local runtime, while webpack works;
- drafts were visible but could not be reopened into the form for review-before-submit;
- Unit liquidity source components reached the database but were not projected onto the Unit dashboard.

## Resolution

`npm run demo` resets and prepares the embedded PGlite database, applies migrations, seeds safe master/demo access and synthetic `TEST_ONLY` dashboard support rows, enables `ENABLE_DEMO_AUTH=true`, selects `DASHBOARD_DATA_PROVIDER=database`, and starts Next.js with webpack.

Demo authentication is allowed only when `NODE_ENV !== production` and `ENABLE_DEMO_AUTH=true`. Server Actions repeat this check. Manual source references are automatically prefixed `TEST_ONLY_`.

## Browser acceptance result

The Thai page was exercised through an actual browser. Office user access, Q2/69 selection, the four requested inputs, preview values, Save Draft, refresh persistence, reopen, review, submit, read-only enforcement, and the Office Unit dashboard were verified. Dashboard results were Revenue 1M, Expense 700K, Operating Result 300K, Margin 30.0%, Financial Liquidity 2.00, and completeness 1/4.

No production authentication, import, public deployment, or Phase 4C work was added.
