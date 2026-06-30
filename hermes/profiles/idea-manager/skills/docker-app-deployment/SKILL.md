---
name: docker-app-deployment
description: "Deploy existing applications in Docker containers: Dockerfiles, docker-compose.yml, permission troubleshooting, and fallback strategies."
version: 1.0.0
author: idea-manager
category: software-development
---

# Docker Application Deployment

This skill covers deploying existing applications (Node.js, Python, etc.) in Docker containers, including:
- Verifying existing Docker setups
- Creating minimal Dockerfiles and docker-compose.yml configs
- Handling docker.sock permission issues
- Environment variable configuration for containerized apps

## When to Use

- Checking if an app should be running in Docker
- Creating Docker configuration for an existing app
- Troubleshooting Docker permission errors
- Verifying container port mappings

## Quick Start Pattern

### For Node.js apps (like the weather app):

1. **Check app structure:**
   ```bash
   ls -la /path/to/app/
   cat package.json  # verify main entry point
   ```

2. **Create Dockerfile (minimal):**
   ```dockerfile
   FROM node:20-alpine
   WORKDIR /app
   COPY package*.json ./
   RUN npm ci --only=production
   COPY . .
   EXPOSE 3000
   CMD ["node", "server.js"]
   ```

3. **Create docker-compose.yml:**
   ```yaml
   services:
     app-name:
       build: .
       ports:
         - "3000:3000"
       volumes:
         - ~/.hermes/weather/weather.db:/app/weather.db:ro
       environment:
         - PORT=3000
         - DB_PATH=/app/weather.db
   ```

4. **Make app configurable via env vars** (patch server.js):
   ```javascript
   const DB_PATH = process.env.DB_PATH || './default.db';
   ```

5. **Check Docker access:**
   ```bash
   docker ps  # if permission denied, start app directly as fallback
   ```

## Pitfall: Docker Permission Denied

When `docker ps` returns "permission denied while trying to connect to the docker API at unix:///var/run/docker.sock":

### Diagnosis:
- **Check group membership:** `getent group docker` - verify user is listed
- **Check socket perms:** `ls -la /var/run/docker.sock` should show `srw-rw---- root docker`
- **If user IS in docker group but still denied:** The shell session hasn't picked up the group membership

### Solutions:
1. **Use `newgrp docker` subshell** (best for scripts):
   ```bash
   newgrp docker << 'EOF'
   docker build -t app-name /path/to/app/
   docker run -d -p 3000:3000 --name app-container app-name
   EOF
   ```

2. **Direct execution as fallback:** `node server.js` instead of `docker compose up`
3. **Inform user:** Ask if they want elevated permissions or accept direct execution

## Template Directory

- `templates/nodejs-dockerfile` - Minimal Node.js Dockerfile template
- `templates/docker-compose-nodejs` - docker-compose.yml template with volume mounts

## References Directory

- `references/docker-troubleshooting.md` - Common Docker issues and fixes
- `references/port-check.md` - Port verification commands
- `references/tailscale-access.md` - Tailscale VPN access verification

## Verification

After starting:
```bash
curl http://localhost:3000/api/health  # or main endpoint
curl http://localhost:3000/            # for HTML apps
```

### Tailscale VPN Access Verification:
If the app should be reachable via Tailscale:
```bash
tailscale ip -4                         # get Tailscale IP (e.g., 100.89.99.65)
curl http://$(tailscale ip -4):3000/   # verify Tailscale-accessible endpoint
```

Ensure the app binds to `0.0.0.0` (not just `127.0.0.1`) in the container/host:
```bash
ss -tlnp | grep 3000  # should show *:3000 or 0.0.0.0:3000
```