//
//  Copyright © 2025 Ardalan Samimi. All rights reserved.
//

import AppKit
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

    var launchAtLogin: Bool = SMAppService.mainApp.status == .enabled {
        didSet {
            do {
                if launchAtLogin {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Failed to \(launchAtLogin ? "enable" : "disable") launch at login: \(error)")
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

    var lockOnInactivity: Bool {
        didSet {
            UserDefaults.standard.set(lockOnInactivity, forKey: Keys.lockOnInactivity)
            if isActive {
                if lockOnInactivity {
                    startInactivityMonitoring()
                } else {
                    stopInactivityMonitoring()
                }
            }
        }
    }

    // MARK: - Computed Properties

    var displaySleepMinutes: Int? {
        sleepManager.getDisplaySleepMinutes()
    }

    var hasAccessibilityPermission: Bool {
        ScreenLocker.hasAccessibilityPermission
    }

    // MARK: - Services

    private let sleepManager = SleepManager()
    private let batteryMonitor = BatteryMonitor()
    private let hotKeyManager = HotKeyManager()
    private let inactivityMonitor = InactivityMonitor()

    private var timer: Timer?

    // MARK: - Initialization

    init() {
        leftClickActivation = UserDefaults.standard.bool(forKey: Keys.leftClickActivation)
        disableOnBattery = UserDefaults.standard.bool(forKey: Keys.disableOnBattery)
        batteryThreshold = UserDefaults.standard.integer(forKey: Keys.batteryThreshold)
        lockOnInactivity = UserDefaults.standard.bool(forKey: Keys.lockOnInactivity)
        hotKey = loadHotKey()

        setupBatteryMonitoring()
        setupHotKeyHandler()
        setupInactivityMonitor()
        setupSessionObserver()

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
        clearTimer()

        activationDuration = duration

        let seconds: TimeInterval = if let duration {
            Double(duration.components.seconds)
        } else {
            0
        }

        sleepManager.enable(duration: seconds)
        isActive = true

        if lockOnInactivity {
            startInactivityMonitoring()
        }

        guard seconds > 0 else {
            return
        }

        timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.isActive = false
            }
        }
    }

    func deactivate() {
        clearTimer()
        stopInactivityMonitoring()
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

    func requestAccessibilityPermission() {
        ScreenLocker.requestAccessibilityPermission()
    }

    // MARK: - Private

    private func clearTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func setupBatteryMonitoring() {
        batteryMonitor.onChange = { [weak self] in
            guard let self, isActive else { return }

            let shouldDisable = {
                guard self.disableOnBattery,
                      self.batteryMonitor.isOnBattery
                else {
                    return false
                }

                guard self.batteryThreshold > 0 else {
                    return true
                }

                let thresholdReached = self.batteryMonitor.currentCharge >= self.batteryThreshold
                return thresholdReached
            }()

            if shouldDisable {
                deactivate()
            }
        }

        batteryMonitor.start()
    }

    private func setupHotKeyHandler() {
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

    private func setupInactivityMonitor() {
        inactivityMonitor.onInactivityThresholdReached = { [weak self] in
            Task { @MainActor in
                guard let self, self.isActive, self.lockOnInactivity else { return }
                ScreenLocker.lock()
            }
        }
    }

    private func setupSessionObserver() {
        NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.sessionDidBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                guard let self, self.isActive, self.lockOnInactivity else { return }
                self.startInactivityMonitoring()
            }
        }
    }

    private func startInactivityMonitoring() {
        guard let minutes = displaySleepMinutes,
              minutes > 0,
              isActive
        else {
            return
        }

        inactivityMonitor.start(thresholdMinutes: minutes)
    }

    private func stopInactivityMonitoring() {
        inactivityMonitor.stop()
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
        static let lockOnInactivity = "lockOnInactivity"
    }
}

// MARK: - Durations

extension AppState {
    static let presetDurations: [Duration] = [
        .seconds(15 * 60),
        .seconds(30 * 60),
        .seconds(60 * 60),
        .seconds(2 * 60 * 60)
    ]
}
