# Multi-Agent System Setup Guide

This bash script provides a guided setup for configuring a multi-agent Hermes system, allowing you to manage customers and projects.

## Features

- **Customer Management**: Add, list, modify, and delete customers
- **Project Management**: Add, list, modify, and delete projects associated with customers
- **Hermes Integration**: Helper to create Hermes profiles for projects
- **System Status**: View overview of configured customers and projects

## Prerequisites

- bash shell
- jq (JSON processor) - install with: `sudo apt install jq` (Ubuntu/Debian) or equivalent
- Hermes Agent installed (for profile creation helper)

## Usage

1. Make the script executable (if not already done):
   ```bash
   chmod +x setup.sh
   ```

2. Run the setup script:
   ```bash
   ./setup.sh
   ```

3. Follow the interactive menu to:
   - Initialize the system directories
   - Manage customers (add, list, modify, delete)
   - Manage projects (add, list, modify, delete)
   - Create Hermes profiles for projects
   - View system status

## Directory Structure

The script creates the following directory structure under `~/.hermes/multi-agent/`:

```
~/.hermes/multi-agent/
├── customers/
│   ├── customer1.json
│   └── customer2.json
└── projects/
    ├── project1.json
    └── project2.json
```

## Customer JSON Format

```json
{
    "id": "customer_id",
    "name": "Customer Name",
    "description": "Customer description",
    "created_at": "2026-05-15T07:56:00Z",
    "projects": ["project1_id", "project2_id"]
}
```

## Project JSON Format

```json
{
    "id": "project_id",
    "customer_id": "customer_id",
    "name": "Project Name",
    "description": "Project description",
    "hermes_profile": "profile_name",
    "created_at": "2026-05-15T07:56:00Z",
    "status": "active"
}
```

## Hermes Profile Helper

When creating a Hermes profile for a project, the helper will:
1. Create a profile directory at `~/.hermes/profiles/<profile_name>/`
2. Generate a basic `config.yaml` with recommended settings
3. Create an `env.example` file for API keys (copy to `.env` and fill in your keys)

To use a created profile with Hermes:
```bash
hermes -p <profile_name>          # Interactive chat
hermes -p <profile_name> chat -q "Your question"
```

## Notes

- All data is stored as JSON files for easy backup and version control
- The script includes basic validation to prevent orphaned references
- Customer deletion is blocked if they have associated projects
- Project deletion automatically removes the reference from the customer
- Hermes profile creation is a helper - you still need to configure API keys

## Customization

You can modify the script to:
- Change the base directory (`BASE_DIR` variable)
- Adjust default Hermes profile settings
- Add additional fields to customer/project JSON structures
- Integrate with other tools or systems

## Safety

- The script uses `set -euo pipefail` for better error handling
- JSON modifications use `jq` to ensure valid format
- Backup files are created during modifications (though not explicitly shown in the script for brevity)
- Always backup your `~/.hermes/multi-agent/` directory before making major changes