# Security Controls

Centralized security controls, policies, and configurations for organizational repositories.

## Contents

| Directory | Description |
|-----------|-------------|
| `pre-commit/` | Shared pre-commit hooks for local development |
| `.github/workflows/` | Reusable CI/CD security workflows |
| `claude-config/` | Claude Code hooks and permission policies |
| `policies/` | Approved actions and resource policies |
| `docs/` | Security standards and documentation |

## Quick Start

### 1. Install Pre-commit Hooks

Add security scanning to any repository before code is committed:

```bash
# Prerequisites
pip install pre-commit

# Install hooks in your target repository
./pre-commit/install-hooks.sh /path/to/your/repo

# Or manually copy and install
cp pre-commit/.pre-commit-config.yaml /path/to/your/repo/
cd /path/to/your/repo
pre-commit install
```

**Included hooks:**
- **Gitleaks** - Detects secrets and credentials
- **Bandit** - Python security linter
- **tfsec** - Terraform security scanner
- **General** - Large files, merge conflicts, private keys, YAML validation

### 2. Add GitHub Actions Workflows

Reference the reusable workflows from this repository in your CI/CD pipelines:

```yaml
# .github/workflows/security.yml
name: Security Scans

on:
  push:
    branches: [main]
  pull_request:

jobs:
  secrets:
    uses: your-org/security-controls/.github/workflows/secret-scanning.yml@main

  sast:
    uses: your-org/security-controls/.github/workflows/sast-scan.yml@main
```

**Available workflows:**

| Workflow | Tools | Purpose |
|----------|-------|---------|
| `secret-scanning.yml` | Gitleaks, TruffleHog | Detect exposed secrets |
| `sast-scan.yml` | Semgrep | Static analysis |

### 3. Enforce Allowed Actions

Use `policies/allowed-actions.txt` to restrict which GitHub Actions can run in your organization:

1. Go to **Organization Settings > Actions > General**
2. Select "Allow select actions and reusable workflows"
3. Add the actions from `allowed-actions.txt`

Or use the GitHub API:

```bash
gh api orgs/YOUR_ORG/actions/permissions/selected-actions \
  -X PUT \
  -f patterns_allowed="$(cat policies/allowed-actions.txt | grep -v '^#' | tr '\n' ',')"
```

### 4. Configure Claude Code Safety Controls

Claude Code hooks and permissions prevent accidental destructive actions and provide automatic repository backups.

#### What's Included

**Hooks:**
- **SessionStart backup** - Automatically backs up your repository when Claude starts a session, keeping the last 10 backups in `~/.claude-backups/`

**Permissions:**

| Tool | Auto-allowed | Requires Confirmation | Blocked |
|------|--------------|----------------------|---------|
| kubectl | get, describe, logs | delete, scale, apply | drain |
| docker | ps, images, build | rm, stop, prune | system prune -a |
| terraform | init, plan, validate | apply, destroy, import | force-unlock |
| helm | list, status, template | install, upgrade, uninstall | - |
| az | list, show | delete, stop, deallocate | account set |
| git | - | push --force, reset --hard | - |

#### Installation

**Option A: Per-project (recommended)**

```bash
# Navigate to your target repository
cd /path/to/your/repo

# Create .claude directory structure
mkdir -p .claude/hooks

# Copy configuration files
cp /path/to/security-controls/claude-config/settings.json .claude/
cp /path/to/security-controls/claude-config/hooks/backup-repo.sh .claude/hooks/
chmod +x .claude/hooks/backup-repo.sh

# Add .claude/settings.local.json to .gitignore (for personal overrides)
echo ".claude/settings.local.json" >> .gitignore
```

**Option B: Global (applies to all projects)**

```bash
# Copy to user-level Claude config
mkdir -p ~/.claude/hooks
cp claude-config/settings.json ~/.claude/settings.json
cp claude-config/hooks/backup-repo.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/backup-repo.sh
```

Then update the hook path in `~/.claude/settings.json`:
```json
"command": "~/.claude/hooks/backup-repo.sh"
```

#### Customization

Override backup settings with environment variables:

```bash
export CLAUDE_BACKUP_DIR="$HOME/my-backups"  # Custom backup location
export CLAUDE_MAX_BACKUPS=20                  # Keep more backups
```

Add project-specific permission overrides in `.claude/settings.local.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(terraform apply -auto-approve *)"
    ]
  }
}
```

#### Restoring from Backup

```bash
# List available backups
ls -la ~/.claude-backups/

# Restore a specific backup
cd /path/to/parent/directory
rm -rf project-name
tar -xzf ~/.claude-backups/project-name_20240115_143022.tar.gz
```

See [claude-config/README.md](claude-config/README.md) for full documentation.

## Configuration

### Pre-commit Customization

To customize hooks for a specific repository, copy `.pre-commit-config.yaml` and modify as needed:

```yaml
# Disable a hook
- repo: https://github.com/PyCQA/bandit
  rev: 1.7.7
  hooks:
    - id: bandit
      exclude: ^tests/  # Skip test files
```

### Workflow Inputs

**secret-scanning.yml:**
| Input | Default | Description |
|-------|---------|-------------|
| `scan-path` | `.` | Path to scan |

## Requirements

- Python 3.8+ (for pre-commit)
- Git 2.28+
- GitHub Actions (for CI workflows)
- Claude Code CLI (for hooks and permissions)

## Documentation

See [docs/SECURITY_STANDARDS.md](docs/SECURITY_STANDARDS.md) for full security requirements and policies.
