//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Cocoa
import MenuBarExtras

extension Menu {
    static func create(
        title: String,
        isActive: Bool,
        launchOnLogin: Bool,
        leftClickActivation: Bool,
        activationDuration: TimeInterval,
        toggleAction: @escaping () async -> Void,
        launchOnLoginAction: @escaping () async -> Void,
        leftClickActivationAction: @escaping () async -> Void,
        deactivateAfterAction: @escaping (TimeInterval) async -> Void,
        preferencesAction: @escaping () async -> Void,
        aboutAction: @escaping () async -> Void,
        quitAction: @escaping () async -> Void
    ) -> Menu {
        Menu(title: title) {
            Menu.Item.toggle(isActive: isActive, action: toggleAction)
            Menu.Item.separator
            
            Menu.Item.launchOnLogin(selected: launchOnLogin, action: launchOnLoginAction)
            Menu.Item.leftClickActivation(selected: leftClickActivation, action: leftClickActivationAction)
            Menu.Item.deactivateAfter {
                let durationIsFiveMinutes = activationDuration == 300
                Menu.Item.button(title: "5 Minutes", selected: durationIsFiveMinutes, keyEquivalent: "1") {
                    await deactivateAfterAction(300)
                }
                
                let durationIsFifteenMinutes = activationDuration == 900
                Menu.Item.button(title: "15 Minutes", selected: durationIsFifteenMinutes, keyEquivalent: "2") {
                    await deactivateAfterAction(900)
                }
                
                let durationIsThirtyMinutes = activationDuration == 1800
                Menu.Item.button(title: "30 Minutes", selected: durationIsThirtyMinutes, keyEquivalent: "3") {
                    await deactivateAfterAction(1800)
                }

                let durationIsSixtyMinutes = activationDuration == 3600
                Menu.Item.button(title: "1 Hour", selected: durationIsSixtyMinutes, keyEquivalent: "4") {
                    await deactivateAfterAction(3600)
                }

                let durationIsTwoHours = activationDuration == 7200
                Menu.Item.button(title: "2 Hours", selected: durationIsTwoHours, keyEquivalent: "5") {
                    await deactivateAfterAction(7200)
                }

                let durationIsZero = activationDuration == 0
                Menu.Item.button(title: "Never", selected: durationIsZero, keyEquivalent: "0") {
                    await deactivateAfterAction(0)
                }
                
//                Menu.Item.separator
//                Menu.Item.button(title: "Custom", keyEquivalent: "c")
            }
            
            Menu.Item.separator
            Menu.Item.preferences(action: preferencesAction)
            Menu.Item.about(action: aboutAction)
            
            Menu.Item.separator
            Menu.Item.quit(action: quitAction)
        }
    }
    
    convenience init(title: String, @ResultBuilder<Item> builder: () -> [Item]) {
        let items = builder()
        self.init(title: title, items: items)
    }
}

private extension Menu.Item {
    static func toggle(isActive: Bool, action: @escaping () async -> Void) -> Self {
        .button(title: isActive ? "Deactivate" : "Activate", keyEquivalent: "t", action: action)
    }
    
    static func launchOnLogin(selected: Bool, action: @escaping () async -> Void) -> Self {
        .button(title: "Launch on Login", selected: selected, keyEquivalent: "l", action: action)
    }
    
    static func leftClickActivation(selected: Bool, action: @escaping () async -> Void) -> Self {
        button(title: "Left-Click Activation", selected: selected, keyEquivalent: "a", action: action)
    }
    
    static func deactivateAfter(@ResultBuilder<Self> builder: () -> [Self]) -> Self {
        .button(title: "Deactivate After", children: builder())
    }
    
    static func preferences(action: @escaping () async -> Void) -> Self {
        .button(title: "Preferences...", keyEquivalent: "p", action: action)
    }
    
    static func about(action: @escaping () async -> Void) -> Self {
        .button(title: "About...", action: action)
    }
    
    static func quit(action: @escaping () async -> Void) -> Self {
        .button(title: "Quit Rocket Fuel", keyEquivalent: "q", action: action)
    }
}
