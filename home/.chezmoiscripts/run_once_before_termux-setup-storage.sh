#!/usr/bin/env bash

set -euo pipefail

banner() {
  echo "================================================================================"
  echo "[Chezmoi] $*"
}

banner "termux setup storage"
termux-setup-storage
