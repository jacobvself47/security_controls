# Claude Code Configuration

Security-focused hooks and permissions for Claude Code.

## Features

- **Automatic backups** - Repository backed up on every session start
- **Command restrictions** - Dangerous commands require approval or are blocked

## Installation

### 1. Copy configuration to your project

```bash
# Create .claude directory in your project
mkdir -p /path/to/your/repo/.claude/hooks

# Copy settings
cp settings.json /path/to/your/repo/.claude/settings.json

# Copy and enable backup hook
cp hooks/backup-repo.sh /path/to/your/repo/.claude/hooks/
chmod +x /path/to/your/repo/.claude/hooks/backup-repo.sh
```

### 2. Or install globally

```bash
# Copy to user settings (applies to all projects)
cp settings.json ~/.claude/settings.json

# Create global hooks directory
mkdir -p ~/.claude/hooks
cp hooks/backup-repo.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/backup-repo.sh
```

For global hooks, update the command path in settings.json:
```json
"command": "~/.claude/hooks/backup-repo.sh"
```

## Configuration

### Backup Settings

Environment variables to customize backup behavior:

| Variable | Default | Description |
|----------|---------|-------------|
| `CLAUDE_BACKUP_DIR` | `~/.claude-backups` | Where backups are stored |
| `CLAUDE_MAX_BACKUPS` | `10` | Number of backups to retain |

### Permission Levels

| Level | Behavior | Examples |
|-------|----------|----------|
| `allow` | Runs without prompting | `kubectl get`, `docker ps`, `terraform plan` |
| `ask` | Requires confirmation | `kubectl delete`, `docker rm`, `terraform apply` |
| `deny` | Blocked entirely | `kubectl drain`, `docker system prune -a` |

## Restoring from Backup

```bash
# List available backups
ls -la ~/.claude-backups/

# Restore a backup
cd /path/to/parent/directory
tar -xzf ~/.claude-backups/project_20240115_143022.tar.gz
```

## Customization

Edit `settings.json` to adjust permissions for your workflow:

```json
{
  "permissions": {
    "allow": [
      "Bash(your-safe-command *)"
    ],
    "ask": [
      "Bash(your-risky-command *)"
    ]
  }
}
```

## Covered Tools

| Tool | Safe (allow) | Risky (ask) | Blocked (deny) |
|------|--------------|-------------|----------------|
| kubectl | get, describe, logs | delete, scale, apply | drain |
| docker | ps, images, build | rm, stop, prune | system prune -a |
| terraform | init, plan, validate | apply, destroy, import | force-unlock |
| helm | list, status, template | install, upgrade, uninstall | - |
| az | list, show | delete, stop, deallocate | account set |
| git | - | push --force, reset --hard | - |
