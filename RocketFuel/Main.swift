//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Core
import Resources
import SwiftUI
import UserInterfaces
import Constants

@main
struct Main: App {
    
    @NSApplicationDelegateAdaptor
    private var rocketFuel: RocketFuel
    
    var body: some Scene {
        Settings {
            SettingsContainerView(settings: rocketFuel.appState)
        }
        
        About(
            image: Image(nsImage: .rocketIcon),
            title: Application.applicationDisplayName,
            subtitle: "Version \(Application.versionString)",
            copyright: Application.copyrightText,
            width: 240,
            height: 200
        )
    }
}
