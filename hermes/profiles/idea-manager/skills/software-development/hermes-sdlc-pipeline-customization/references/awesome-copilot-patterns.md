# Awesome Copilot Agent Patterns Reference

Extracted patterns from github/awesome-copilot for SDLC agent customization.

## Specification Agent Pattern

From [`specification.agent.md`](https://github.com/github/awesome-copilot/blob/main/agents/specification.agent.md)

### Required Sections
1. Introduction
2. Purpose & Scope
3. Definitions
4. Requirements/Constraints/Guidelines
5. Interfaces & Data Contracts
6. Acceptance Criteria (Given-When-Then)
7. Test Automation Strategy
8. Rationale & Context
9. Dependencies & External Integrations
10. Examples & Edge Cases
11. Validation Criteria
12. Related Specifications

### Classification Tags
- **REQ-XXX**: Functional requirements
- **SEC-XXX**: Security requirements
- **CON-XXX**: Constraints (must follow)
- **GUD-XXX**: Guidelines (recommended)

---

## AI Team Dev Pattern

From [`ai-team-dev.agent.md`](https://github.com/github/awesome-copilot/blob/main/agents/ai-team-dev.agent.md)

### Multi-Role Approach
- **Nova** (Frontend): React/UI, state management, accessibility
- **Sage** (Backend): APIs, database, auth, security
- **Milo** (Visual): CSS, animations, design system

### Git Workflow
```
git pull origin main
git checkout -b feature/sprint-N
# Build incrementally, commit every 2-3 features
git push origin feature/sprint-N
```

---

## AI Team QA Pattern

From [`ai-team-qa.agent.md`](https://github.com/github/awesome-copilot/blob/main/agents/ai-team-qa.agent.md)

### CRITICAL Constraint
> DO NOT edit application source code (no .ts, .tsx, .js, .css, .html in src/ or api/src/)
> You MAY write and edit test files in tests/
> You MAY edit markdown files in docs/qa/

### Bug Report Format
```markdown
**Component:** [which part of the app]
**Severity:** blocker / major / minor
**Steps to reproduce:**
1. [step 1]
2. [step 2]
3. [step 3]

**Expected:** [what should happen]
**Actual:** [what actually happens]

**Environment:** [browser, OS, screen size]
```

### Testing Checklist
- [ ] Happy path works as described
- [ ] Error states handled gracefully
- [ ] Edge cases (empty input, max length, special chars)
- [ ] No console errors or warnings
- [ ] Performance acceptable (no visible lag)
- [ ] Accessibility (keyboard navigation, screen reader)

---

## WG Code Sentinel Pattern

From [`wg-code-sentinel.agent.md`](https://github.com/github/awesome-copilot/blob/main/agents/wg-code-sentinel.agent.md)

### Review Approach
1. Clarify — Understand security context
2. Identify — Mark with severity and OWASP reference
3. Explain — Describe vulnerability and exploit scenarios
4. Recommend — Provide specific remediation steps
5. Validate — Suggest testing methods

### Communication Style
"Precise, intelligent, accessible language while remaining helpful. Anticipate needs and offer proactive insights."

---

## Task Planner Pattern

From [`task-planner.agent.md`](https://github.com/github/awesome-copilot/blob/main/agents/task-planner.agent.md)

### Three-File Deliverable Pattern
| File Type | Location | Purpose |
|-----------|----------|---------|
| Plan | `.copilot-tracking/plans/` | Task checklist with phases |
| Details | `.copilot-tracking/details/` | Full specifications |
| Prompt | `.copilot-tracking/prompts/` | Executor instructions |

### Template Markers
Use `{{placeholder}}` with snake_case for variable content requiring replacement.

### Line Number References
- Research-to-Details: Include specific line ranges
- Details-to-Plan: Include specific line ranges
- Update all references when files change