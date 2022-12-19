//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Core
import SwiftUI
import UserInterfaces

@main
struct Main: App {
    
    @NSApplicationDelegateAdaptor
    private var rocketFuel: RocketFuel
    
    var body: some Scene {
        Settings {
            SettingsContainerView(settings: rocketFuel.appState)
        }
        
        About()
    }
}
