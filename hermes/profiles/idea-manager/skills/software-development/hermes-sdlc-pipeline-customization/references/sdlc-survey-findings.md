# SDLC Agent Definitions Survey - 2026-06-30

Extracted patterns from github/awesome-copilot for SDLC agent customization.

## Specification Agent Structure

From `specification.agent.md`:
- Introduction, Purpose & Scope, Definitions
- Requirements/Constraints/Guidelines with classification tags
- Interfaces & Data Contracts
- Acceptance Criteria (Given-When-Then format)
- Test Strategy (Unit, Integration, E2E)
- Dependencies & External Integrations

## Agent Pipeline Numbering (CORRECT ORDER)

| # | Agent | Position | Input | Output |
|---|-------|----------|-------|--------|
| 1 | idea-manager | First | User concept | Software idea document |
| 2 | specs-analyst | Second | Idea document | Spec with REQ/CON/GUD |
| 3 | impl-engineer | Third | Specification | Technical design document |
| 4 | code-developer | Fourth | Implementation plan | Source code |
| 5 | code-reviewer | Fifth | Source code | Review report (pass/block) |
| 6 | security-checker | Sixth | Reviewed code | Security report |
| 7 | app-tester | Seventh | Secured code | Test report & sign-off |
| 8 | code-documenter | Eighth | Tested code | Documentation suite |
| 9 | deployer | Ninth (Final) | Documented code | Deployed application |

**Architect** is NOT in the pipeline flow — orchestrates from outside (feedback loops connect back).

## Critical Agent Constraints

### QA Agent (app-tester)
- **DO NOT edit production code** (src/, api/, or production directories)
- Only write test files (tests/) and QA documentation (docs/qa/)

### Security Agent (security-checker)
- OWASP Top 10 2025 reference required
- Severity: CRITICAL/HIGH/MEDIUM/LOW
- Attack vector and remediation steps for each finding

## Testing Format Standards

### Bug Report Template
```markdown
**Component:** [which part of the app]
**Severity:** BLOCKER / CRITICAL / MAJOR / MINOR
**Steps to reproduce:**
1. [step 1]
2. [step 2]
3. [step 3]

**Expected:** [spec behavior]
**Actual:** [observed behavior]

**Environment:** [browser, OS, screen size if relevant]
```

### Smoke Test Checklist (Deployer)
- [ ] Health endpoint responds with 200 OK
- [ ] Application starts without errors
- [ ] Critical API endpoints respond
- [ ] Database connections established
- [ ] External service integrations working
- [ ] Monitoring/metrics flowing

## Common Pitfall: Profile-Specific vs Default Cron

- `hermes -p profile cron list` — checks profile-specific cron (usually empty)
- `hermes cron list` — checks default profile cron jobs (where active jobs live)
- Cron jobs are global to the default profile, not distributed to sub-profiles