# CMU SSO Readiness

The `AuthProvider` abstraction can accept OIDC/OAuth2 or SAML through an appropriate identity gateway. No CMU SSO implementation or credentials are invented.

CMU IT must provide issuer/discovery URL, protocol, client ID/secret, allowed redirect/logout URIs, scopes, stable subject/email claims, MFA policy, session/logout behavior and any trusted group claims. Institutional identity links to an explicitly provisioned application profile, then roles and Unit grants. A CMU email domain alone never grants access. Recommend MFA for ADMIN and FINAL_APPROVER.

