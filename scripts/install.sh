#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
./scripts/build_app.sh
rm -rf /Applications/Tasbih.app "/Applications/Fatima Tasbih.app"
cp -R "build/Fatima Tasbih.app" "/Applications/Fatima Tasbih.app"
rm -f "$HOME/Desktop/Tasbih" "$HOME/Desktop/Fatima Tasbih"
osascript -e 'tell application "Finder" to make new alias file to POSIX file "/Applications/Fatima Tasbih.app" at desktop' >/dev/null
open "/Applications/Fatima Tasbih.app"
