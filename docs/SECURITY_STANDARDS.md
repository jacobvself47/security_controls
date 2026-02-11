# Security Standards

This document outlines the security standards and controls for our organization.

## Overview

All repositories and cloud resources must adhere to these baseline security requirements.

## Source Code Security

### Pre-commit Hooks

All repositories must install the shared pre-commit hooks:

```bash
./pre-commit/install-hooks.sh /path/to/repo
```

Required checks:
- Secret detection (Gitleaks)
- Security linting (Bandit for Python, ESLint security plugin for JS)
- Infrastructure scanning (tfsec for Terraform)

### CI/CD Pipeline Security

All pipelines must include:
- [ ] Secret scanning on every push
- [ ] SAST scanning on pull requests
- [ ] Dependency vulnerability scanning
- [ ] Container image scanning (if applicable)

## Cloud Resource Security

### Azure

- Storage accounts must enforce HTTPS and TLS 1.2
- SQL servers must disable public network access
- All resources must be tagged with owner and cost-center

### AWS

- S3 buckets must block public access by default
- RDS instances must use encryption at rest
- Security groups must not allow 0.0.0.0/0 on sensitive ports

## Secrets Management

- Never commit secrets to source control
- Use environment-specific secret stores (Azure Key Vault, AWS Secrets Manager)
- Rotate secrets every 90 days
- Use service principals/IAM roles instead of long-lived credentials

## Incident Response

Report security incidents to: security@example.com

Severity levels:
- **Critical**: Active breach, data exfiltration
- **High**: Exposed secrets, vulnerable production system
- **Medium**: Vulnerable non-production system, policy violation
- **Low**: Informational findings, best practice recommendations
