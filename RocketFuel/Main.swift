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
        
        WindowGroup("") {
            AboutView(
                image: Image(nsImage: .rocketIcon),
                title: Constants.applicationDisplayName,
                subtitle: "Version \(Constants.versionString)",
                copyright: Constants.copyrightText,
                width: 240,
                height: 200
            )
        }
        .windowResizabilityContentSize()
        .handlesExternalEvents(matching: ["about"])
    }
}

extension Scene {
    func windowResizabilityContentSize() -> some Scene {
        if #available(macOS 13.0, *) {
            return windowResizability(.contentSize)
        } else {
            return self
        }
    }
}
