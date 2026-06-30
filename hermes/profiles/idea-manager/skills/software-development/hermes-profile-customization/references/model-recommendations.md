# Model Recommendations by Role

Detailed rationale for model selection per pipeline role.

---

## Model Selection Criteria

| Criterion | Weight | Notes |
|-----------|--------|-------|
| Reasoning/Coding Ability | High | For technical roles |
| Conversation/Clarification | High | For user-facing roles |
| Context Window | Medium | Large specs need space |
| Cost Efficiency | Medium | High-volume roles |
| Speed | Low-Medium | Depends on latency tolerance |
| Provider Availability | Required | Must be accessible |

---

## Role Recommendations

### idea-manager → `google/gemini-2.5-flash-preview-05-20` (OpenRouter)

**Why:** Excellent conversational ability, strong at asking clarifying questions, good at synthesizing vague ideas into structure. Fast and cost-effective for iterative dialogue.

**Alternatives:**
- `anthropic/claude-3.5-haiku` — Faster, cheaper, good enough
- `openai/gpt-4o-mini` — Solid all-rounder
- `meta-llama/llama-3.3-70b-instruct` — Free on some providers

**Avoid:** Overly coding-specialized models (wasted capability).

---

### specs-analyst → `claude-sonnet-4.6` (GitHub Copilot)

**Why:** Superior reasoning for technical trade-offs, excellent at structured document generation, strong at presenting options with pros/cons for user decisions. Large context for complex specifications.

**Alternatives:**
- `anthropic/claude-3.7-sonnet` — Equivalent via API
- `openai/gpt-4.1` — Strong structured output
- `google/gemini-2.5-pro` — Large context, good reasoning

**Provider Note:** Requires Copilot OAuth (`hermes auth add github-copilot`).

---

### impl-engineer → `anthropic/claude-3.7-sonnet` (OpenRouter)

**Why:** Best-in-class for implementation planning, code structure design, dependency mapping. Strong at breaking down specs into actionable tasks with correct ordering.

**Alternatives:**
- `claude-sonnet-4.6` (Copilot) — Same capability
- `openai/o1` / `o3-mini` — Strong reasoning, slower
- `google/gemini-2.5-pro` — Good for large codebase context

---

### code-developer → `anthropic/claude-3.7-sonnet` (OpenRouter)

**Why:** Industry-leading code generation, follows instructions precisely, produces idiomatic code across languages/frameworks. Handles large implementations without losing coherence.

**Alternatives:**
- `claude-sonnet-4.6` (Copilot) — Same model family
- `openai/gpt-4.1` — Strong, slightly different style
- `deepseek/deepseek-coder-v2` — Good open-weight option

---

### code-reviewer → `claude-sonnet-4.6` (Copilot)

**Why:** Exceptional at finding subtle bugs, anti-patterns, and maintainability issues. Strong reasoning about code correctness beyond syntax.

**Alternatives:**
- `anthropic/claude-3.7-sonnet` — Equivalent via API
- `openai/o1-preview` — Deep reasoning for complex reviews

---

### security-checker → `claude-sonnet-4.6` (Copilot)

**Why:** Strong security knowledge, good at vulnerability pattern recognition, understands OWASP/CWE classifications.

**Alternatives:**
- `anthropic/claude-3.7-sonnet` — Same capability
- Consider specialized security models if available

---

### app-tester → `google/gemini-2.5-flash-preview-05-20` (OpenRouter)

**Why:** Fast execution, good at following test scripts, cost-effective for repeated test runs. Can interact with running applications via terminal/browser tools.

**Alternatives:**
- `anthropic/claude-3.5-haiku` — Very fast, cheap
- `openai/gpt-4o-mini` — Reliable instruction following

---

### code-documenter → `nvidia/nemotron-3-ultra:free` (Nous) or `google/gemini-2.5-flash-preview-05-20`

**Why:** Strong technical writing, good at explaining code. Free tier available on Nous.

**Alternatives:**
- `anthropic/claude-3.5-sonnet` — Excellent prose
- `openai/gpt-4o` — Strong documentation style

---

### deployer → `anthropic/claude-3.7-sonnet` (OpenRouter)

**Why:** Infrastructure as code, CI/CD configuration, cloud provider specifics — all benefit from strong coding + reasoning.

**Alternatives:**
- `claude-sonnet-4.6` (Copilot)
- `openai/gpt-4.1` — Good for YAML/terraform/scripts

---

### architect → `moonshotai/kimi-k2.6` (OpenRouter)

**Why:** Large context window for tracking multiple agents, strong coordination/planning ability, good at synthesizing cross-agent feedback loops.

**Alternatives:**
- `google/gemini-2.5-pro` — 2M context, strong reasoning
- `anthropic/claude-3.7-sonnet` — Solid all-rounder

---

## Provider Setup Commands

```bash
# OpenRouter (most models)
export OPENROUTER_API_KEY=...
hermes -p <profile> config set model.provider openrouter

# GitHub Copilot (Claude Sonnet 4.6, GPT-4.1, etc.)
hermes auth add github-copilot
hermes -p <profile> config set model.provider copilot

# Nous Portal (Nemotron, etc.)
hermes auth add nous
hermes -p <profile> config set model.provider nous

# Local models (Ollama, etc.)
hermes -p <profile> config set model.provider ollama
hermes -p <profile> config set model.base_url http://localhost:11434/v1
```

---

## Cost Optimization Notes

| Role | Volume | Cost Strategy |
|------|--------|---------------|
| idea-manager | Low (per project) | Use best model |
| specs-analyst | Low | Use best model |
| impl-engineer | Low | Use best model |
| code-developer | **High** | Consider `claude-3.5-haiku` for simple tasks |
| code-reviewer | Medium | Use best model |
| security-checker | Medium | Use best model |
| app-tester | **High** (many runs) | Use `gemini-2.5-flash` or `claude-3.5-haiku` |
| code-documenter | Low | Use free/cheap model |
| deployer | Low | Use best model |
| architect | Low | Use best model |

**Tip:** For code-developer and app-tester (high volume), consider tiered approach:
- Complex tasks → Best model
- Routine/boilerplate → Cheaper model
- Use `hermes model` to switch per-session