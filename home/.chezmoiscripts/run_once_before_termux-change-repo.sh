#!/usr/bin/env bash

set -euo pipefail

banner() {
  echo "================================================================================"
  echo "[Chezmoi] $*"
}

banner "termux change repo"
echo "deb https://mirror.sjtu.edu.cn/termux/termux-main/ stable main" > "$PREFIX/etc/apt/sources.list"
pkg update
pkg upgrade
