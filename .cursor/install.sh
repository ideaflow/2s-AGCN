#!/usr/bin/env bash
# Idempotent environment bootstrap for the 2s-AGCN project.
# Creates a Python virtual environment and installs pinned dependencies.
set -eo pipefail

# Move to the repository root (this script lives in <repo>/.cursor).
cd "$(dirname "$0")/.."

# The base image ships Python 3.12 but not the venv module, which is required
# to create isolated environments (Ubuntu marks the system Python as
# externally managed, so packages cannot be pip-installed globally).
if ! python3 -m venv --help >/dev/null 2>&1; then
  sudo apt-get update -qq
  sudo apt-get install -y -qq python3.12-venv
fi

# Create the virtual environment if it does not already exist.
if [ ! -d .venv ]; then
  python3 -m venv .venv
fi

# shellcheck disable=SC1091
. .venv/bin/activate

python -m pip install --upgrade pip
pip install -r requirements.txt

echo "2s-AGCN environment ready. Activate it with: source .venv/bin/activate"
