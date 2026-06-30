---
name: multi-agent-profiles
description: "Configure and manage specialized Hermes profiles for a multi-agent software development pipeline."
version: 1.0.0
author: Hermes Agent
license: MIT
created_by: agent
---

# Multi-Agent Profile Specialization

This skill documents the workflow for creating specialized Hermes profiles in a multi-agent software development pipeline. Based on the pattern discovered during the idea-manager configuration session.

## The 9-Stage Pipeline Pattern

When running a multi-agent software development lifecycle, create specialized profiles with focused models and skill sets:

| Stage | Profile | Model | Focus |
|-------|---------|-------|-------|
| 1 | idea-manager | Gemini 2.5 Flash, GPT-4.1 | Ideation, user conversations, idea refinement |
| 2 | specs-analyst | Claude Sonnet 4, GPT-4.1 | Requirements analysis, spec generation |
| 3 | impl-engineer | Kimi K2, DeepSeek Chat | Technical architecture, implementation planning |
| 4 | code-developer | Claude 3.7, GPT-4.1 | Code generation, feature implementation |
| 5 | code-reviewer | Gemini 2.5 Flash, Claude 3.7 | Code review, quality checks |
| 6 | security-checker | Claude 3.7, GPT-4o | Security audit, vulnerability analysis |
| 7 | code-documenter | GPT-4o, Nemotron | Documentation, user guides, READMEs |
| 8 | app-tester | GPT-4o, Gemini Flash | Testing, bug finding, validation |
| 9 | deployer | GPT-4o, Claude 3.7 | Deployment, packaging, infrastructure |

## Creating a Specialized Profile

### Step 1: Create Profile
```bash
hermes profile create <name>
hermes profile use <name>
```

### Step 2: Set Model
```bash
hermes config set model.default "<model-name>"
```

### Step 3: Configure Skills
Disable skills irrelevant to the stage's focus:
```bash
# Note: creates JSON string in config (functional)
hermes config set skills.disabled '["skill-a","skill-b"]'
```

### Step 4: Create SOUL.md
Each profile needs a SOUL.md with:
- Role identity (e.g., "You are the X agent")
- Upstream/downstream relationships
- Feedback loop instructions
- Core tool list

## Toolsets by Stage

| Stage | Core Toolsets | Rationale |
|-------|---------------|-----------|
| idea-manager | web, clarify, memory, todo, session_search | Research, questioning, remembering |
| specs-analyst | web, clarify, memory, todo | Research, analysis |
| impl-engineer | web, terminal, file | Architecture, planning |
| code-developer | terminal, file, code_execution | Coding |
| code-reviewer | terminal, file, web | Review, research |
| security-checker | terminal, file, web | Security analysis |
| code-documenter | web, file | Documentation research |
| app-tester | terminal, file | Testing |
| deployer | terminal, file | Deployment |

## Verification Workflow

```bash
# Verify profile configuration
hermes profile list
hermes profile show <name>

# Check tools available
hermes tools list

# Check skills
hermes skills list

# Check config values
grep -A2 "^model:" ~/.hermes/profiles/<name>/config.yaml
```

## Pitfalls & Corrections Discovered

### Pitfall 1: Config Write Protection
- **Issue**: Direct file writes to config.yaml are blocked
- **Fix**: Use `hermes config set` command instead

### Pitfall 2: Skills.disabled JSON Format
- **Issue**: `hermes config set skills.disabled` stores as JSON string, not YAML list
- **Fix**: Both formats work functionally - no action needed

### Pitfall 3: Tool Changes Require Reset
- **Issue**: Tool/skill changes don't apply mid-session
- **Fix**: User needs `/reset` or new session invocation

### Pitfall 4: Default Config Inheritance
- **Issue**: Profiles without config.yaml use base settings
- **Fix**: Create config.yaml to override model/defaults