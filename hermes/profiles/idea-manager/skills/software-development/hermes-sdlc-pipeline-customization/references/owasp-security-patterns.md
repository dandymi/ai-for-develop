### OWASP Top 10 — 2025 Security Patterns

Extracted from Awesome Copilot `wg-code-sentinel.agent.md` and `security-and-owasp.instructions.md`.

## OWASP Categories Quick Reference

| ID | Category | Key Mitigation |
|----|----------|---------------|
| A01 | Broken Access Control | Auth middleware on every endpoint, RBAC, ownership checks |
| A02 | Security Misconfiguration | Security headers, no debug in prod, no default credentials |
| A03 | Software Supply Chain Failures (NEW) | `npm audit`, lockfile integrity, SBOM, SLSA provenance |
| A04 | Cryptographic Failures | Argon2id/bcrypt for passwords, TLS everywhere, no secrets in code |
| A05 | Injection | Parameterized queries, input validation, no raw HTML with user input |
| A06 | Insecure Design | Threat modeling, secure design patterns, abuse case testing |
| A07 | Authentication Failures | Rate-limit login, secure session management, MFA |
| A08 | Software/Data Integrity Failures | SRI for CDN scripts, signed artifacts, no insecure deserialization |
| A09 | Security Logging & Monitoring Failures | Log security events, no PII in logs, correlation IDs |
| A10 | Exceptional Conditions (NEW) | Handle all errors, no stack traces in prod, fail-secure |

## Security Review Approach (WG Code Sentinel)

1. **Clarify** — Understand security context before proceeding
2. **Identify** — Mark issues with severity and OWASP reference
3. **Explain** — Describe vulnerability and exploit scenarios
4. **Recommend** — Provide specific remediation steps with code examples
5. **Validate** — Suggest testing methods for fixes

## Severity Levels

- **🔴 CRITICAL** — Exploitable vulnerability. Block release.
- **🟠 IMPORTANT** — Significant risk. Fix same sprint.
- ****SUGGESTION** — Defense-in-depth. Future iteration.

## Injection Anti-Patterns Reference

**I1: SQL Injection** — `SELECT * FROM users WHERE id = ${userId}` → use parameterized queries

**I2: NoSQL Injection** — `{ password: { $gt: "" } }` → validate and cast input types

**I3: Command Injection** — `exec('ls ' + req.query.dir)` → use allowlist + `execFile` with timeout

**I4: XSS** — `v-html`, `dangerouslySetInnerHTML` → sanitize with DOMPurify

**I5: SSRF** — `fetch(req.body.url)` → scheme/hostname allowlist + DNS rebinding check