# Docker Permission Troubleshooting

## Common Permission Denied Scenarios

### Docker Socket Permission Denied

**Error:** `permission denied while trying to connect to the docker API at unix:///var/run/docker.sock`

**Root cause:** Current user not in `docker` group or container runtime not running.

```bash
# Check Docker installation
which docker && docker --version

# Check group membership
groups | grep docker

# Verify socket exists and permissions
ls -la /var/run/docker.sock
# Should be: srw-rw---- 1 root docker

# Check if Docker daemon is running
systemctl status docker 2>/dev/null || service docker status
```

### Fallback: Direct Execution

When Docker permissions are unavailable, run the app directly:

```bash
# For Node.js apps
cd /path/to/app && PORT=3000 node server.js

# For Python apps  
cd /path/to/app && python3 app.py

# Verify it started
curl http://localhost:3000/
```

### Docker vs Direct Execution Checklist

1. **Before assuming Docker:** Check if app already has Dockerfile/docker-compose.yml
2. **Before trying Docker:** Verify `docker ps` works without sudo
3. **When Docker fails:** Fall back to direct execution and inform user
4. **After starting:** Always verify the app responds on expected port