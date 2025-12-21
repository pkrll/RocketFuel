# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

RocketFuel is a macOS menu bar utility that prevents the system from sleeping. It uses IOKit power assertions to keep the display awake and provides timed activation with optional battery-aware deactivation.

## Build Commands

```bash
# Build from command line
xcodebuild -project RocketFuel.xcodeproj -scheme RocketFuel -configuration Debug build

# Build for release
xcodebuild -project RocketFuel.xcodeproj -scheme RocketFuel -configuration Release build

# Clean build
xcodebuild -project RocketFuel.xcodeproj -scheme RocketFuel clean
```

The project is typically built and run from Xcode. Open `RocketFuel.xcodeproj` in Xcode 26+ (macOS Tahoe).

## Architecture

### App Entry Point
- `RocketFuelApp.swift` - SwiftUI App using `MenuBarExtra` for the menu bar icon and `Settings` scene for preferences

### Core State
- `AppState.swift` - `@Observable` class marked `@MainActor` that manages all app state:
  - Activation state and timed durations
  - User preferences (persisted via UserDefaults)
  - Coordinates services (SleepManager, BatteryMonitor, HotKeyManager)
  - Preset durations: 15min, 30min, 1hr, 2hr (plus custom)

### Services (`Services/`)
- `SleepManager.swift` - Uses `IOPMAssertionCreateWithDescription` to prevent sleep
- `BatteryMonitor.swift` - Monitors power source via IOKit callbacks
- `HotKeyManager.swift` - Global hotkey registration using Carbon APIs
- `CrashReporter.swift` - Sentry integration (disabled in DEBUG)

### Views (`Views/`)
- `MenuCommands.swift` - Menu bar dropdown content + `CustomDurationView`
- `SettingsView.swift` - Settings window with battery options
- `KeyRecorderView.swift` - Custom hotkey capture using `NSViewRepresentable`

### AppleScript Support (`Scripting/`)
- `ScriptCommands.swift` - `RocketFuelScript` class + `RocketFuelScriptBridge` singleton
- `RocketFuel.sdef` - AppleScript dictionary defining: `toggle`, `duration`, `battery level`, `battery mode`

## Key Patterns

- State is passed via SwiftUI environment: `.environment(appState)`
- Services use closures/NotificationCenter to communicate with MainActor state
- Carbon APIs for global hotkeys (RegisterEventHotKey) with NotificationCenter bridging
- `@unchecked Sendable` on service classes that manage thread-unsafe resources

## Dependencies

- **Sentry** (SPM) - Crash reporting (release builds only)

## URL Schemes

- `rocketfuel://` (Release)
- `rocketfuel-debug://` (Debug)
