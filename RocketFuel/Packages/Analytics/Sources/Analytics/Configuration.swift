//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation

public struct Configuration {
    let url: URL
    let version: String
    
    public init(url: URL, version: String) {
        self.url = url
        self.version = version
    }
}
