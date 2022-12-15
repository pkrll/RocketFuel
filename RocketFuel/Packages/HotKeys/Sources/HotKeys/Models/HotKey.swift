//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Carbon

public struct HotKey {
    public let keyCode: Int
    public let modifier: Int
    public let readable: String
    public let action: (() -> Void)?
    var hotKeyRef: EventHotKeyRef?
    
    var id: Int { keyCode }
    
    public init(keyCode: Int, modifier: Int, readable: String, action: (() -> Void)?) {
        self.keyCode = keyCode
        self.modifier = modifier
        self.readable = readable
        self.action = action
    }
}
