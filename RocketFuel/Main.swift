//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import SwiftUI
import Core

@main
struct Main: App {
    
    @NSApplicationDelegateAdaptor
    private var rocketFuel: RocketFuel
    
    var body: some Scene {
        Settings {}
    }
}
