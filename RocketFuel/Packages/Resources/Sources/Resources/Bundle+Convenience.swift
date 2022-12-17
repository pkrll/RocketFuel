//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation

public extension Bundle {
    var shortVersionString: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }    
    var displayName: String? {
        infoDictionary?["CFBundleDisplayName"] as? String
    }
}
