//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Cocoa
import MenuBarExtras

extension Menu {
    convenience init(title: String, @ResultBuilder<Item> builder: () -> [Item]) {
        let items = builder()
        self.init(title: title, items: items)
    }
}

extension Menu.Item {
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
