//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation
import Sentry

public struct CrashReporter {
    
    public struct Configuration {
        let url: URL
        let version: String
        
        public init(url: URL, version: String) {
            self.url = url
            self.version = version
        }
    }
    
    public var isEnabled: Bool { SentrySDK.isEnabled }
    
    private let configuration: Configuration?
    
    public init(configuration: Configuration?) {
        self.configuration = configuration
    }
    
    public func configure() {
        guard let configuration else {
            return
        }
        
        SentrySDK.start { options in
            options.dsn = configuration.url.absoluteString
            options.releaseName = configuration.version
#if DEBUG
            options.debug = true
            options.diagnosticLevel = .debug
            options.environment = "Debug"
#else
            options.environment = "Release"
#endif
        }
    }
    
#if DEBUG
    public func crash() {
        guard SentrySDK.isEnabled else {
            return
        }
        
        SentrySDK.crash()
    }
#endif
}
