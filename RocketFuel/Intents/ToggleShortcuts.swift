//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import AppIntents

@available(macOS 13.0, *)
struct ToggleShortcuts: AppShortcutsProvider {

    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: Toggle(),
            phrases: ["Toggle Rocket Fuel", "Keep my screen turned on"]
        )
    }
}
