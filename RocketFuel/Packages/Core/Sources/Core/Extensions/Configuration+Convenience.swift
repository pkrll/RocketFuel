//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Analytics
import Foundation

extension Configuration {
    static var standard: Configuration? {
        nil
    }
}

private extension Bundle {
    static var shortVersionString: String? {
        main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
