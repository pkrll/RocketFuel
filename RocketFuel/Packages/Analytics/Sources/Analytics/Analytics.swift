//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation
import Mixpanel

public final class Analytics {
    private let token: String?
    private var mixpanel: MixpanelInstance?
    private var shouldTrackEvents = true
    
    public init(token: String?) {
        self.token = token
    }
    
    public func configure() {
        guard shouldTrackEvents, let token else {
            return
        }
        
        mixpanel = Mixpanel.initialize(token: token, flushInterval: 15)
    }
    
    public func setUserSettings(_ properties: Properties) {
        guard shouldTrackEvents, let mixpanel else {
            return
        }
        
        mixpanel.people.set(properties: properties)
    }
    
    public func track(_ event: Event, sendImmediately: Bool = false) {
        guard shouldTrackEvents, let mixpanel else {
            return
        }
        
        mixpanel.track(event: event.name, properties: event.properties)
        
        if sendImmediately {
            mixpanel.flush()
        }
    }
    
    public func enableEventsTracking(_ shouldTrackEvents: Bool) {
        self.shouldTrackEvents = shouldTrackEvents
    }
}
