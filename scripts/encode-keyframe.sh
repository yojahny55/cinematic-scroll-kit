#!/usr/bin/env bash
# Encode all MP4s in SRC to DEST with all-keyframe H.264.
# Result: video.currentTime = X seeks frame-perfectly. Required for scroll-scrub.
#
# Usage: ./encode-keyframe.sh <src-dir> <dest-dir>
# Example: ./encode-keyframe.sh videos/_orig videos

set -euo pipefail

SRC="${1:-}"
DEST="${2:-}"
if [[ -z "$SRC" || -z "$DEST" ]]; then
  echo "Usage: $0 <src-dir> <dest-dir>"
  exit 1
fi

mkdir -p "$DEST"

shopt -s nullglob
for f in "$SRC"/*.mp4; do
  name="$(basename "$f")"
  echo "→ $name"
  ffmpeg -y -i "$f" \
    -an \
    -c:v libx264 -preset slow -crf 20 \
    -g 1 -keyint_min 1 -sc_threshold 0 \
    -x264-params "rc-lookahead=0:ref=1:bframes=0" \
    -pix_fmt yuv420p \
    -movflags +faststart \
    "$DEST/$name" \
    -loglevel error -stats
  size=$(stat -c%s "$DEST/$name" 2>/dev/null || stat -f%z "$DEST/$name")
  printf "  ✓ %s (%.1fM)\n" "$name" "$(echo "$size/1048576" | bc -l)"
done

echo "Done. $(ls "$DEST"/*.mp4 | wc -l) files in $DEST."
