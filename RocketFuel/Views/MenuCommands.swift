//
//  Copyright © 2025 Ardalan Samimi. All rights reserved.
//

import SwiftUI

struct MenuCommands: View {
    @Environment(AppState.self) private var appState
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openSettings) private var openSettings

    var body: some View {
        toggleButton

        Divider()

        deactivateAfterMenu
        launchAtLoginToggle

        Divider()

        Button {
            openSettings()
            NSApp.activate(ignoringOtherApps: true)
        } label: {
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
            ForEach(AppState.presetDurations, id: \.self) { duration in
                durationButton(for: duration)
            }

            Divider()

            Button {
                openWindow(id: "custom-duration")
                NSApp.activate(ignoringOtherApps: true)
            } label: {
                HStack {
                    Text(customDurationLabel)
                    if isCustomDurationActive {
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                }
            }

            Divider()

            Button {
                appState.activate()
            } label: {
                HStack {
                    Text("Never")
                    if appState.activationDuration == nil && appState.isActive {
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
    }

    private var isCustomDurationActive: Bool {
        guard let active = appState.activationDuration, appState.isActive else {
            return false
        }
        return !AppState.presetDurations.contains(active)
    }

    private var customDurationLabel: String {
        if let active = appState.activationDuration,
           appState.isActive,
           !AppState.presetDurations.contains(active) {
            return "Custom (\(active.formatted))"
        }
        return "Custom..."
    }

    private func durationButton(for duration: Duration) -> some View {
        Button {
            appState.activate(for: duration)
        } label: {
            HStack {
                Text(duration.formatted)
                if appState.activationDuration == duration && appState.isActive {
                    Spacer()
                    Image(systemName: "checkmark")
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

// MARK: - Custom Duration View

struct CustomDurationView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var minutes = 60

    var body: some View {
        VStack(spacing: 20) {
            Text("Custom Duration")
                .font(.headline)

            HStack {
                TextField("Minutes", value: $minutes, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)

                Text("minutes")
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)

                Button("Activate") {
                    let duration = Duration.seconds(minutes * 60)
                    appState.activate(for: duration)
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(minutes <= 0)
            }
        }
        .padding(24)
        .fixedSize()
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
