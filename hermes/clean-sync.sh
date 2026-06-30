#!/bin/bash
# Clean sync script - removes cache/sensitive files and prepares for git commit

set -e

SYNC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE_DIR="$SYNC_DIR/profiles"

echo "Cleaning profile directories..."

# Remove excluded file patterns
find "$PROFILE_DIR" -type f -name "*.db" -delete 2>/dev/null || true
find "$PROFILE_DIR" -type f -name "*.db-shm" -delete 2>/dev/null || true
find "$PROFILE_DIR" -type f -name "*.db-wal" -delete 2>/dev/null || true
find "$PROFILE_DIR" -type f -name "*.lock" -delete 2>/dev/null || true
find "$PROFILE_DIR" -type f -name "auth.json" -delete 2>/dev/null || true
find "$PROFILE_DIR" -type d -name "cache" -exec rm -rf {} + 2>/dev/null || true
find "$PROFILE_DIR" -type d -name ".cache" -exec rm -rf {} + 2>/dev/null || true
find "$PROFILE_DIR" -type d -name "image_cache" -exec rm -rf {} + 2>/dev/null || true
find "$PROFILE_DIR" -type d -name "audio_cache" -exec rm -rf {} + 2>/dev/null || true

echo "Removing large files from git tracking if present..."
git rm -r --cached "$PROFILE_DIR"/**/state.db 2>/dev/null || true
git rm -r --cached "$PROFILE_DIR"/**/response_store.db 2>/dev/null || true
git rm -r --cached "$PROFILE_DIR"/**/verification_evidence.db 2>/dev/null || true

echo "Sync directory cleaned. Ready for git commit."