#!/bin/bash
# Converts Resources/AppIcon-1024.png into build/AppIcon.icns
set -euo pipefail
cd "$(dirname "$0")/.."
SRC=Resources/AppIcon-1024.png
SET=build/AppIcon.iconset
rm -rf "$SET"; mkdir -p "$SET"
for s in 16 32 128 256 512; do
  sips -z $s $s "$SRC" --out "$SET/icon_${s}x${s}.png" >/dev/null
  sips -z $((s*2)) $((s*2)) "$SRC" --out "$SET/icon_${s}x${s}@2x.png" >/dev/null
done
iconutil -c icns "$SET" -o build/AppIcon.icns
rm -rf "$SET"
echo "Made build/AppIcon.icns"
