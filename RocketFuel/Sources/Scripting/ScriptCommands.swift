//
//  Copyright © 2025 Ardalan Samimi. All rights reserved.
//

import Cocoa

// MARK: - AppleScript Application

/// The main AppleScript class that handles all script commands.
/// Referenced in RocketFuel.sdef as the cocoa class for the application.
@objc(RocketFuelScript)
final class RocketFuelScript: NSScriptCommand {

    /// Returns whether RocketFuel is currently active
    @objc var active: Bool {
        // Access the shared app state
        // Note: This requires the app state to be accessible globally
        return RocketFuelScriptBridge.shared.isActive
    }

    override func performDefaultImplementation() -> Any? {
        let commandName = commandDescription.commandName
            .components(separatedBy: " ")
            .map(\.capitalized)
            .joined()

        switch commandName {
        case "Toggle":
            RocketFuelScriptBridge.shared.toggle()
        case "Duration":
            let minutes = (directParameter as? NSNumber)?.doubleValue ?? 1
            RocketFuelScriptBridge.shared.activate(forMinutes: minutes)
        case "BatteryLevel":
            let level = (directParameter as? NSNumber)?.intValue ?? 0
            RocketFuelScriptBridge.shared.setBatteryLevel(level)
        case "BatteryMode":
            let enabled = (directParameter as? NSNumber)?.boolValue ?? false
            RocketFuelScriptBridge.shared.setBatteryMode(enabled)
        default:
            return false
        }

        return true
    }
}

// MARK: - Script Bridge

/// Bridge between AppleScript commands and the app's state.
/// This is necessary because AppleScript commands run on a separate thread
/// and need to communicate with the MainActor-isolated AppState.
@MainActor
final class RocketFuelScriptBridge {
    static let shared = RocketFuelScriptBridge()

    private weak var appState: AppState?

    private init() {}

    func configure(with appState: AppState) {
        self.appState = appState
    }

    var isActive: Bool {
        appState?.isActive ?? false
    }

    func toggle() {
        appState?.toggle()
    }

    func activate(forMinutes minutes: Double) {
        let duration = Duration.seconds(minutes * 60)
        appState?.activate(for: duration)
    }

    func setBatteryLevel(_ level: Int) {
        appState?.batteryThreshold = level
    }

    func setBatteryMode(_ enabled: Bool) {
        appState?.disableOnBattery = enabled
    }
}
