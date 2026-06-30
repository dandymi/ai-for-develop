# Cron Jobs for SDLC Pipeline Monitoring

Patterns extracted from meteo/matita weather service monitoring.

## Job Configuration

Cron jobs are stored in `.hermes/cron/jobs.json` and managed via `hermes cron` commands.

## Two Execution Modes

| Mode | Config | Use Case |
|------|--------|----------|
| Script | `no_agent: true` + `script:` | Lightweight data collection, HTTP polling, shell commands |
| Agent | `no_agent: false` + `prompt:` | Complex decisions, multi-step workflows, chat delivery |

## Common SDLC Monitoring Schedules

| Schedule Expression | Meaning | Examples |
|---------------------|---------|----------|
| `0 */12 * * *` | Every 12 hours | Health checks, data sync, weather fetch |
| `0 8 * * *` | Daily at 8:00 | Morning reports, backup validation, summary generation |
| `*/30 * * * *` | Every 30 minutes | Live service monitoring |
| `0 9 * * 1` | Weekly on Monday 9:00 | Weekly reports, cleanup tasks |

## Job Structure

```json
{
  "jobs": [
    {
      "id": "<uuid>",
      "name": "descriptive_name",
      "schedule": {
        "kind": "cron",
        "expr": "<crontab-expression>"
      },
      "script": "<script_name.sh>",     // OR
      "prompt": "task instructions",
      "no_agent": true,                 // for script mode
      "deliver": "telegram|local|all",  // delivery target
      "last_run_at": "ISO timestamp",
      "last_status": "ok|error",
      "enabled": true
    }
  ]
}
```

## Script-Based Cron Jobs (Lightweight)

Example: Weather data fetch every 12 hours
```
# Job: weather_fetch
# Schedule: 0 */12 * * *
# Script: run_weather.sh
# Delivery: local (no chat delivery)
```

Use when:
- Fetching external APIs
- Simple shell commands
- No decision-making needed
- Silent execution required

## Agent-Based Cron Jobs (Complex)

Example: Morning weather report at 8:00
```
# Job: Matita weather
# Schedule: 0 8 * * *
# Prompt: "Run weather script and format for Telegram"
# Deliver: telegram:73966827
```

Use when:
- Formatting/output transformation needed
- Conditional logic between steps
- Chat notification required
- External system integration

## Verification Commands

```bash
hermes cron list                       # List all jobs
cat .hermes/cron/jobs.json             # Raw job data
hermes cron run <job_id>               # Force immediate run
hermes cron update <job_id> status     # Check execution status
```

## Pitfalls

1. **Jobs don't appear in profile-specific lists** — Use main profile `hermes cron list`, not `hermes -p profile cron list`

2. **next_run_at uses local timezone** — Schedule expressions are in system timezone

3. **Script path resolution** — Scripts referenced by filename must exist in accessible paths