# Repository Guidelines

## Overview

This repository contains personal dotfiles managed with chezmoi.
The configuration targets primarily the environment:

- Debian
- Debian on Windows (WSL)
- Windows
- Termux

The repository is designed for a single user and a small set of machines, not for general distribution.
Agents modifying this repository should prioritize stability and reproducibility over generality.

## Project Structure & Module Organization

- home/ # Files deployed into the user's $HOME via chezmoi
- docs/ # Short, system-specific documentation
- misc/ # Data files, package lists, and references
- assets/ # Images used in documentation

## Test and apply changes

- `chezmoi status` - inspect which files will be change.
- `chezmoi diff` - review changes
- `chezmoi apply` - apply changes.

## Coding Style & Naming Conventions

Follow chezmoi conventions: prefix tracked files with `dot_`, store secrets in `private_*`, and use `.tmpl` when a template reads environment variables or encrypted data.
Bash scripts keep the `#!/usr/bin/env bash` shebang, enable `set -euo pipefail`, and use two-space indentation as in `scripts/sync.sh`.
PowerShell scripts should stick to approved verbs and PascalCase functions.

## Commit Guidelines

Recent history favors `scope: summary` subjects (for example `pwsh: add Alias howto`); keep the scope lowercase, 1–2 words, and write imperative summaries under 60 characters.

## Documenting

When writing documents in the `docs/` folder, keep the instruction short, simple and system specific since the docs are not meant to be use widely, only current user (me) and current machine (Debian).
Prefer copy-paste-able commands.
