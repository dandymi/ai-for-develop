# Port Checking Commands

Quick commands to verify if an application is listening on a specific port:

## Linux/Unix

```bash
# Check what's listening on a specific port
netstat -tlnp 2>/dev/null | grep 3000 || ss -tlnp 2>/dev/null | grep 3000

# Check if anything is listening
ss -tlnp | head -10

# Test HTTP endpoint
curl -s http://localhost:3000/ | head -20
curl -s http://localhost:3000/api/health
```

## Docker Port Mappings

When Docker proxies ports, check processes:
```bash
# Find docker-proxy processes
ps aux | grep docker-proxy | grep 3000

# Check actual container port
docker ps --format "table {{.Names}}\t{{.Ports}}"
```

## Quick Health Check Script

```bash
#!/bin/bash
# verify_port.sh - Check if an app is running on expected port

PORT=${1:-3000}
ENDPOINT=${2:-/}

# Check listening
if ss -tlnp 2>/dev/null | grep -q ":$PORT "; then
    echo "✓ Port $PORT is listening"
elif netstat -tlnp 2>/dev/null | grep -q ":$PORT "; then
    echo "✓ Port $PORT is listening"
else
    echo "✗ Nothing listening on port $PORT"
fi

# Check HTTP
response=$(curl -s http://localhost:$PORT$ENDPOINT 2>/dev/null | head -5)
if [ -n "$response" ]; then
    echo "✓ HTTP endpoint responds: $response..."
else
    echo "✗ HTTP endpoint not responding"
fi
```