#!/usr/bin/env python3
"""
Hermes Profile Sync - Export profile configurations for GitHub sharing
==============================================================
This script exports Hermes profile data to a GitHub-friendly format,
excluding sensitive information (API keys, auth tokens, large caches).
"""

import os
import json
import yaml
from pathlib import Path
import shutil
import argparse

HERMES_HOME = Path.home() / ".hermes" / "profiles"
SYNC_DIR = Path(__file__).parent

# Items to exclude from sync (sensitive or large binary caches)
EXCLUDE_PATTERNS = [
    ".cache",
    "cache",
    "image_cache",
    "audio_cache",
    "*.db", "*.db-shm", "*.db-wal",
    "auth.json",
    "auth.lock",
    "models_dev_cache.json",
    "provider_models_cache.json",
    "ollama_cloud_models_cache.json",
    ".update_check",
    ".skills_prompt_snapshot.json",
    "response_store.db",
    "verification_evidence.db",
    "home/.cache",
    "process.json",
    ".restart_pending.json",
    "gateway_state.json",
]

# Items to redact in config files
REDACT_KEYS = ["api_key", "password", "token", "secret"]


def clean_dict(d, parent_key=""):
    """Recursively redact sensitive values from config dictionaries."""
    if isinstance(d, dict):
        return {
            k: "***REDACTED***" if any(redact in k.lower() for redact in REDACT_KEYS)
            else clean_dict(v, k)
            for k, v in d.items()
        }
    elif isinstance(d, list):
        return [clean_dict(item, parent_key) for item in d]
    else:
        return d


def should_exclude(path: Path) -> bool:
    """Check if a path should be excluded from sync."""
    # Explicit exclusions
    exclusions = [
        ".skills_prompt_snapshot.json", ".clean_shutdown", ".update_check",
        ".restart_pending.json", "gateway_state.json", "auth.lock",
        "models_dev_cache.json", "provider_models_cache.json",
        "ollama_cloud_models_cache.json", "response_store.db",
        "verification_evidence.db", "processes.json"
    ]
    
    path_str = str(path)
    name = path.name
    
    for excl in exclusions:
        if name == excl:
            return True
    
    # Directory exclusions
    excluded_dirs = ["cache", ".cache", "image_cache", "audio_cache"]
    if any(d in path.parts for d in excluded_dirs):
        return True
    
    # File suffix exclusions
    excluded_suffixes = [".db", ".db-shm", ".db-wal"]
    if any(name.endswith(s) for s in excluded_suffixes):
        return True
    
    return False


def copy_profile_data(profile_name: str, dest_base: Path):
    """Copy profile data to the sync directory, excluding sensitive/cache files."""
    src = HERMES_HOME / profile_name
    if not src.exists():
        print(f"Profile '{profile_name}' not found")
        return False
    
    dest = dest_base / "profiles" / profile_name
    dest.mkdir(parents=True, exist_ok=True)
    
    copied_items = {"skills": 0, "memories": 0, "configs": 0, "cron": 0}
    
    for item in src.rglob("*"):
        if item.is_file():
            rel_path = item.relative_to(src)
            
            # Skip excluded patterns
            if should_exclude(item):
                continue
            
            dest_path = dest / rel_path
            dest_path.parent.mkdir(parents=True, exist_ok=True)
            
            # Handle config.yaml specially - redact sensitive values
            if item.name == "config.yaml" or item.suffix in [".yaml", ".yml"]:
                with open(item) as f:
                    config = yaml.safe_load(f) or {}
                clean_config = clean_dict(config)
                with open(dest_path, "w") as f:
                    yaml.dump(clean_config, f, default_flow_style=False)
                copied_items["configs"] += 1
            else:
                shutil.copy2(item, dest_path)
                
                # Count by type
                if "skills" in rel_path.parts:
                    copied_items["skills"] += 1
                elif "memories" in rel_path.parts:
                    copied_items["memories"] += 1
                elif "cron" in rel_path.parts:
                    copied_items["cron"] += 1
    
    return copied_items


def create_manifest(all_profiles: list, sync_base: Path):
    """Create a manifest of exported profiles for the sync directory."""
    manifest = {
        "description": "Hermes profile configurations for sharing",
        "version": "1.0",
        "profiles": {},
        "notes": [
            "API keys and auth tokens have been redacted",
            "Large cache files excluded for repository size",
            "Use hermes profile import to restore on another installation"
        ]
    }
    
    for profile in all_profiles:
        profile_dir = sync_base / "profiles" / profile
        if profile_dir.exists():
            config_file = profile_dir / "config.yaml"
            if config_file.exists():
                with open(config_file) as f:
                    config = yaml.safe_load(f) or {}
                manifest["profiles"][profile] = {
                    "model": config.get("model", {}).get("default", "unknown"),
                    "provider": config.get("model", {}).get("provider", "unknown"),
                }
    
    with open(sync_base / "profiles.manifest.json", "w") as f:
        json.dump(manifest, f, indent=2)
    
    return manifest


def main():
    parser = argparse.ArgumentParser(description="Export Hermes profiles for GitHub sync")
    parser.add_argument("--profiles", nargs="+", help="Specific profiles to export (default: all)")
    parser.add_argument("--all", action="store_true", help="Export all profiles")
    args = parser.parse_args()
    
    # Determine which profiles to export
    all_profile_names = [d.name for d in HERMES_HOME.iterdir() if d.is_dir()]
    
    if args.profiles:
        profiles_to_export = [p for p in args.profiles if p in all_profile_names]
    else:
        profiles_to_export = all_profile_names
    
    print(f"Exporting profiles: {profiles_to_export}")
    
    total_stats = {"skills": 0, "memories": 0, "configs": 0, "cron": 0}
    
    for profile in profiles_to_export:
        stats = copy_profile_data(profile, SYNC_DIR)
        if stats:
            for k, v in stats.items():
                total_stats[k] += v
    
    manifest = create_manifest(profiles_to_export, SYNC_DIR)
    
    print(f"\nSync complete!")
    print(f"  Skills: {total_stats['skills']}")
    print(f"  Memories: {total_stats['memories']}")
    print(f"  Configs: {total_stats['configs']}")
    print(f"  Cron entries: {total_stats['cron']}")


if __name__ == "__main__":
    main()