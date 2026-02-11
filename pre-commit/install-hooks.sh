#!/usr/bin/env bash
#
# Install pre-commit hooks in a repository
# Usage: ./install-hooks.sh [target-repo-path]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_REPO="${1:-.}"

echo "Installing pre-commit hooks in: $TARGET_REPO"

# Check if pre-commit is installed
if ! command -v pre-commit &> /dev/null; then
    echo "Error: pre-commit is not installed."
    echo "Install with: pip install pre-commit"
    exit 1
fi

# Check if target is a git repository
if [ ! -d "$TARGET_REPO/.git" ]; then
    echo "Error: $TARGET_REPO is not a git repository"
    exit 1
fi

# Copy the config file
cp "$SCRIPT_DIR/.pre-commit-config.yaml" "$TARGET_REPO/.pre-commit-config.yaml"
echo "Copied .pre-commit-config.yaml"

# Install the hooks
cd "$TARGET_REPO"
pre-commit install
pre-commit install --hook-type commit-msg

echo "Pre-commit hooks installed successfully!"
echo "Run 'pre-commit run --all-files' to check existing files."
