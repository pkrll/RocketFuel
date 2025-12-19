# Agents

RocketFuel provides automation capabilities through Apple's App Intents framework, enabling voice commands via Siri, integration with the Shortcuts app, and AppleScript support.

## Available Intents

### Toggle Intent

The primary automation agent for RocketFuel is the `Toggle` intent, which allows you to activate or deactivate sleep prevention functionality programmatically.

**Location:** `RocketFuel/Intents/Toggle.swift`

#### Parameters

- **`shouldStopOnBatteryMode`** (Bool, optional)
  - Automatically stop sleep prevention when the device switches to battery power
  - Useful for preserving battery life on laptops
  - Default: `nil` (user's configured setting applies)

- **`minimumBatteryLevel`** (Int, optional)
  - Automatically stop sleep prevention when battery level falls below this percentage
  - Range: 0-100
  - Default: `nil` (user's configured setting applies)

- **`duration`** (TimeInterval, optional)
  - Auto-deactivate sleep prevention after the specified time in minutes
  - Supported values: 5, 15, 30, 60, 120, or nil for "never"
  - Default: `nil` (stays active until manually disabled)

## Usage

### Siri Voice Commands

RocketFuel registers the following voice command phrases:

- "Toggle RocketFuel"
- "Toggle [App Name]"
- "Keep my screen turned on"

Simply say any of these phrases to Siri to activate or deactivate sleep prevention.

### Shortcuts App

The Toggle intent can be added to Shortcuts workflows:

1. Open the Shortcuts app
2. Create a new shortcut or edit an existing one
3. Search for "RocketFuel" or "Toggle"
4. Add the action and configure parameters as needed

#### Example Shortcuts

**Simple Toggle:**
```
Toggle RocketFuel
```

**Toggle with Battery Protection:**
```
Toggle RocketFuel
  - Should Stop on Battery Mode: Yes
  - Minimum Battery Level: 20
```

**Toggle with 30-Minute Timer:**
```
Toggle RocketFuel
  - Duration: 30
```

**Work Session (2 hours, battery-aware):**
```
Toggle RocketFuel
  - Duration: 120
  - Should Stop on Battery Mode: Yes
  - Minimum Battery Level: 15
```

### AppleScript

RocketFuel supports AppleScript automation through the App Intents framework:

```applescript
tell application "RocketFuel"
    -- Toggle sleep prevention on/off
    activate
end tell
```

## Implementation Details

### Toggle Intent Class

The `Toggle` class conforms to `AppIntent` and implements the following:

**Properties:**
- `static var title: LocalizedStringResource` - Display name for the intent
- `static var description: IntentDescription` - Intent description for Shortcuts
- `static var openAppWhenRun: Bool` - Whether to open the app when executing

**Methods:**
- `perform() async throws -> some IntentResult & Sendable` - Main execution method

### Shortcuts Provider

The `ToggleShortcuts` class (`ToggleShortcuts.swift`) conforms to `AppShortcutsProvider` and manages:
- Registration of voice command phrases
- Integration with Siri
- Shortcuts app visibility

## Architecture

The App Intents system integrates with RocketFuel's core packages:

- **Core** - Main application logic and coordination
- **SleepControl** - Power management and sleep prevention
- **MenuBarExtras** - UI updates when intents execute
- **Analytics** - Tracking automation usage

When an intent executes:
1. The `perform()` method is called
2. Parameters are validated and applied
3. The SleepControl package activates/deactivates sleep prevention
4. UI is updated to reflect the new state
5. Analytics events are logged (if enabled)

## Best Practices

### Battery Management

When using automation on laptops, always consider battery protection:
- Set `shouldStopOnBatteryMode: true` for long-running sessions
- Use `minimumBatteryLevel: 20` as a safe threshold
- Combine both for maximum battery preservation

### Duration Limits

Avoid infinite sleep prevention in automated workflows:
- Use specific durations (30, 60, 120 minutes) for predictable behavior
- Prevents accidental overnight sleep prevention
- Ensures battery isn't depleted unexpectedly

### Integration with Other Automations

The Toggle intent works well with:
- **Focus Modes** - Activate RocketFuel when entering "Work" focus
- **Time-based Shortcuts** - Enable at specific times of day
- **App-triggered Shortcuts** - Activate when specific apps launch
- **Home Automation** - Integrate with HomeKit scenes

## Troubleshooting

### Intent Not Appearing in Shortcuts

- Ensure RocketFuel is installed and launched at least once
- Check that the app has proper permissions
- Restart the Shortcuts app

### Siri Not Recognizing Commands

- Verify Siri is enabled in System Settings
- Check that the app name matches registered phrases
- Try "Toggle RocketFuel" explicitly

### Parameters Not Applied

- Confirm parameter values are within valid ranges
- Check that the app has necessary system permissions
- Review Console.app for error messages

## Future Enhancements

Potential additions to the automation framework:

- **Query Intent** - Check current sleep prevention status
- **Schedule Intent** - Create recurring activation schedules
- **Profile Intent** - Save and apply named configuration profiles
- **Status Intent** - Query battery level and power source

## See Also

- [App Intents Documentation](https://developer.apple.com/documentation/appintents)
- [Shortcuts User Guide](https://support.apple.com/guide/shortcuts-mac)
- RocketFuel Settings - Configure default automation behavior
