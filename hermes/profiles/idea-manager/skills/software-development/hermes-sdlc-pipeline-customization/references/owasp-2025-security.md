# OWASP Top 10 — 2025 for Security Agents

Quick reference for security-checker role.

## OWASP Top 10 2025

| ID | Category | Key Mitigation | Tools to Use |
|----|----------|----------------|--------------|
| A01 | Broken Access Control | Auth middleware, RBAC, ownership checks | auth0, casbin, middleware review |
| A02 | Security Misconfiguration | Security headers, no debug in prod, no defaults | helmet, csp-evaluator, nginx config |
| A03 | Software Supply Chain Failures | npm audit, lockfile integrity, SBOM | trivy, snyk, osv-scanner, syft |
| A04 | Cryptographic Failures | Argon2id/bcrypt, TLS everywhere, no secrets in code | openssl, tls-checker, npm-dep-vuln |
| A05 | Injection | Parameterized queries, input validation, no raw HTML | sqlmap, bandit, ESLint rules |
| A06 | Insecure Design | Threat modeling, secure design patterns | threatdragon, microsoft TM guide |
| A07 | Authentication Failures | Rate-limit login, secure session, MFA | OWASP auth cheat sheet, rate-limiter |
| A08 | Software/Data Integrity Failures | SRI for CDN, signed artifacts, no insecure deserialization | sigstore, srihash, npm audit |
| A09 | Security Logging/Monitoring Failures | Log security events, no PII in logs, correlation IDs | winston, pino, ELK, Datadog |
| A10 | Exceptional Conditions | Handle all errors, no stack traces in prod, fail-secure | error handling libs, custom errors |

## Severity Guidelines

| Severity | Action | Examples |
|----------|--------|----------|
| 🔴 CRITICAL | Block release - immediate fix | RCE, auth bypass, data exposure, SQLi, XSS |
| 🟠 HIGH | Fix before release | Auth flaws, injection, weak crypto, SSRF |
| 🟡 MEDIUM | Fix in next sprint | Info disclosure, weak configs, missing headers |
| 🟢 LOW | Track for hardening | Version disclosure, verbose errors, comments |

## Security Anti-Patterns (Detection Regex)

```
I1: SQL Injection     →  \$\{.*\}.*(?:SELECT|INSERT|UPDATE|DELETE|FROM|WHERE)
I2: NoSQL Injection     →  \{\s*\$(?:gt|gte|lt|lte|ne|in|nin|regex)
I3: Command Injection   →  (?:exec|execSync|execFile).*(?:req\.|params\.|query\.|body\.)
I4: XSS                 →  (?:v-html|\[innerHTML\]|dangerouslySetInner|bypassSecurityTrust)
I5: SSRF                →  fetch\((?:req\.|params\.|query\.|body\.|url|href)
I6: Path Traversal      →  (?:readFile|readFileSync|createReadStream|path\.join).*(?:req\.|params\.|query\.|body\.)
I7: Template Injection   →  (?:render|compile|template).*(?:req\.|params\.|query\.|body\.)
I8: XXE Injection      →  (?:parseXml|DOMParser|xml2js|libxmljs).*(?:req\.|body\.|file)
```

## Reference Commands

```bash
# Dependency scanning
npm audit
trivy fs .
osv-scanner .
gitleaks detect --source .

# Static analysis
semgrep --config=p/r2c-security-audit .
bandit -r .
eslint . --ext .js,.ts

# Configuration checks
nginx -t
helmet --help
tls-checker https://localhost:3000
```