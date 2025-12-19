# Agents

RocketFuel is a macOS menu bar app that keeps your monitor on by preventing system sleep. It includes a simple Siri Shortcut for basic automation.

## App Intents

### Toggle Intent

A simple shortcut that toggles RocketFuel on/off.

**Location:** `RocketFuel/Intents/Toggle.swift`

#### Parameters

- `shouldStopOnBatteryMode` (Bool, optional) - Stop when switching to battery power
- `minimumBatteryLevel` (Int, optional) - Stop when battery falls below this percentage
- `duration` (TimeInterval, optional) - Auto-deactivate after specified minutes (5, 15, 30, 60, 120)

## Usage

### Siri

Say "Toggle RocketFuel" or "Keep my screen turned on"

### Shortcuts App

Add the "Toggle" action from RocketFuel to your shortcuts. Optionally configure battery protection or duration parameters.

## Implementation

- `Toggle.swift` - AppIntent implementation
- `ToggleShortcuts.swift` - Registers Siri phrases and Shortcuts integration
