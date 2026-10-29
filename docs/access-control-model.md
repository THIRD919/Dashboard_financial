# Access Control Model

Authorization is `authenticated user → active profile → role bundle → capability (WHAT) → Unit/scope grant (WHERE) → record state`. Page visibility is supplementary; server actions repeat applicable checks and ignore caller-supplied actor identities.

Faculty scope is explicit. A Faculty grant may read Units, but Faculty write also requires `faculty_scope.write` plus a writable Faculty grant. Unit grants are many-to-many and independently record read/write. Phase 5B capabilities exist without being assigned to Phase 5A roles.
