//
//  Copyright © 2025 Ardalan Samimi. All rights reserved.
//

import SwiftUI

struct MenuCommands: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        toggleButton

        Divider()

        deactivateAfterMenu

        Divider()

        launchAtLoginToggle

        Divider()

        SettingsLink {
            Text("Settings...")
        }
        .keyboardShortcut(",", modifiers: .command)

        Divider()

        quitButton
    }

    private var toggleButton: some View {
        Button {
            appState.toggle()
        } label: {
            Text(appState.isActive ? "Deactivate" : "Activate")
        }
    }

    private var deactivateAfterMenu: some View {
        Menu("Deactivate After") {
            ForEach(AppState.availableDurations, id: \.self) { duration in
                Button {
                    if let duration {
                        appState.activate(for: duration)
                    } else {
                        appState.activate()
                    }
                } label: {
                    HStack {
                        Text(duration?.formatted ?? "Never")
                        if appState.activationDuration == duration && appState.isActive {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
    }

    private var launchAtLoginToggle: some View {
        @Bindable var state = appState

        return Toggle("Launch at Login", isOn: $state.launchAtLogin)
    }

    private var quitButton: some View {
        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
        .keyboardShortcut("q", modifiers: .command)
    }
}

// MARK: - Duration Formatting

extension Duration {
    var formatted: String {
        let totalSeconds = components.seconds
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60

        if hours > 0 {
            return hours == 1 ? "1 Hour" : "\(hours) Hours"
        } else {
            return "\(minutes) Minutes"
        }
    }
}
