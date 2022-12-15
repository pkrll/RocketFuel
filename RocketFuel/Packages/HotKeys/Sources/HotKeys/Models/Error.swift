//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Carbon

public enum Error: Swift.Error {
    static func from(status: OSStatus) -> Self {
        if status == eventHotKeyExistsErr {
            return .hotKeyExists
        }
        
        return .unknown(status)
    }
    
    case hotKeyExists
    case unknown(OSStatus)
}
