#!/bin/bash
# Builds build/Tasbih.app from the Swift package.
set -euo pipefail
cd "$(dirname "$0")/.."
swift build -c release
APP="build/Tasbih.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp .build/release/Tasbih "$APP/Contents/MacOS/Tasbih"
cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>CFBundleName</key><string>Tasbih</string>
  <key>CFBundleDisplayName</key><string>Tasbih</string>
  <key>CFBundleIdentifier</key><string>com.tasbih.app</string>
  <key>CFBundleExecutable</key><string>Tasbih</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>1.0</string>
  <key>CFBundleVersion</key><string>1</string>
  <key>LSMinimumSystemVersion</key><string>13.0</string>
  <key>NSHighResolutionCapable</key><true/>
  <key>NSPrincipalClass</key><string>NSApplication</string>
  <key>LSApplicationCategoryType</key><string>public.app-category.lifestyle</string>
</dict></plist>
PLIST
codesign --force --deep -s - "$APP"
echo "Built $APP"
