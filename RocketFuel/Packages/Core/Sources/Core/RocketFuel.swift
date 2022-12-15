//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Cocoa
import MenuBarExtras
import Resources
import SleepControl

public final class RocketFuel: NSObject, NSApplicationDelegate {
    
    private let appState = AppState.shared
    private let appTitle = "Rocket Fuel"
    private let sleepControl: SleepControl = SleepControl()
    private var menuBarExtra: MenuBarExtra?
    
    public func applicationDidFinishLaunching(_ notification: Notification) {
        menuBarExtra = MenuBarExtra(
            toolTip: appTitle,
            leftClickEvent: leftClickEvent(_:),
            rightClickEvent: rightClickEvent(_:)
        )
        
        Task { @MainActor in
            await updateUI(isActive: false)
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
        if sleepControl.isActive {
            sleepControl.disable()
        } else {
            sleepControl.enable()
        }
        
        let isActive = sleepControl.isActive
        await updateUI(isActive: isActive)
    }
    
    private func createMenu() async -> NSMenu {
        
        let leftClickActivation = await appState.leftClickActivation
        
        let menu = Menu(title: appTitle) {
            Menu.Item.toggle(isActive: sleepControl.isActive) {
                await self.toggle()
            }
            
            Menu.Item.separator
            
            Menu.Item.launchOnLogin(selected: false) {}
            
            Menu.Item.leftClickActivation(selected: leftClickActivation) {
                await self.appState.setLeftClickActivation(to: !leftClickActivation)
            }
            
            Menu.Item.deactivateAfter {
                Menu.Item.button(title: "5 Minutes", selected: false, keyEquivalent: "1") {}
                Menu.Item.button(title: "15 Minutes", selected: false, keyEquivalent: "2") {}
                Menu.Item.button(title: "30 Minutes", selected: false, keyEquivalent: "3") {}
                Menu.Item.button(title: "Never", selected: false, keyEquivalent: "0") {}
                Menu.Item.separator
                Menu.Item.button(title: "Custom", keyEquivalent: "c") {}
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
