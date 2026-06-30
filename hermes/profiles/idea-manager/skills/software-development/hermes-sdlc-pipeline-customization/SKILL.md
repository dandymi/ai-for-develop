---
name: hermes-sdlc-pipeline-customization
description: "Configure and customize Hermes Agent profiles for the 10-role SDLC pipeline (idea-manager → specs-analyst → impl-engineer → code-developer → code-reviewer → security-checker → app-tester → code-documenter → deployer + architect)"
version: 1.1.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [hermes, profiles, customization, multi-agent, pipeline, configuration, sdlc]
    related_skills: [hermes-agent, writing-plans, hermes-profile-customization]
---

# Hermes SDLC Pipeline Profile Customization

Class-level skill for creating and customizing Hermes Agent profiles for specialized roles in the 10-agent software development lifecycle pipeline.

## When to Use This Skill

- Setting up a new multi-agent SDLC pipeline with role-specific profiles
- Customizing an existing profile for a specific agent role
- Defining SOUL.md identity and tool boundaries for specialized agents
- Selecting appropriate models for different agent responsibilities
- Disabling irrelevant skills to focus agent capabilities

## Pipeline Overview

```
idea-manager → specs-analyst → impl-engineer → code-developer → code-reviewer → security-checker → app-tester → code-documenter → deployer
     ↑                                                                    ↑
     └──────────────────────── Feedback loops ───────────────────────────┘
```

**Feedback Loops:**
- code-reviewer finds bugs → feedback to code-developer
- security-checker finds vulnerabilities → feedback to code-reviewer → code-developer
- app-tester finds bugs → feedback to code-reviewer
- deployer finds issues → feedback to impl-engineer
- impl-engineer incoherence → feedback to specs-analyst
- specs-analyst incoherence → feedback to idea-manager
- idea-manager incoherence → feedback to human user

## Profile Customization Workflow

### 1. Verify Current State

```bash
hermes profile list          # List all profiles
hermes profile show <name>   # Check model, gateway, skills, SOUL.md
hermes -p <name> tools list  # Check available toolsets
```

### 2. Set Model and Provider

```bash
hermes -p <profile> config set model.default "<model-name>"
hermes -p <profile> config set model.provider "<provider>"
```

**Verified Models by Role (from production deployment):**

| Role | Model | Provider | Rationale |
|------|-------|----------|-----------|
| idea-manager | `anthropic/claude-3.7-sonnet` | OpenRouter | Strong reasoning, conversation, clarification |
| specs-analyst | `claude-sonnet-4.6` | Copilot | Requirements analysis, technical decision-making |
| impl-engineer | `moonshotai/kimi-k2.6` | OpenRouter | Architecture, implementation planning, large context |
| code-developer | `anthropic/claude-3.7-sonnet` | OpenRouter | Code generation, implementation |
| code-reviewer | `anthropic/claude-sonnet-4` | OpenRouter | Code analysis, quality gates |
| security-checker | `anthropic/claude-sonnet-4` | OpenRouter | Security auditing, vulnerability detection |
| app-tester | `openai/o4-mini` | OpenRouter | Test execution, bug finding, cost-effective |
| code-documenter | `nvidia/nemotron-3-ultra:free` | Nous | Documentation writing, free tier |
| deployer | `anthropic/claude-3.5-sonnet` | OpenRouter | Deployment, ops, packaging |
| architect | `moonshotai/kimi-k2.6` | OpenRouter | Multi-agent coordination, large context |

**Model Selection Notes:**
- **code-developer** and **app-tester** run high-volume tasks — consider cheaper models (`claude-3.5-haiku`, `gemini-2.5-flash`) for routine work
- **code-documenter** uses free Nous tier — good for low-priority documentation
- **specs-analyst** uses Copilot — requires `hermes auth add copilot`
- Always set `model.provider` to match: `openrouter`, `copilot`, or `nous`

### 3. Create/Update SOUL.md

**Template Structure:**

```markdown
You are the **<role-name>** agent in the software development life cycle.
You are the <Nth> agent in the pipeline, receiving <input> from <upstream-agent>.

## Your Role: <One-line Summary>

**Input:** <What you receive from upstream>
**Output:** <What you produce for downstream>

## Core Responsibilities
- <Responsibility 1>
- <Responsibility 2>

## What You Do NOT Do
- ❌ <Out-of-scope task> — <Which agent owns it>
- ❌ <Out-of-scope task> — <Which agent owns it>

## Workflow
1. <Step 1>
2. <Step 2>
3. <Step 3>

## Tools Available
- `tool_name` — <Purpose>
- `tool_name` — <Purpose>

## Principles
- <Principle 1>
- <Principle 2>
```

**Code Developer Agent (code-developer):**
```markdown
## Role Specialization Guidance
- **Frontend**: Component architecture, state management, accessibility
- **Backend**: API endpoints, database, auth, security
- **Infrastructure**: CI/CD, deployment, monitoring
```

**QA Agent (app-tester) - CRITICAL CONSTRAINT:**
```markdown
## 🔴 CRITICAL CONSTRAINT
DO NOT edit application source code in src/, api/, or production directories.
You may ONLY write test files in tests/ and QA documentation in docs/qa/
```

**Security Agent (security-checker):**
```markdown
## OWASP Top 10 — 2025 Quick Reference
| ID | Category | Key Focus |
|----|----------|-----------|
| A01 | Broken Access Control | RBAC, ownership checks |
| A02 | Security Misconfiguration | Security headers, no defaults |
| A03 | Software Supply Chain | SBOM, SLSA provenance |
| A04 | Cryptographic Failures | TLS, proper password hashing |
| A05 | Injection | Parameterized queries, input validation |
| A06 | Insecure Design | Threat modeling |
| A07 | Authentication Failures | Rate limiting, MFA |
| A08 | Integrity Failures | Signed artifacts |
| A09 | Logging Failures | Security event logging |
| A10 | Exceptional Conditions | Handle all errors securely |
```

**Implementation Plan Agent (impl-engineer):**
```markdown
## Deliverable Pattern (Three-File Approach)
| File | Purpose | Location |
|------|---------|----------|
| Plan/Checklist | Task checklist | .copilot-tracking/plans/ |
| Details | Full specifications | .copilot-tracking/details/ |
| Implementation Prompt | Executor instructions | .copilot-tracking/prompts/ |

Use {{placeholder}} markers for variable content requiring replacement.

### SOUL.md Template Additions (from awesome-copilot patterns)

**Specification Agent (specs-analyst):**
```markdown
## Specification Document Structure

| Section | Purpose |
|---------|---------|
| Introduction | Brief overview and goal |
| Purpose & Scope | Clear scope, audience, assumptions |
| Definitions | Acronyms, domain terms |
| Requirements | Functional and non-functional |
| Constraints | Limitations, rules, guidelines |
| Interfaces | API contracts, data schemas |
| Acceptance Criteria | Given-When-Then format |
| Test Strategy | Unit, integration, E2E approach |
| Dependencies | External systems, services |
```

**Requirements Classification:**
- REQ-XXX: Functional requirements
- SEC-XXX: Security requirements
- CON-XXX: Constraints (must follow)
- GUD-XXX: Guidelines (recommended)

### 4. Disable Irrelevant Skills

```bash
hermes -p <profile> config set skills.disabled '["skill1","skill2",...]'
```

**Common Skills to Disable by Role:**

| Role | Disable Categories |
|------|-------------------|
| idea-manager | creative, mlops, data-science, devops, gaming, github, media, social-media, productivity, red-teaming, smart-home, codex, claude-code, etc. |
| code-developer | creative, mlops, data-science, gaming, media, social-media, research papers, documentation skills, github PR workflow |
| code-reviewer | creative, mlops, gaming, media, code-generation skills |
| security-checker | creative, mlops, gaming, media, general code generation |

**Note:** `hermes config set` stores arrays as JSON strings. This is functional but not pretty YAML. For cleaner config, edit `config.yaml` directly via `hermes config edit`.

### 5. Verify Configuration

```bash
hermes profile show <name>
hermes -p <name> tools list
hermes -p <name> skills list
```

## Pitfalls & Gotchas

1. **JSON string arrays** — `hermes config set skills.disabled '[\\\\\"a\\\\\",\\\\\"b\\\\\"]'` creates a string, not a YAML list. Works but ugly. Use `hermes config edit` for clean YAML.

2. **SOUL.md not auto-reloaded** — After editing SOUL.md, start a new session (`/new` or restart) for changes to take effect.

3. **Tool changes require new session** — Enabling/disabling toolsets via `hermes tools` needs `/reset` or new session.

4. **Profile config.yaml may not exist** — First `config set` creates it. Subsequent edits modify it.

5. **Model provider must match** — If using OpenRouter, ensure `model.provider: openrouter`. For Copilot, use `copilot`.

6. **Skills count includes disabled** — `hermes profile show` shows total installed skills, not active count.

7. **Config location** — Profile configs live at `~/.hermes/profiles/<name>/config.yaml`. Global config is at `~/.hermes/config.yaml`.

8. **Profile order matters** — In SDLC pipeline, feedback loops must route correctly. If code-reviewer finds issues, route to code-developer (not security-checker).

9. **Cron jobs are profile-global** — Use `hermes cron list` (not `hermes -p profile cron list`) to see active scheduled jobs. Cron jobs are stored in the default profile's cron directory, not distributed to SDLC sub-profiles.

## References

- `references/soul-templates.md` — Complete SOUL.md templates for all 10 pipeline roles
- `references/skill-disable-lists.md` — Curated skill disable lists per role
- `references/model-recommendations.md` — Detailed model selection rationale with alternatives
- `references/awesome-copilot-patterns.md` — Extracted patterns from github/awesome-copilot for SDLC agents
- `references/owasp-2025-security.md` — OWASP Top 10 2025 quick reference for security agents
- `references/owasp-2025-top10.md` — Concise OWASP 2025 categories for agent SOUL.md
- `references/owasp-security-patterns.md` — Security patterns and anti-patterns from WG Code Sentinel
- `references/cron-job-patterns.md` — Cron job configuration for SDLC monitoring and alerting
- `references/sdlc-survey-findings.md` — Survey findings: agent patterns and constraints
- `templates/testing-qa-templates.md` — Standard templates for testing, QA, review, security, smoke tests

## Related Skills

- `hermes-agent` — Core Hermes configuration (bundled, read-only)
- `writing-plans` — Implementation planning for impl-engineer role
- `hermes-profile-customization` — Original profile customization skill (superseded by this one)