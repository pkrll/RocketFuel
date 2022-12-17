//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import SwiftUI

struct GeneralSettingsView: View {
    
    @State var disableOnBatteryMode: Bool = false
    @State var disableAtBatteryLevel: Int = 0
    @ObservedObject private var observer = ForegroundObserver()
    
    let settings: Settings
    
    var body: some View {
        Form {
            disableOnBatteryModeSetting()
            Spacer()
            disableAtBatteryLevelSetting()
            Spacer()
            shortcutSetting()
            Spacer()
        }
        .onChange(of: disableOnBatteryMode) { newValue in
            Task {
                await settings.setDisableOnBatteryMode(to: newValue)
            }
        }
        .onChange(of: disableAtBatteryLevel) { newValue in
            Task {
                await settings.setDisableAtBatteryLevel(to: newValue)
            }
        }
        .onReceive(self.observer.$enteredForeground) { _ in
            Task {
                disableOnBatteryMode = await settings.disableOnBatteryMode
                disableAtBatteryLevel = await settings.disableAtBatteryLevel
            }
        }
    }
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    @ViewBuilder
    private func disableOnBatteryModeSetting() -> some View {
        Toggle("Stop on Battery Mode", isOn: $disableOnBatteryMode)
            .font(.body)
    }
    
    @ViewBuilder
    private func disableAtBatteryLevelSetting() -> some View {
        Text("Disable Rocket Fuel when battery level reaches:")
            .font(.body)
        Picker("", selection: $disableAtBatteryLevel) {
            let levels = possibleBatteryLevels()
            
            ForEach(levels, id: \.self) { level in
                Text("\(level)%")
            }
        }
    }
    
    private func possibleBatteryLevels() -> [Int] {
        var levels = Array(stride(from: 0, to: 20, by: 5))
        
        if !levels.contains(disableAtBatteryLevel) {
            levels.append(disableAtBatteryLevel)
        }

        return levels
    }
    
    @ViewBuilder
    private func shortcutSetting() -> some View {
        Text("Toggle Rocket Fuel")
            .font(.body)
        KeyRecorderView(settings: settings)
    }
}
