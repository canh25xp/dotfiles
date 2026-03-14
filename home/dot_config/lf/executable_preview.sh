#!/bin/sh

set -eu

file_path="${1:-}"
preview_width="${2:-80}"
preview_height="${3:-24}"

[ -n "${file_path}" ] || exit 1

if ! command -v file >/dev/null 2>&1; then
  exit 0
fi

mime_type=$(file --mime-type -Lb "$file_path")

case "$mime_type" in
image/*)
  if command -v chafa >/dev/null 2>&1; then
    chafa --polite on --colors=256 --size "${preview_width}x${preview_height}" "$file_path"
    exit 0
  fi
  ;;
esac

if command -v bat >/dev/null 2>&1; then
  bat --color=always --style=plain --paging=never "$file_path"
else
  head -n "${preview_height}" "$file_path"
fi
