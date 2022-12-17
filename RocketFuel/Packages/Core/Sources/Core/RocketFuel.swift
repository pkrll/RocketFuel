//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Analytics
import Cocoa
import Combine
import Constants
import CrashReporting
import HotKeys
import LoginItem
import MenuBarExtras
import Resources
import SleepControl

public final class RocketFuel: NSObject, NSApplicationDelegate {
    
    public let appState: AppState = .shared
    
    private let appTitle = Application.applicationDisplayName
    private let sleepControl: SleepControl = .standard
    private var menuBarExtra: MenuBarExtra?
    private let hotKeysCentral: HotKeysCentral = .standard
    private let analytics: Analytics = .standard
    private let crashReporter: CrashReporter = .standard
    private var activationDuration: TimeInterval = 0
    private var subscriptions: Set<AnyCancellable> = []
    
    override init() {
        super.init()
        
        sleepControl.$isActive
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateUI(isActive:))
            .store(in: &subscriptions)
        
        hotKeysCentral.$hotKeyPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: hotKeyWasTriggered(_:))
            .store(in: &subscriptions)
        
        Task {
            await appState.$onChangePublisher
                .dropFirst()
                .receive(on: RunLoop.main)
                .sink(receiveValue: stateDidChange(_:))
                .store(in: &subscriptions)
        }
    }
    
    public func applicationWillTerminate(_ notification: Notification) {
        analytics.track(.terminate, sendImmediately: true)
    }
    
    public func applicationDidFinishLaunching(_ notification: Notification) {
        analytics.configure()
        crashReporter.configure()
        // Workaround for not showing About scene on launch.
        if let window = NSApplication.shared.windows.first {
            window.close()
        }
        
        menuBarExtra = MenuBarExtra(
            toolTip: appTitle,
            leftClickEvent: leftClickEvent(_:),
            rightClickEvent: rightClickEvent(_:)
        )
        
        Task { @MainActor in
            await loadRegisteredHotKey()
            updateUI(isActive: false)
        }
    }
    
    private func hotKeyWasTriggered(_ hotKey: HotKey?) {
        Task {
            await toggle()
        }
    }
    
    private func stateDidChange(_ event: AppState.Event) {
        guard case .change(let key, let value) = event else {
            return
        }
        
        analytics.track(.update(setting: key.rawValue, value: "\(value)"))
        
        guard sleepControl.isActive,
              [.disableAtBatteryLevel, .disableOnBatteryMode].contains(key)
        else {
            return
        }
        
        Task {
            await setSleepControl(to: true, duration: activationDuration)
        }
    }
    
    private func updateUI(isActive: Bool) {
        Task { @MainActor in
            let image: NSImage = isActive ? .statusItemActive : .statusItemIdle
            menuBarExtra?.set(image: image)
        }
    }
    
    private func loadRegisteredHotKey() async {
        guard let hotKey = await appState.registeredHotKey else {
            return
        }
        
        do {
            try hotKeysCentral.register(hotKey)
        } catch {
            print("An error occurred. Unable to register hot key: \(error).")
        }
    }
    
    private func leftClickEvent(_ flags: NSEvent.ModifierFlags) async throws {
        let leftClickActivation = await appState.leftClickActivation
        let shouldShowMenu = flags.contains(.control) || !leftClickActivation
        
        if shouldShowMenu {
            await showMenu()
        } else {
            await toggle()
        }
    }
    
    private func rightClickEvent(_ flags: NSEvent.ModifierFlags) async throws {
        await showMenu()
    }
    
    private func showMenu() async {
        let menu = await createMenu()
        await menuBarExtra?.show(menu: menu)
    }
    
    private func toggle() async {
        await setSleepControl(to: !sleepControl.isActive, duration: activationDuration)
    }
    
    private func setSleepControl(to shouldEnable: Bool, duration: TimeInterval = 0) async {
        activationDuration = duration
        
        if shouldEnable {
            let shouldStopOnBatteryMode = await appState.disableOnBatteryMode
            let minimumBatteryLevel = await appState.disableAtBatteryLevel
            
            sleepControl.enable(
                duration: duration,
                shouldStopOnBatteryMode: shouldStopOnBatteryMode,
                minimumBatteryLevel: minimumBatteryLevel
            )
        } else {
            sleepControl.disable()
        }
        
        analytics.track(.toggle(status: sleepControl.isActive, duration: activationDuration))
    }
    
    private func createMenu() async -> NSMenu {
        let isActive = sleepControl.isActive
        let leftClickActivation = await appState.leftClickActivation
        let launchOnLogin = await appState.autoLaunchOnLogin
        
        let menu = Menu.create(
            title: appTitle,
            isActive: isActive,
            launchOnLogin: launchOnLogin,
            leftClickActivation: leftClickActivation,
            activationDuration: activationDuration
        ) {
            await self.toggle()
        } launchOnLoginAction: {
            await self.toggleLaunchOnLogin()
        } leftClickActivationAction: {
            await self.appState.setLeftClickActivation(to: !leftClickActivation)
        } deactivateAfterAction: { duration in
            await self.setSleepControl(to: isActive, duration: duration)
        } preferencesAction: {
            await self.showPreferencesWindow()
        } aboutAction: {
            self.showAboutWindow()
        } quitAction: {
            await NSApp.terminate(self)
        }
        
        if Application.hasDeveloperSettings {
            menu.insertDeveloperSettingsMenu {
                self.crashReporter.crash()
            } log: {
                // Log?
            }
        }
        
        menu.delegate = self
        
        return menu
    }
    
    private func toggleLaunchOnLogin() async {
        let launchOnLogin = await appState.autoLaunchOnLogin
        await appState.setAutoLaunchOnLogin(to: !launchOnLogin)
    }
    
    private func showPreferencesWindow() async {
        if #available(macOS 13, *) {
            await NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        } else {
            await NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        }
        
        analytics.track(.showPreferences)
    }
    
    private func showAboutWindow() {
        guard let url = URL(string: "\(Application.appScheme)://about") else {
            return
        }
        
        NSWorkspace.shared.open(url)
        analytics.track(.showAbout)
    }
}
// MARK: - NSMenuDelegate
extension RocketFuel: NSMenuDelegate {
    public func menuDidClose(_ menu: NSMenu) {
        menuBarExtra?.closeMenu()
    }
}
// MARK: - AppleScript
extension RocketFuel {
    @objc(AppleScript)
    public final class AppleScript: NSScriptCommand {
        private var rocketFuel: RocketFuel { AppDelegate.instance }
        var active: Bool { rocketFuel.sleepControl.isActive }
        
        @objc
        func Toggle() {
            Task {
                await rocketFuel.toggle()
            }
        }
        
        @objc
        func Duration() {
            // The duration is expressed in minutes in AppleScript, but seconds in the app,
            // so it needs to be translated to seconds to work correctly.
            let input: Double = (directParameter as AnyObject).doubleValue ?? 0
            let duration = input * 60
            
            Task {
                await rocketFuel.setSleepControl(to: true, duration: duration)
            }
        }
        
        @objc
        func BatteryLevel() {
            let level = directParameter as? Int ?? 0
            Task {
                await rocketFuel.appState.setDisableAtBatteryLevel(to: level)
            }
        }
        
        @objc
        func BatteryMode() {
            let mode: Bool = directParameter as? Bool ?? false
            Task {
                await rocketFuel.appState.setDisableOnBatteryMode(to: mode)
            }
        }
        
        override public func performDefaultImplementation() -> Any? {
            let command = commandDescription
                .commandName
                .components(separatedBy: " ")
                .map(\.capitalized)
                .joined()
            let commandFunc = NSSelectorFromString(command)
            
            guard responds(to: commandFunc) else {
                return false
            }
            
            typealias function = @convention(c) (AnyObject, Selector) -> Void
            let imp: IMP = method(for: commandFunc)
            let curriedImplementation = unsafeBitCast(imp, to: function.self)
            curriedImplementation(self, commandFunc)
            
            return true
        }
    }
}
