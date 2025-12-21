# RocketFuel 2.0 - Modernization Plan

## Overview

Rewrite RocketFuel from the ground up using modern Swift 6 and SwiftUI patterns while keeping all existing functionality.

**Target:** macOS 26+
**Swift:** 6.0 with strict concurrency
**Architecture:** Single target, no SPM packages

## Features to Keep

- [x] Keep screen awake (IOKit power assertions)
- [x] Menu bar icon with status indication
- [x] Global hotkey support
- [x] Deactivate after X minutes
- [x] Battery-based auto-disable
- [x] Launch at login
- [x] AppleScript support
- [x] Sentry crash reporting
- [ ] ~~Mixpanel analytics~~ (removed)

## Project Structure

```
RocketFuel/
├── RocketFuelApp.swift              # @main entry point with MenuBarExtra
├── AppState.swift                   # @Observable app state
│
├── Services/
│   ├── SleepManager.swift           # IOKit power assertions + timer
│   ├── BatteryMonitor.swift         # Power source monitoring
│   ├── HotKeyManager.swift          # Carbon global hotkeys
│   └── CrashReporter.swift          # Sentry integration
│
├── Views/
│   ├── MenuCommands.swift           # Menu content
│   ├── SettingsView.swift           # Settings window
│   └── KeyRecorderView.swift        # Hotkey recording UI
│
├── Scripting/
│   ├── RocketFuel.sdef              # AppleScript dictionary
│   └── ScriptCommands.swift         # NSScriptCommand subclasses
│
└── Resources/
    ├── Assets.xcassets              # App icon + menu bar icons
    ├── Info.plist
    ├── RocketFuel.entitlements
    └── Localizable.xcstrings        # Localization
```

## Implementation Steps

### Phase 1: Project Setup

1. **Create new Xcode project**
   - macOS App, SwiftUI, Swift 6
   - Bundle ID: `com.ardalansamimi.RocketFuel`
   - Deployment target: macOS 26.0
   - Enable strict concurrency checking

2. **Configure project settings**
   - Add Sentry package dependency
   - Configure entitlements (App Sandbox, network access for Sentry)
   - Set up asset catalog with menu bar icons

### Phase 2: Core State Management

3. **Create AppState.swift**
   ```swift
   @Observable
   final class AppState {
       // Persisted settings
       var isActive: Bool = false
       var launchAtLogin: Bool = false
       var deactivateAfter: Duration? = nil
       var disableOnBattery: Bool = false
       var batteryThreshold: Int = 20
       var hotKey: HotKey? = nil

       // Use @AppStorage for persistence
   }
   ```

### Phase 3: Services

4. **Create SleepManager.swift**
   - IOKit power assertion (`kIOPMAssertPreventUserIdleDisplaySleep`)
   - Timer-based auto-deactivation
   - Async API with Swift concurrency

5. **Create BatteryMonitor.swift**
   - Monitor power source changes via IOKit
   - AsyncSequence for battery state changes
   - Check battery level thresholds

6. **Create HotKeyManager.swift**
   - Carbon `InstallEventHandler` for global hotkeys
   - Register/unregister hotkeys
   - Callback via Swift concurrency

7. **Create CrashReporter.swift**
   - Sentry SDK initialization
   - Simple wrapper for configuration

### Phase 4: User Interface

8. **Create RocketFuelApp.swift**
   ```swift
   @main
   struct RocketFuelApp: App {
       @State private var appState = AppState()

       var body: some Scene {
           MenuBarExtra {
               MenuCommands()
                   .environment(appState)
           } label: {
               Image(systemName: appState.isActive ? "bolt.fill" : "bolt")
           }
           .menuBarExtraStyle(.menu)

           Settings {
               SettingsView()
                   .environment(appState)
           }
       }
   }
   ```

9. **Create MenuCommands.swift**
   - Activate/Deactivate toggle
   - "Deactivate After" submenu (5m, 15m, 30m, 1h, 2h, Never)
   - Launch at Login toggle
   - Settings menu item
   - Quit menu item

10. **Create SettingsView.swift**
    - General tab: Battery settings, hotkey recorder
    - Clean SwiftUI Form layout

11. **Create KeyRecorderView.swift**
    - Record global hotkey
    - Display current hotkey
    - Clear button

### Phase 5: AppleScript Support

12. **Create AppleScript interface**
    - Copy and update `RocketFuel.sdef`
    - Create `ScriptCommands.swift` with:
      - `ToggleCommand`
      - `DurationCommand`
      - `BatteryLevelCommand`
      - `BatteryModeCommand`
    - Add `NSAppleScriptEnabled` to Info.plist

### Phase 6: Integration & Polish

13. **Wire up all components**
    - Connect SleepManager to AppState
    - Connect BatteryMonitor to SleepManager
    - Connect HotKeyManager to toggle action
    - Initialize Sentry on app launch

14. **Launch at Login**
    - Use `SMAppService.mainApp` (one-liner, no helper app needed)
    ```swift
    try SMAppService.mainApp.register()
    ```

15. **Testing & refinement**
    - Test all features
    - Verify AppleScript commands
    - Test battery monitoring
    - Test global hotkeys

### Phase 7: Migration & Cleanup

16. **Migrate assets**
    - Copy app icon from old project
    - Copy menu bar icons (active/inactive states)
    - Copy localizations

17. **Remove old code**
    - Delete old SPM packages
    - Delete Launcher target
    - Clean up project structure

## Key Simplifications

| Before (Current) | After (Modernized) |
|------------------|-------------------|
| 8 SPM packages | Single target with folders |
| 55 Swift files | ~10-12 Swift files |
| NSApplicationDelegate | Native SwiftUI lifecycle |
| Custom MenuBarExtra wrapper | SwiftUI MenuBarExtra |
| Actor + Combine publishers | @Observable |
| Launcher helper app | SMAppService.mainApp |
| ~2,500 lines of code | ~500-700 lines of code |

## Dependencies

| Dependency | Version | Purpose |
|------------|---------|---------|
| Sentry | Latest | Crash reporting |

## File-by-File Implementation Order

1. `RocketFuelApp.swift` - Basic app shell with MenuBarExtra
2. `AppState.swift` - Observable state with @AppStorage
3. `SleepManager.swift` - Core functionality
4. `MenuCommands.swift` - Menu UI
5. `BatteryMonitor.swift` - Battery detection
6. `HotKeyManager.swift` - Global hotkeys
7. `SettingsView.swift` - Settings UI
8. `KeyRecorderView.swift` - Hotkey recorder
9. `ScriptCommands.swift` - AppleScript support
10. `CrashReporter.swift` - Sentry integration

## Notes

- The app will be significantly simpler and more maintainable
- All features preserved from the original
- Modern Swift 6 patterns throughout
- No backwards compatibility concerns (macOS 26+ only)
