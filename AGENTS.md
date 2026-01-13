# Repository Guidelines

## Project Structure & Module Organization
Templated dotfiles live under `dot_*` and render to their destination names. Shared configs sit in `dot_config/` (notably `dot_config/nvim`, `dot_config/tmux`), Windows overrides in `AppData/` and `Documents/`, and Linux extras in `dot_local/`. Neovim code lives in `nvim/`, with Lua modules in `nvim/lua/config` and helpers in `nvim/lua/common`. Automation scripts are in `.chezmoiscripts/`; assets and references stay in `Pictures/` and `Keybindings.md`.

## Build, Test, and Development Commands
- `chezmoi status` – inspect which workstation files diverge before editing.
- `chezmoi diff` – review rendered changes; pass `--destination` to inspect the target path.
- `chezmoi apply --dry-run` – validate rendering without modifying live files; drop `--dry-run` to apply.
- `./scripts/sync.sh` – mirror Neovim configs between `dot_config/nvim` and `AppData/Local/nvim`.
- `bash ./scripts/install-cargo.sh` or `pwsh -NoProfile -File scripts/powershell_es_install.ps1` – reuse installers rather than duplicating setup logic.

## Coding Style & Naming Conventions
Follow chezmoi conventions: prefix tracked files with `dot_`, store secrets in `private_*`, and use `.tmpl` when a template reads environment variables or encrypted data. Bash scripts keep the `#!/usr/bin/env bash` shebang, enable `set -euo pipefail`, and use two-space indentation as in `scripts/sync.sh`. Lua modules in `nvim/` do the same, return tables from plugin specs in `nvim/lua/plugins`, and locate shared helpers in `nvim/lua/common`. PowerShell scripts under `Documents/` or `scripts/` should stick to approved verbs and PascalCase functions.

## Testing Guidelines
Run `chezmoi diff` and `chezmoi apply --dry-run` on the target host to confirm templates resolve with local secrets. After dependency updates, run `chezmoi doctor` to surface missing tools. Lint Bash scripts with `shellcheck scripts/<file>.sh` when possible, review PowerShell code before `pwsh -NoProfile -File <script>.ps1`, and launch `nvim --headless "+Lazy! sync" +qa` to ensure Lua changes load.

## Commit & Pull Request Guidelines
Recent history favors `scope: summary` subjects (for example `pwsh: add Alias howto`); keep the scope lowercase, 1–2 words, and write imperative summaries under 60 characters. Group related edits per commit, note rendered results or target OSes in the body, and use PR descriptions to list verification commands. Attach screenshots for UI changes, link GitHub issues when applicable, and flag secret-handling updates for review.

## Security & Secrets Handling
Never commit plain-text secrets: keep sensitive files under `private_*` and encrypt with `chezmoi age`, as demonstrated by `.key.txt.age`. Templates such as `dot_env.tmpl` should reference secrets through `{{ env "VAR" }}` lookups. When adding new private assets, document the provisioning step and confirm `.gitignore` covers transient outputs.
