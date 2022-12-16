//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import CrashReporting
import Foundation


extension CrashReporter {
    static var standard: CrashReporter {
        CrashReporter(configuration: nil)
    }
}

private extension Bundle {
    static var shortVersionString: String? {
        main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
