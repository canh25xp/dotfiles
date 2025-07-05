#!/usr/bin/env bash

set -euo pipefail

LINUX_PATH="dot_config/nvim"
WINDOWS_PATH="AppData/Local/nvim"

# Get changed files
CHANGED=$(git status --porcelain | awk '{print $2}' | grep -E "^($LINUX_PATH|$WINDOWS_PATH)/" || true)

# Early exit if nothing is changed in either path
if [[ -z "$CHANGED" ]]; then
  echo "Nothing to sync."
  exit 0
fi

# Map to track edited files
declare -A linux_changes
declare -A win_changes

# Classify each changed file
for file in $CHANGED; do
  if [[ "$file" == "$LINUX_PATH/"* ]]; then
    relative="${file#$LINUX_PATH/}"
    linux_changes["$relative"]=1
  elif [[ "$file" == "$WINDOWS_PATH/"* ]]; then
    relative="${file#$WINDOWS_PATH/}"
    win_changes["$relative"]=1
  fi
done

# Iterate over all unique relative paths
all_keys=$(printf "%s\n%s\n" "${!linux_changes[@]}" "${!win_changes[@]}" | sort -u)

for relative in $all_keys; do
  from=""
  to=""

  if [[ -n "${linux_changes[$relative]:-}" && -n "${win_changes[$relative]:-}" ]]; then
    echo "⚠️ Conflict on '$relative' — changed in both, skipping"
    continue
  elif [[ -n "${linux_changes[$relative]:-}" ]]; then
    from="$LINUX_PATH/$relative"
    to="$WINDOWS_PATH/$relative"
  elif [[ -n "${win_changes[$relative]:-}" ]]; then
    from="$WINDOWS_PATH/$relative"
    to="$LINUX_PATH/$relative"
  fi

  mkdir -p "$(dirname "$to")"
  cp -v "$from" "$to"
done

echo "✅ Sync complete."
