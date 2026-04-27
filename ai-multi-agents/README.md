# AI Multi-Agent Software Development Platform

A self-hosted autonomous AI software company in Docker, featuring multiple specialized agents working together to help with software development.

## Architecture Overview

```
                    ┌──────────────────────┐
                    │      Traefik SSL     │
                    │  Reverse Proxy       │
                    └──────────┬───────────┘
                               │
        ┌──────────────────────┼──────────────────────────┐
        ▼                      ▼                          ▼

 ┌──────────────┐     ┌──────────────┐           ┌──────────────┐
 │   Multica    │     │ Hermes Core  │           │   Grafana    │
 │ PM Dashboard │     │ Coordinator  │           │ Monitoring   │
 └──────┬───────┘     └──────┬───────┘           └──────────────┘
        │                    │
        │                    ▼
        │          ┌───────────────────┐
        │          │ Honcho Memory     │
        │          └───────────────────┘
        │
        ▼
 ┌────────────────────────────────────────────────────────────┐
 │                 Specialized OpenClaw Agents               │
 ├────────────────────────────────────────────────────────────┤
 │ Analyst Agent → Planner Agent → Coder Agent                │
 │ Reviewer Agent → Tests Agent → Deploy Agent                │
 │                    ↓                                       │
 │            Standup Agent (Scrum Master)                    │
 └────────────────────────────────────────────────────────────┘

                       ▼
            ┌─────────────────────┐
            │ Ollama GPU Cluster  │
            └─────────────────────┘

                       ▼
            ┌─────────────────────┐
            │ OpenRouter Models   │
            └─────────────────────┘
```

## Components

### Core Services

| Service | Role | Description |
|---------|------|-------------|
| **Traefik** | Reverse Proxy | SSL termination and routing |
| **Multica** | Project Management | Task and workforce management UI |
| **Hermes** | Coordinator | Strategic planning and delegation |
| **Honcho** | Memory | Persistent memory provider |
| **Ollama** | Local LLMs | GPU-accelerated local models |

### Specialized Agents

| Agent | Model | Specialty |
|-------|-------|-----------|
| **Analyst** | Claude 3 Opus (OpenRouter) | Requirements analysis |
| **Planner** | GPT-5 (OpenRouter) | Architecture & sprint planning |
| **Coder** | DeepSeek Coder 33B (Ollama) | Code implementation |
| **Reviewer** | Gemini 2.5 Pro (OpenRouter) | Code quality & security review |
| **Tests** | Qwen 2.5 Coder 14B (Ollama) | Test generation |
| **Deploy** | Llama 3.1 8B (Ollama) | DevOps & deployment |
| **Standup** | Mistral 7B (Ollama) | Daily standups & reporting |

## Quick Start

### Prerequisites

- Docker 24.0+
- Docker Compose 2.20+
- NVIDIA Docker runtime (for GPU support)
- 32GB+ RAM (64GB+ recommended)
- NVIDIA GPU with 8GB+ VRAM (optional but recommended)

### Installation

1. **Clone and navigate to the directory:**
```bash
cd ai-multi-agents
```

2. **Configure environment variables:**
```bash
cp .env .env.local
# Edit .env.local with your API keys
```

3. **Start the platform (V1 - Basic):**
```bash
docker-compose up -d
```

4. **Start the platform (V2 - Full Production):**
```bash
docker-compose -f docker-compose-v2.yml up -d
```

5. **Pull Ollama models (V2 only):**
```bash
docker exec -it ai-company-v2-ollama-main-1 ollama pull deepseek-coder:33b
docker exec -it ai-company-v2-ollama-main-1 ollama pull mistral:7b
docker exec -it ai-company-v2-ollama-worker2-1 ollama pull qwen2.5-coder:14b
docker exec -it ai-company-v2-ollama-worker2-1 ollama pull llama3.1:8b
```

### Access Points

| Service | URL | Credentials |
|---------|-----|-------------|
| Multica | http://multica.localhost | - |
| Grafana | http://grafana.localhost | admin/admin123 |
| Traefik | http://localhost:8080 | - |
| Prometheus | http://localhost:9090 | - |

## Configuration Files

### Environment Variables (`.env`)

```env
# Required API Keys
OPENROUTER_API_KEY=your_openrouter_key
OPENAI_API_KEY=your_openai_key

# Database
POSTGRES_USER=ai
POSTGRES_PASSWORD=strongpassword
POSTGRES_DB=company

# Grafana
GRAFANA_ADMIN_PASSWORD=admin123
```

### Hermes Routing (`configs/hermes/routing.yml`)

Configure model routing, agent endpoints, and workflow settings.

### Agent Configs (`configs/agents/*.yml`)

Individual agent configurations for specialized roles.

## Workflow

### Example: Building a New Feature

1. **Create task in Multica:**
   > "Build a FastAPI authentication microservice"

2. **Analyst Agent** analyzes requirements and identifies edge cases

3. **Planner Agent** designs architecture and creates sprint tasks

4. **Coder Agent** implements the feature

5. **Reviewer Agent** reviews code for quality and security

6. **Tests Agent** generates comprehensive test suite

7. **Deploy Agent** creates Docker configs and CI/CD pipeline

8. **Standup Agent** reports daily progress

## Monitoring

### Grafana Dashboards

Access Grafana at http://grafana.localhost to monitor:

- Token usage by model
- Daily costs
- Task completion rates
- Agent latency
- Failed tasks
- Model usage split (local/cloud)
- Memory utilization

### Prometheus Metrics

Prometheus collects metrics from all services at http://localhost:9090.

## Cost Control

The V2 stack includes budget controls:

- **Daily limit:** $10 USD default
- **Auto fallback:** Switch to local Ollama models when budget exceeded
- **Alert threshold:** 80% of budget triggers warnings

Configure in `configs/hermes/routing.yml`:

```yaml
budget:
  daily_limit_usd: 10.0
  fallback_to_local: true
  alert_threshold: 0.8
```

## Development Mode

For development without GPU:

1. Comment out GPU reservations in `docker-compose-v2.yml`
2. Use CPU-only Ollama models (slower but functional)
3. Or use OpenRouter exclusively

## Troubleshooting

### Services failing to start

```bash
# Check logs
docker-compose logs -f [service-name]

# Restart specific service
docker-compose restart [service-name]
```

### Ollama models not loading

```bash
# Check Ollama status
docker exec ai-company-v2-ollama-main-1 ollama list

# Pull models manually
docker exec ai-company-v2-ollama-main-1 ollama pull [model-name]
```

### Memory issues

Reduce parallel workers in `configs/hermes/routing.yml`:

```yaml
task_flow:
  parallel_workers: 1  # Reduce from 3
```

## Version Differences

### V1 (docker-compose.yml)
- Basic 3-agent setup (dev, qa, ops)
- OpenAI API only
- Simple architecture
- Good for testing

### V2 (docker-compose-v2.yml)
- 7 specialized agents
- Hybrid OpenRouter + Ollama
- Full monitoring stack
- Traefik reverse proxy
- Honcho memory
- Production-ready

## Hardware Recommendations

### Minimum
- Ryzen 7 / Intel i7
- 32GB RAM
- 100GB SSD

### Recommended
- Ryzen 9 / Intel i9
- 64GB+ RAM
- RTX 4090 / RTX 3090
- 500GB NVMe SSD

### Production
- Threadripper / Xeon
- 128GB+ RAM
- RTX 4090 x2
- 2TB NVMe SSD

## Security Notes

- Change default passwords in `.env`
- Use strong API keys
- Enable Traefik SSL in production
- Restrict Docker socket access
- Review agent permissions

## Contributing

This is a research project. Feel free to:
- Submit issues
- Propose improvements
- Share configurations
- Report bugs

## License

MIT License - See LICENSE file

## Acknowledgments

- [Multica](https://github.com/multica-ai/multica) - Project management
- [Hermes Agent](https://github.com/NousResearch/hermes-agent) - Coordinator
- [OpenClaw](https://github.com/openclaw/openclaw) - Execution agents
- [Honcho](https://github.com/plastic-labs/honcho) - Memory provider
- [Ollama](https://ollama.ai) - Local LLMs
