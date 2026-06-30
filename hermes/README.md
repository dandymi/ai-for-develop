# Hermes Profile Sync

This directory contains exported Hermes agent profiles for sharing across installations and version control.

## Overview

- **Purpose**: Portable profile configurations that can be transferred to another Hermes installation
- **Location**: `~/mygithub/ai-for-develop/hermes/`
- **Exported**: 2026-06-30

## Directory Structure

```
hermes/
├── profiles/              # Exported profile data
│   ├── idea-manager/      # Current active profile
│   ├── architect/         # Architecture planning profile
│   ├── code-developer/    # Code development profile
│   ├── code-reviewer/     # Code review profile
│   ├── ...                # Other profiles
│   └── .../               # Each profile contains:
│       ├── config.yaml    # Profile configuration (redacted)
│       ├── skills/        # Custom skills and their references/templates/scripts
│       ├── memories/      # Persistent memory entries
│       ├── cron/          # Scheduled jobs (preserving triggers)
│       ├── .github/       # GitHub automation configs
│       └── ...
├── sync-profiles.py       # Script to re-export profiles
├── profiles.manifest.json # Summary of all exported profiles
└── README.md              # This file
```

## What's Included

### ✅ Synced Content
- **Skills**: All custom skills with references, templates, and scripts
- **Memories**: Persistent memory entries across profiles
- **Cron jobs**: Scheduled job definitions (output/logs excluded)
- **Config**: Profile configurations (API keys redacted for security)
- **Plugins**: Plugin configurations
- **Plans**: Plan documents
- **Workspace**: Shared workspace configurations

### ❌ Excluded Content
- `auth.json` - API keys and authentication tokens
- `*.db` files - SQLite databases (state/response stores)
- `cache/` - Large cache directories
- `image_cache/`, `audio_cache/` - Media caches
- `.cache/` - Python/uv cache files
- `home/.cache/` - Home cache files
- Any file with "secret", "password", "token", "auth" in its path

## How to Use

### On the Source Machine (this one)

1. **Initial export** (already done):
   ```bash
   python3 ~/mygithub/ai-for-develop/hermes/sync-profiles.py --all
   ```

2. **Commit to GitHub**:
   ```bash
   cd ~/mygithub/ai-for-develop
   git add hermes/profiles/
   git commit -m "Update Hermes profiles"
   git push
   ```

### On the Destination Machine

1. **Clone the repository**:
   ```bash
   git clone <repo-url> ~/mygithub/ai-for-develop
   ```

2. **Import a profile**:
   ```bash
   # Copy the profile directory to Hermes profiles
   cp -r ~/mygithub/ai-for-develop/hermes/profiles/idea-manager ~/.hermes/profiles/
   
   # Or use the built-in import command
   hermes profile import ~/mygithub/ai-for-develop/hermes/profiles/idea-manager.tar.gz
   ```

3. **Set the profile as active**:
   ```bash
   hermes profile use idea-manager
   ```

4. **Re-authenticate** (API keys are redacted):
   ```bash
   hermes auth openrouter  # or other providers you use
   ```

## Profiles Included

See `profiles.manifest.json` for a detailed listing, or:

```
Profile         Model                              Provider
─────────────   ─────────────────────────────────  ───────────
deployer        claude-3.5-sonnet                    openrouter
code-developer  claude-3.7-sonnet                    openrouter
security-checker claude-sonnet-4                   openrouter
idea-manager    laguna-m.1 (free)                 openrouter
app-tester      o4-mini                            openrouter
code-documenter nemotron-3-ultra (free)             nous
impl-engineer   kimi-k2.6                          openrouter
specs-analyst   claude-sonnet-4.6                  copilot
architect       kimi-k2.6                          openrouter
code-reviewer   claude-sonnet-4                    openrouter
```

## Updating Profiles

To refresh the sync after making changes to profiles:

```bash
# Re-export all profiles
python3 ~/mygithub/ai-for-develop/hermes/sync-profiles.py --all

# Or export specific profiles
python3 ~/mygithub/ai-for-develop/hermes/sync-profiles.py --profiles architect code-developer
```

## Security Notes

- All `api_key`, `password`, `token`, and `secret` values in `config.yaml` are replaced with `***REDACTED***`
- Auth JSON files are not synced - you'll need to re-authenticate on new installations
- Cache directories are excluded to keep repository size manageable

## Additional Scripts

Place any helper scripts in the `scripts/` directory. These are also synced but are user-defined utilities.