//
//  Copyright © 2025 Ardalan Samimi. All rights reserved.
//

import SwiftUI

@main
struct RocketFuelApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        MenuBarExtra {
            MenuCommands()
                .environment(appState)
        } label: {
            Image(systemName: appState.isActive ? "bolt.fill" : "bolt")
                .symbolRenderingMode(.hierarchical)
        }
        .menuBarExtraStyle(.menu)

        Settings {
            SettingsView()
                .environment(appState)
        }
    }

    init() {
        CrashReporter.configure()
        RocketFuelScriptBridge.shared.configure(with: appState)
    }
}
