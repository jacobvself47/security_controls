# GitHub Actions Security Workflows

Reusable security workflows for GitHub Actions.

## Available Workflows

### secret-scanning.yml

Scans repositories for exposed secrets using Gitleaks and TruffleHog.

```yaml
jobs:
  secret-scan:
    uses: your-org/security-controls/.github/workflows/secret-scanning.yml@main
    secrets:
      GITLEAKS_LICENSE: ${{ secrets.GITLEAKS_LICENSE }}
```

### sast-scan.yml

Static Application Security Testing using Semgrep and CodeQL.

```yaml
jobs:
  sast:
    uses: your-org/security-controls/.github/workflows/sast-scan.yml@main
    with:
      language: python
```

## Setup

1. Copy workflows to `.github/workflows/` in your repository
2. Configure required secrets in repository settings
3. Trigger workflows on push/PR events

## Required Secrets

| Secret | Required | Description |
|--------|----------|-------------|
| GITLEAKS_LICENSE | No | Enterprise license for Gitleaks |
| SEMGREP_APP_TOKEN | No | Token for Semgrep App integration |
