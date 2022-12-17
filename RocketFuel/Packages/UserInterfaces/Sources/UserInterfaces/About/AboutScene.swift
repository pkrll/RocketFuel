//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import SwiftUI

public struct About: Scene {
    
    let image: Image
    let title: String
    let subtitle: String
    let copyright: String
    let width: CGFloat
    let height: CGFloat
    
    public var body: some Scene {
        WindowGroup("") {
            AboutView(
                image: image,
                title: title,
                subtitle: subtitle,
                copyright: copyright,
                width: width,
                height: height
            )
        }
        .windowResizabilityContentSize()
        .handlesExternalEvents(matching: ["about"])
    }
    
    public init(
        image: Image,
        title: String,
        subtitle: String,
        copyright: String,
        width: CGFloat,
        height: CGFloat
    ) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.copyright = copyright
        self.width = width
        self.height = height
    }
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
