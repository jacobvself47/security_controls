# Security Controls

Centralized security controls, policies, and configurations for organizational repositories.

## Contents

| Directory | Description |
|-----------|-------------|
| `pre-commit/` | Shared pre-commit hooks for local development |
| `github-actions/` | Reusable CI/CD security workflows |
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

Copy the reusable workflows to your organization's shared workflows repository, then reference them:

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
    with:
      language: python  # python, javascript, go, java
```

**Available workflows:**

| Workflow | Tools | Purpose |
|----------|-------|---------|
| `secret-scanning.yml` | Gitleaks, TruffleHog | Detect exposed secrets |
| `sast-scan.yml` | Semgrep, CodeQL | Static analysis |

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

**sast-scan.yml:**
| Input | Default | Description |
|-------|---------|-------------|
| `language` | `python` | Primary language for CodeQL |

## Requirements

- Python 3.8+ (for pre-commit)
- Git 2.28+
- GitHub Actions (for CI workflows)

## Documentation

See [docs/SECURITY_STANDARDS.md](docs/SECURITY_STANDARDS.md) for full security requirements and policies.
