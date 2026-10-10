# Tasbih

A native macOS (SwiftUI) tasbih counter: SubhanAllah 33 · Alhamdulillah 33 · Allahu Akbar 34.

Features: auto-advancing counter, daily tracking, streaks, local JSON storage, onboarding, in-app help,
light/dark/system appearance, CSV/JSON export, daily notification, and a benefits section with sources.

## Requirements
macOS 13+, Xcode or Command Line Tools (Swift 5.9+).

## Install
```bash
./scripts/install.sh   # builds, copies to /Applications, adds Desktop shortcut
```
Or just build: `./scripts/build_app.sh` → `build/Tasbih.app`.
Dev run: `swift run` (notifications only work in the packaged .app).

## Adding benefits
Edit `Sources/Tasbih/BenefitsData.swift`. Only add entries whose wording, reference and grading you've verified (e.g. on sunnah.com).
