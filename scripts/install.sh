#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
./scripts/build_app.sh
rm -rf /Applications/Tasbih.app "/Applications/Fatima Tasbeeh.app"
cp -R "build/Fatima Tasbeeh.app" "/Applications/Fatima Tasbeeh.app"
rm -f "$HOME/Desktop/Tasbih" "$HOME/Desktop/Fatima Tasbeeh"
osascript -e 'tell application "Finder" to make new alias file to POSIX file "/Applications/Fatima Tasbeeh.app" at desktop' >/dev/null
open "/Applications/Fatima Tasbeeh.app"
