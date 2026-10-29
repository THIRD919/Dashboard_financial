# Thai/English Architecture

## Locale model

- Supported locales: `th`, `en`; default `th`.
- Locale-prefixed routes: `/[locale]/...`; middleware redirects an unprefixed request using profile preference, then cookie, then Thai default.
- `profiles.preferred_language` stores preference only; it never changes financial values or calculations.
- Central messages: `messages/th.json` and `messages/en.json`, validated to have matching keys in CI.

## Data localization

Bilingual master/definition tables use `name_th/name_en` and, where needed, `description_th/description_en`. Technical codes (`NOVEL`, `REVENUE_ACTUAL`, `FIN_LIQ`) are language-neutral and immutable. Numerical financial facts are stored once.

If an approved English master-data value is absent, English UI may show the Thai official name with a clear fallback; it must not silently persist a machine-invented translation. Source aliases remain separate from approved display names.

## Formatting

Use locale-aware display formatting at the presentation boundary while retaining typed decimal/date values. Explicitly show THB/scale and source reporting-period labels. Do not convert BE/CE years or quarter months until the configured period provides approved metadata.

KPI calculation and status codes are locale-neutral. Only their names, descriptions and status labels are translated after calculation.

