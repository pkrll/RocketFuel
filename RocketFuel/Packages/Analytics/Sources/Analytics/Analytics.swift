//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation
import Mixpanel

public struct Analytics {
    private let token: String?
    public init(token: String?) {
        self.token = token
    }
    
    public func configure() {
        guard let token else {
            return
        }
        
        Mixpanel.initialize(token: token, flushInterval: 15)
    }
    
    public func track(_ event: Event, sendImmediately: Bool = false) {
        guard token != nil else {
            return
        }
        
        Mixpanel.mainInstance().track(event: event.name, properties: event.properties)
        
        if sendImmediately {
            Mixpanel.mainInstance().flush()
        }
    }
}
