#!/usr/bin/env bash
# Take AI-generated clips with arbitrary names (from Kling, Runway, Sora etc.)
# and rename them into sequential 01.mp4 ... 0N.mp4 in DEST.
#
# Usage: ./stage-sources.sh <src-dir> <dest-dir>
# - <src-dir>: folder containing your generated clips (sorted by filename = scene order)
# - <dest-dir>: where the renamed sequential files go

set -euo pipefail

SRC="${1:-}"
DEST="${2:-}"
if [[ -z "$SRC" || -z "$DEST" ]]; then
  echo "Usage: $0 <src-dir> <dest-dir>"
  echo "Tip: source files should be alphabetically sortable in scene order."
  exit 1
fi

mkdir -p "$DEST"

i=1
shopt -s nullglob
for f in $(ls "$SRC"/*.mp4 | sort); do
  num=$(printf "%02d" "$i")
  cp -n "$f" "$DEST/$num.mp4"
  echo "  $f → $DEST/$num.mp4"
  i=$((i+1))
done

echo "Staged $((i-1)) clips to $DEST."
