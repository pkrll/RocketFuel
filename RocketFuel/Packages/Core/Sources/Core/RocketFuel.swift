//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Cocoa
import Combine
import HotKeys
import MenuBarExtras
import Resources
import SleepControl

public final class RocketFuel: NSObject, NSApplicationDelegate {
    
    public let appState = AppState()
    
    private let appTitle = "Rocket Fuel"
    private let sleepControl: SleepControl = SleepControl()
    private var menuBarExtra: MenuBarExtra?
    private let hotKeysCentral: HotKeysCentral = .standard
    private var activationDuration: TimeInterval = 0
    private var subscriptions: Set<AnyCancellable> = []
    
    override init() {
        super.init()
        
        hotKeysCentral.$hotKeyPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.hotKeyWasTriggered()
            }
            .store(in: &subscriptions)
        
        Task {
            await appState.$onChangePublisher
                .dropFirst()
                .receive(on: RunLoop.main)
                .sink { [weak self] value in
                    self?.stateDidChange(value)
                }
                .store(in: &subscriptions)
        }
    }
    
    public func applicationDidFinishLaunching(_ notification: Notification) {
        menuBarExtra = MenuBarExtra(
            toolTip: appTitle,
            leftClickEvent: leftClickEvent(_:),
            rightClickEvent: rightClickEvent(_:)
        )
        
        Task { @MainActor in
            await loadRegisteredHotKey()
            await updateUI(isActive: false)
        }
    }
    
    private func hotKeyWasTriggered() {
        Task {
            await toggle()
        }
    }
    
    private func stateDidChange(_ event: AppState.Event) {
        guard case .change(let key) = event,
              [.disableAtBatteryLevel, .disableOnBatteryMode].contains(key),
              sleepControl.isActive
        else {
            return
        }
        
        Task {
            await setSleepControl(to: true, duration: activationDuration)
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
    
    private func updateUI(isActive: Bool) async {
        let image: NSImage = isActive ? .statusItemActive : .statusItemIdle
        await menuBarExtra?.set(image: image)
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
        
        let isActive = sleepControl.isActive
        await updateUI(isActive: isActive)
    }
    
    private func createMenu() async -> NSMenu {
        let isActive = sleepControl.isActive
        let leftClickActivation = await appState.leftClickActivation
        
        let menu = Menu.create(
            title: appTitle,
            isActive: isActive,
            launchOnLogin: false,
            leftClickActivation: leftClickActivation,
            activationDuration: activationDuration
        ) {
            await self.toggle()
        } launchOnLoginAction: {
            // Launch on login
        } leftClickActivationAction: {
            await self.appState.setLeftClickActivation(to: !leftClickActivation)
        } deactivateAfterAction: { duration in
            await self.setSleepControl(to: isActive, duration: duration)
        } preferencesAction: {
            if #available(macOS 13, *) {
                await NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
            } else {
                await NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
            }
        } aboutAction: {
            // Show about
        } quitAction: {
            await NSApp.terminate(self)
        }
        
        menu.delegate = self
        
        return menu
    }
}
// MARK: - NSMenuDelegate
extension RocketFuel: NSMenuDelegate {
    public func menuDidClose(_ menu: NSMenu) {
        menuBarExtra?.closeMenu()
    }
}
