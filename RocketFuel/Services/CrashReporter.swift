//
//  Copyright © 2025 Ardalan Samimi. All rights reserved.
//

import Foundation
import Sentry

enum CrashReporter {
    static func configure() {
        #if !DEBUG
        SentrySDK.start { options in
            options.dsn = ""
            options.enableAutoSessionTracking = true
            options.enableCrashHandler = true
        }
        #endif
    }

    static func capture(error: Error) {
        #if !DEBUG
        SentrySDK.capture(error: error)
        #endif
    }

    static func capture(message: String) {
        #if !DEBUG
        SentrySDK.capture(message: message)
        #endif
    }
}
