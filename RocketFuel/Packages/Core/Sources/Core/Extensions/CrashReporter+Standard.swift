//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import CrashReporting
import Foundation

extension CrashReporter {
    static var standard: CrashReporter {
        let configuration: Configuration?
        #if DEBUG
        configuration = nil
        #else
        let version = Bundle.shortVersionString ?? "Unknown"
        
        configuration = Configuration(
            url: URL(string: "")!,
            version: version
        )
        #endif
        
        return CrashReporter(configuration: configuration)
    }
}

private extension Bundle {
    static var shortVersionString: String? {
        main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
