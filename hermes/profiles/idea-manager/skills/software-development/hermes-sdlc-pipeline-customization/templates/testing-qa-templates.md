# Testing & QA Templates

Standard templates for the app-tester role, derived from awesome-copilot patterns.

## Bug Report Template

```markdown
**Component:** [which part of the app - e.g., UserAuth, API endpoint, UI component]
**Severity:** BLOCKER / CRITICAL / MAJOR / MINOR
**Steps to reproduce:**
1. [Clear step 1]
2. [Clear step 2]
3. [Clear step 3]

**Expected:** [What should happen according to spec]
**Actual:** [What actually happens]

**Environment:** [browser, OS, screen size, API version if relevant]

**Evidence:** [Links to logs, screenshots, stack traces]
```

## QA Sign-off Template

```markdown
## Test Results Summary

### Coverage
- Unit Tests: N passed, 0 failed
- Integration Tests: N passed, 0 failed
- E2E Tests: N passed, 0 failed

### Issues Filed
- #42: [Bug title] (severity: BLOCKER)
- #43: [Bug title] (severity: MAJOR)

### Manual Validation
- [x] All features work as specified
- [x] Error states handled gracefully
- [x] Edge cases tested (empty, max length, special chars)
- [x] No console errors or warnings
- [x] Performance acceptable (< 100ms for critical paths)
- [x] Accessibility verified (keyboard nav, ARIA labels)

### Sign-off Status
✅ PASS - Ready for deployment to staging
OR
❌ BLOCKED - Issues require fixes (see above)
```

## Testing Checklist

| Category | Check | Tools |
|----------|-------|-------|
| Happy Path | Works as described in spec | Manual, automated tests |
| Error States | Handles invalid input gracefully | Unit tests, fuzzing |
| Edge Cases | Empty, max length, special characters | Property-based tests |
| Console | No errors/warnings in dev tools | Browser console, logs |
| Performance | No visible lag, API < 100ms | Lighthouse, k6, timings |
| Accessibility | Keyboard nav, ARIA, contrast | axe-core, manual testing |

---

## Review Report Template

```markdown
## Code Review Results

### 🔴 BLOCKING Issues
- [File:line] Description + fix suggestion

### 🟡 WARNINGS
- [File:line] Description + recommendation

### 🟢 SUGGESTIONS
- [File:line] Description + improvement idea

### SUMMARY
- Blocking: N
- Warnings: N
- Suggestions: N
- Status: BLOCKED / PASSED
```

## Security Audit Template

```markdown
## Security Audit Report

### 🔴 CRITICAL Findings (Block Release)
| Location | Vulnerability | Exploit | Remediation |
|----------|-------------|---------|-------------|

### 🟠 HIGH Findings (Fix Before Release)
| Location | Issue | Impact | Fix |
|----------|-------|--------|-----|

### 🟡 MEDIUM / 🟢 LOW Findings
| Location | Issue | Recommendation |
|----------|-------|----------------|

### SUMMARY
- CRITICAL: N
- HIGH: N
- MEDIUM: N
- LOW: N
- Status: BLOCKED / READY FOR TESTING
```

## Smoke Test Template

```markdown
## Post-Deploy Smoke Tests

- [ ] Health endpoint returns 200 OK
- [ ] Application starts without errors
- [ ] Critical API endpoints respond
- [ ] Database connections established
- [ ] External service integrations working
- [ ] Monitoring/metrics flowing to dashboard
- [ ] Alerts configured and tested

**Result:** ✅ ALL PASS / ❌ FAILURES DETECTED
```