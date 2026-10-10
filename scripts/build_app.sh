#!/bin/bash
# Builds build/Fatima Tasbeeh.app from the Swift package.
set -euo pipefail
cd "$(dirname "$0")/.."
swift build -c release
./scripts/make_icon.sh
APP="build/Fatima Tasbeeh.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp .build/release/Tasbih "$APP/Contents/MacOS/Tasbih"
cp build/AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"
cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>CFBundleName</key><string>Fatima Tasbeeh</string>
  <key>CFBundleDisplayName</key><string>Fatima Tasbeeh</string>
  <key>CFBundleIdentifier</key><string>com.fatima.tasbih</string>
  <key>CFBundleExecutable</key><string>Tasbih</string>
  <key>CFBundleIconFile</key><string>AppIcon</string>
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
