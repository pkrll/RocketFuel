//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Cocoa
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
    
    private func loadRegisteredHotKey() async {
        guard let hotKey = await appState.registeredHotKey else {
            return
        }

        do {
            let hotKey = HotKey(from: hotKey) {
                await self.toggle()
            }
            
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
            sleepControl.enable(duration: duration)
        } else {
            sleepControl.disable()
        }
        
        let isActive = sleepControl.isActive
        await updateUI(isActive: isActive)
    }
    
    private func createMenu() async -> NSMenu {
        let isActive = sleepControl.isActive
        let leftClickActivation = await appState.leftClickActivation
        
        let menu = Menu(title: appTitle) {
            Menu.Item.toggle(isActive: isActive) {
                await self.toggle()
            }
            
            Menu.Item.separator
            
            Menu.Item.launchOnLogin(selected: false) {}
            
            Menu.Item.leftClickActivation(selected: leftClickActivation) {
                await self.appState.setLeftClickActivation(to: !leftClickActivation)
            }
            
            Menu.Item.deactivateAfter {
                let durationIsFiveMinutes = activationDuration == 300
                Menu.Item.button(title: "5 Minutes", selected: durationIsFiveMinutes, keyEquivalent: "1") {
                    await self.setSleepControl(to: isActive, duration: 300)
                }
                
                let durationIsFifteenMinutes = activationDuration == 900
                Menu.Item.button(title: "15 Minutes", selected: durationIsFifteenMinutes, keyEquivalent: "2") {
                    await self.setSleepControl(to: isActive, duration: 900)
                }
                
                let durationIsThirtyMinutes = activationDuration == 1800
                Menu.Item.button(title: "30 Minutes", selected: durationIsThirtyMinutes, keyEquivalent: "3") {
                    await self.setSleepControl(to: isActive, duration: 1800)
                }
                
                let durationIsZero = activationDuration == 0
                Menu.Item.button(title: "Never", selected: durationIsZero, keyEquivalent: "0") {
                    await self.setSleepControl(to: isActive, duration: 0)
                }
                
                Menu.Item.separator
                Menu.Item.button(title: "Custom", keyEquivalent: "c")
            }
            
            Menu.Item.separator
            
            Menu.Item.preferences {
                if #available(macOS 13, *) {
                    await NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                } else {
                    await NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
                }
            }
            
            Menu.Item.about {
                
            }
            
            Menu.Item.separator
            
            Menu.Item.quit {
                await NSApp.terminate(self)
            }
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

private extension HotKey {
    init(from hotKey: HotKey, action: @escaping () async -> Void) {
        self.init(keyCode: hotKey.keyCode, modifier: hotKey.modifier, readable: hotKey.readable) {
            Task {
                await action()
            }
        }
    }
}
