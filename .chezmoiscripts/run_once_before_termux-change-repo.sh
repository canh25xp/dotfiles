#!/bin/sh

echo "================================================================================"
echo "[Chezmoi] termux change repo"
echo "deb https://mirror.sjtu.edu.cn/termux/termux-main/ stable main" > $PREFIX/etc/apt/sources.list
pkg update
pkg upgrade
