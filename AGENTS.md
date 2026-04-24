* **Setup Requirements**
  - Ensure Docker is installed and running
  - Clone repository and populate environment variables from `.env.example`
  - Required tools: Python 3.10+, pip, Docker Compose

* **Starting the Platform**
  1. Build Docker containers:
     ```bash
     cd mcp-server && docker-compose build
     ```
  2. Start services:
     ```bash
     docker-compose up -d
     ```
  3. Initialize MCP server:
     ```bash
     cd automation && python main.py start
     ```

* **Project Workflow**
  - Navigate to example app: `cd projects/example-app`
  - Run tests:
     ```bash
     python -m pytest tests/
     ```
  - Start dev server:
     ```bash
     npm run dev
     ```

* **Key Directories**
  - `.ai/` folder contains agent frameworks and memory storage
  - `automation/` holds custom tools and agent integrations
  - `mcp-server/` contains the core MCP interface
  - `infrastructure/` manages container orchestration

* **Common Commands**
  - List services: `docker-compose ps`
  - Stop platform: `docker-compose down`
  - Clean build artifacts: `docker-compose rm -f`

* **Agent-Specific Notes**
  - Use `projects/` directory for isolated experiments
  - Persistence requires manual memory management in `.ai/memory`
  - Docker builds must match `Dockerfile` versions

* **Structural Constraints**
  - Don't modify `package.json` versions without testing
  - All test coverage must run through `pytest` configuration
  - MCP client communication follows `mcp_client.py` API

* **Version Control**
  - Push to `main` branch for production-ready code
  - Tag releases with meaningful semantic versioning