#!/usr/bin/env bash

set -euo pipefail

banner() {
  echo "================================================================================"
  echo "[Chezmoi] $*"
}

banner "termux reload settings"
termux-reload-settings
