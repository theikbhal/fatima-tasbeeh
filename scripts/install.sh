#!/bin/bash
# Builds, moves the app to /Applications and puts an alias on the Desktop.
set -euo pipefail
cd "$(dirname "$0")/.."
./scripts/build_app.sh
rm -rf /Applications/Tasbih.app
cp -R build/Tasbih.app /Applications/Tasbih.app
rm -f "$HOME/Desktop/Tasbih"
osascript -e 'tell application "Finder" to make new alias file to POSIX file "/Applications/Tasbih.app" at desktop' >/dev/null
echo "Installed to /Applications and added a Desktop shortcut."
open /Applications/Tasbih.app
