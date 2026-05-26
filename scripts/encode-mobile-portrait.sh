#!/usr/bin/env bash
# Re-encode 16:9 MP4s to 9:16 portrait (720x1280, center-cropped) for mobile autoplay-loop.
#
# Usage: ./encode-mobile-portrait.sh <src-dir> <dest-dir>
# Example: ./encode-mobile-portrait.sh videos/_orig videos/mobile

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
  echo "→ $name (→ 720x1280 portrait)"
  ffmpeg -y -i "$f" \
    -an \
    -vf "scale=-2:1280:flags=lanczos,crop=720:1280:(iw-720)/2:0" \
    -c:v libx264 -preset slow -crf 24 \
    -g 24 -keyint_min 24 \
    -pix_fmt yuv420p \
    -movflags +faststart \
    "$DEST/$name" \
    -loglevel error -stats
  size=$(stat -c%s "$DEST/$name" 2>/dev/null || stat -f%z "$DEST/$name")
  printf "  ✓ %s (%.1fM)\n" "$name" "$(echo "$size/1048576" | bc -l)"
done

echo "Done. $(ls "$DEST"/*.mp4 | wc -l) files in $DEST."
