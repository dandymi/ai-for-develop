# Tailscale VPN Access for Docker Apps

When a Docker container needs to be reachable from other devices on the Tailscale network:

## Check Tailscale Status
```bash
tailscale status                    # list connected devices
tailscale ip -4                   # get this machine's Tailscale IP
```

## Verify Port Binding
The container must bind to 0.0.0.0 (not localhost) for Tailscale access:
```bash
# For direct Node.js apps:
ps aux | grep node -A1          # check listening address

# For Docker containers:
docker ps                        # check port mapping
ss -tlnp | grep <port>          # verify host binding
```

Expected binding:
- `*:3000` or `0.0.0.0:3000` ✓ (accessible via Tailscale)
- `127.0.0.1:3000` ✗ (only localhost)

## Test Tailscale Access
```bash
# From the VPS itself (simulates remote access):
curl http://$(tailscale ip -4):3000/

# Or with explicit IP:
curl http://100.89.99.65:3000/
```

## Docker Run Flags for Tailscale
```yaml
# docker-compose.yml
services:
  app:
    ports:
      - "3000:3000"        # publishes to all interfaces
```

Or with docker run:
```bash
docker run -d -p 3000:3000 --name app container-name