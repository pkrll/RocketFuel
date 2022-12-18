//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation
import Mixpanel

public final class Analytics {
    private let token: String?
    private var mixpanel: MixpanelInstance?
    
    private lazy var distinctId: String? = {
        do {
            let data = try Keychain.get()
            let distinctId = String(data: data, encoding: .utf8)
            
            return distinctId
        } catch {
            track(.error(error))
            debugPrint(error)
        }
        
        do {
            let distinctId = UUID().uuidString
            
            guard let data = distinctId.data(using: .utf8) else {
                return nil
            }
            
            try Keychain.set(data)
            
            return distinctId
        } catch {
            track(.error(error))
            debugPrint(error)
        }
        
        return nil
    }()
    
    public init(token: String?) {
        self.token = token
    }
    
    public func configure() {
        guard let token else {
            return
        }
        
        mixpanel = Mixpanel.initialize(token: token, flushInterval: 15)
        
        if let distinctId {
            mixpanel?.identify(distinctId: distinctId, usePeople: true)
        }
    }
    
    public func setUserSettings(_ properties: Properties) {
        guard let mixpanel, distinctId != nil else {
            return
        }
        
        mixpanel.people.set(properties: properties)
    }
    
    public func track(_ event: Event, sendImmediately: Bool = false) {
        guard let mixpanel else {
            return
        }
        
        mixpanel.track(event: event.name, properties: event.properties)
        
        if sendImmediately {
            mixpanel.flush()
        }
    }
}
