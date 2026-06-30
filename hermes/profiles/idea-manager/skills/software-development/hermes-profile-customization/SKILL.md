---
name: hermes-profile-customization
description: "Configure and customize Hermes Agent profiles for specialized roles in multi-agent pipelines"
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [hermes, profiles, customization, multi-agent, pipeline, configuration]
    related_skills: [hermes-agent, writing-plans]
---

# Hermes Profile Customization

Class-level skill for creating and customizing Hermes Agent profiles for specialized roles in software development pipelines (idea-manager, specs-analyst, impl-engineer, code-developer, code-reviewer, security-checker, app-tester, code-documenter, deployer, architect).

## When to Use This Skill

- Setting up a new multi-agent pipeline with role-specific profiles
- Customizing an existing profile for a specific agent role
- Defining SOUL.md identity and tool boundaries for specialized agents
- Selecting appropriate models for different agent responsibilities
- Disabling irrelevant skills to focus agent capabilities

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

**Recommended Models by Role:**\n| Role | Model | Provider | Rationale |\n|------|-------|----------|-----------|\n| idea-manager | `anthropic/claude-3.7-sonnet` | OpenRouter | Strong reasoning, conversation, clarification |\n| specs-analyst | `claude-sonnet-4.6` | Copilot | Requirements analysis, technical decision-making |\n| impl-engineer | `moonshotai/kimi-k2.6` | OpenRouter | Architecture, implementation planning |\n| code-developer | `anthropic/claude-3.7-sonnet` | OpenRouter | Code generation, implementation |\n| code-reviewer | `anthropic/claude-sonnet-4` | OpenRouter | Code analysis, quality gates |\n| security-checker | `anthropic/claude-sonnet-4` | OpenRouter | Security auditing, vulnerability detection |\n| app-tester | `openai/o4-mini` | OpenRouter | Test execution, bug finding, cost-effective |\n| code-documenter | `nvidia/nemotron-3-ultra:free` | Nous | Documentation writing, free tier |\n| deployer | `anthropic/claude-3.5-sonnet` | OpenRouter | Deployment, ops, packaging |\n| architect | `moonshotai/kimi-k2.6` | OpenRouter | Multi-agent coordination |\n\n**Model Selection Notes:**\n- **code-developer** and **app-tester** run high-volume tasks — consider cheaper models (`claude-3.5-haiku`, `gemini-2.5-flash`) for routine work\n- **code-documenter** uses free Nous tier — good for low-priority documentation\n- **specs-analyst** uses Copilot — requires `hermes auth add copilot`\n- Always set `model.provider` to match: `openrouter`, `copilot`, or `nous`

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

### 4. Disable Irrelevant Skills

```bash
hermes -p <profile> config set skills.disabled '["skill1","skill2",...]'
```

**Common Skills to Disable by Role:**

| Role | Disable Categories |
|------|-------------------|
| idea-manager | creative, mlops, data-science, devops, gaming, github, media, social-media, productivity, red-teaming, smart-home, codex, claude-code, etc. |
| code-developer | creative, mlops, data-science, gaming, media, social-media, research papers, documentation skills, github PR workflow (reviewer owns this) |
| code-reviewer | creative, mlops, gaming, media, code-generation skills |
| security-checker | creative, mlops, gaming, media, general code generation |

**Note:** `hermes config set` stores arrays as JSON strings. This is functional but not pretty YAML. For cleaner config, edit `config.yaml` directly via `hermes config edit`.

### 5. Verify Configuration

```bash
hermes profile show <name>
hermes -p <name> tools list
hermes -p <name> skills list
```

## Pipeline Flow Reference

```
idea-manager → specs-analyst → impl-engineer → code-developer → code-reviewer → security-checker → app-tester → code-documenter → deployer
     ↑                                                                    ↑
     └──────────────────────── Feedback loops ───────────────────────────┘
```

- **code-reviewer** finds bugs → feedback to **code-developer**
- **security-checker** finds vulnerabilities → feedback to **code-reviewer** → **code-developer**
- **app-tester** finds bugs → feedback to **code-reviewer**
- **deployer** finds issues → feedback to **impl-engineer**
- **impl-engineer** incoherence → feedback to **specs-analyst**
- **specs-analyst** incoherence → feedback to **idea-manager**
- **idea-manager** incoherence → feedback to **human user**

## Pitfalls & Gotchas

1. **JSON string arrays** — `hermes config set skills.disabled '["a","b"]'` creates a string, not a YAML list. Works but ugly. Use `hermes config edit` for clean YAML.

2. **SOUL.md not auto-reloaded** — After editing SOUL.md, start a new session (`/new` or restart) for changes to take effect.

3. **Tool changes require new session** — Enabling/disabling toolsets via `hermes tools` needs `/reset` or new session.

4. **Profile config.yaml may not exist** — First `config set` creates it. Subsequent edits modify it.

5. **Model provider must match** — If using OpenRouter, ensure `model.provider: openrouter`. For Copilot, use `copilot`.

6. **Skills count includes disabled** — `hermes profile show` shows total installed skills, not active count.

## References

- `references/profile-templates.md` — SOUL.md templates for each pipeline role
- `references/skill-disable-lists.md` — Curated skill disable lists per role
- `references/model-recommendations.md` — Detailed model selection rationale

## Related Skills

- `hermes-agent` — Core Hermes configuration (bundled, read-only)
- `writing-plans` — Implementation planning for impl-engineer role