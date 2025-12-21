//
//  Copyright © 2025 Ardalan Samimi. All rights reserved.
//

import Foundation
import ServiceManagement
import SwiftUI

@Observable
@MainActor
final class AppState {
    // MARK: - Published State

    private(set) var isActive = false
    private(set) var activationDuration: Duration?

    // MARK: - Persisted Settings

    var launchAtLogin: Bool {
        get { SMAppService.mainApp.status == .enabled }
        set {
            do {
                if newValue {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Failed to \(newValue ? "enable" : "disable") launch at login: \(error)")
            }
        }
    }

    var leftClickActivation: Bool {
        didSet { UserDefaults.standard.set(leftClickActivation, forKey: Keys.leftClickActivation) }
    }

    var disableOnBattery: Bool {
        didSet { UserDefaults.standard.set(disableOnBattery, forKey: Keys.disableOnBattery) }
    }

    var batteryThreshold: Int {
        didSet { UserDefaults.standard.set(batteryThreshold, forKey: Keys.batteryThreshold) }
    }

    var hotKey: HotKey? {
        didSet { saveHotKey() }
    }

    // MARK: - Services

    private let sleepManager = SleepManager()
    private let batteryMonitor = BatteryMonitor()
    private let hotKeyManager = HotKeyManager()

    // MARK: - Initialization

    init() {
        leftClickActivation = UserDefaults.standard.bool(forKey: Keys.leftClickActivation)
        disableOnBattery = UserDefaults.standard.bool(forKey: Keys.disableOnBattery)
        batteryThreshold = UserDefaults.standard.integer(forKey: Keys.batteryThreshold)
        hotKey = loadHotKey()

        setupBatteryMonitoring()
        setupHotKeyHandler()

        if let hotKey {
            try? hotKeyManager.register(hotKey)
        }
    }

    // MARK: - Actions

    func toggle() {
        if isActive {
            deactivate()
        } else {
            activate()
        }
    }

    func activate(for duration: Duration? = nil) {
        activationDuration = duration

        let seconds: TimeInterval = if let duration {
            Double(duration.components.seconds)
        } else {
            0
        }

        sleepManager.enable(
            duration: seconds,
            shouldStopOnBatteryMode: disableOnBattery && !batteryMonitor.isOnBattery,
            minimumBatteryLevel: batteryThreshold
        )

        isActive = true

        if let duration {
            Task {
                try? await Task.sleep(for: duration)
                if isActive {
                    deactivate()
                }
            }
        }
    }

    func deactivate() {
        sleepManager.disable()
        isActive = false
        activationDuration = nil
    }

    func setHotKey(_ newHotKey: HotKey?) throws {
        if let oldHotKey = hotKey {
            try hotKeyManager.unregister(oldHotKey)
        }

        if let newHotKey {
            try hotKeyManager.register(newHotKey)
        }

        hotKey = newHotKey
    }

    // MARK: - Private

    private func setupBatteryMonitoring() {
        batteryMonitor.onChange = { [weak self] in
            guard let self, isActive else { return }

            let shouldDisable = (disableOnBattery && batteryMonitor.isOnBattery) ||
                                (batteryThreshold > 0 && batteryMonitor.currentCharge < batteryThreshold)

            if shouldDisable {
                deactivate()
            }
        }

        batteryMonitor.start()
    }

    private func setupHotKeyHandler() {
        // Listen for hotkey notifications from the Carbon event handler
        NotificationCenter.default.addObserver(
            forName: .hotKeyPressed,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self,
                  let id = notification.userInfo?["id"] as? Int
            else { return }

            Task { @MainActor in
                if self.hotKey?.id == id {
                    self.toggle()
                }
            }
        }
    }

    private func loadHotKey() -> HotKey? {
        guard let data = UserDefaults.standard.data(forKey: Keys.hotKey) else { return nil }
        return try? JSONDecoder().decode(HotKey.self, from: data)
    }

    private func saveHotKey() {
        if let hotKey, let data = try? JSONEncoder().encode(hotKey) {
            UserDefaults.standard.set(data, forKey: Keys.hotKey)
        } else {
            UserDefaults.standard.removeObject(forKey: Keys.hotKey)
        }
    }
}

// MARK: - Keys

extension AppState {
    private enum Keys {
        static let leftClickActivation = "leftClickActivation"
        static let disableOnBattery = "disableOnBatteryMode"
        static let batteryThreshold = "stopAtBatteryLevel"
        static let hotKey = "activationHotKey"
    }
}

// MARK: - Durations

extension AppState {
    static let availableDurations: [Duration?] = [
        .seconds(5 * 60),
        .seconds(15 * 60),
        .seconds(30 * 60),
        .seconds(60 * 60),
        .seconds(2 * 60 * 60),
        nil
    ]
}
