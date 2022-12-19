//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Resources
import SwiftUI

public struct About: Scene {
    
    public var body: some Scene {
        WindowGroup("") {
            AboutView(
                image: Image(nsImage: .rocketIcon),
                title: Application.applicationDisplayName,
                subtitle: .localized(key: "about_version_format", arguments: Application.versionString),
                copyright: .localized(key: "about_copyright_text_label"),
                width: 240,
                height: 200
                
            )
        }
        .windowResizabilityContentSize()
        .handlesExternalEvents(matching: ["about"])
    }
    
    public init() {}
}

private extension Scene {
    func windowResizabilityContentSize() -> some Scene {
        if #available(macOS 13.0, *) {
            return windowResizability(.contentSize)
        } else {
            return self
        }
    }
}
