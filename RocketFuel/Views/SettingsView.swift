//
//  Copyright © 2025 Ardalan Samimi. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var state = appState

        Form {
            Section {
                Toggle("Disable on Battery Power", isOn: $state.disableOnBattery)

                if appState.disableOnBattery {
                    Picker("Battery Threshold", selection: $state.batteryThreshold) {
                        Text("Never").tag(0)
                        ForEach([5, 10, 15, 20], id: \.self) { level in
                            Text("\(level)%").tag(level)
                        }
                    }
                    .pickerStyle(.menu)
                }
            } header: {
                Text("Battery")
            } footer: {
                Text("Automatically deactivate when switching to battery power or when battery falls below threshold.")
            }

            Section {
                Toggle("Lock screen on inactivity", isOn: $state.lockOnInactivity)

                if appState.lockOnInactivity {
                    if let minutes = appState.displaySleepMinutes, minutes > 0 {
                        LabeledContent("Locks after") {
                            Text("\(minutes) minutes")
                                .foregroundStyle(.secondary)
                        }
                    }

                    if !appState.hasAccessibilityPermission {
                        Button("Grant Accessibility Permission") {
                            appState.requestAccessibilityPermission()
                        }
                    }
                }
            } header: {
                Text("Security")
            } footer: {
                Text("Lock the screen after the same inactivity period as your display sleep setting. Requires Accessibility permission.")
            }

            Section("Shortcut") {
                KeyRecorderView()
                    .environment(appState)
            }
        }
        .formStyle(.grouped)
        .frame(width: 350, height: 460)
    }
}

#Preview {
    SettingsView()
        .environment(AppState())
}
