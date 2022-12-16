//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import SwiftUI

public struct SettingsContainerView: View {
    public var body: some View {
        TabView {
            GeneralSettingsView(settings: settings)
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(1)
        }
        .padding(20)
        .frame(width: 220, height: 230)
    }
    
    private let settings: Settings
    
    public init(settings: Settings) {
        self.settings = settings
    }
}
