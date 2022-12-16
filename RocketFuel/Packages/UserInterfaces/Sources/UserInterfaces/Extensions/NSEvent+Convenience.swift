//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Carbon
import Cocoa

extension NSEvent {
    var readableCharacter: String? {
        let keyCode = Int(keyCode)
        let character: String?
        
        switch keyCode {
        case kVK_F1:
            character = "F1"
        case kVK_F2:
            character = "F2"
        case kVK_F3:
            character = "F3"
        case kVK_F4:
            character = "F4"
        case kVK_F5:
            character = "F5"
        case kVK_F6:
            character = "F6"
        case kVK_F7:
            character = "F7"
        case kVK_F8:
            character = "F8"
        case kVK_F9:
            character = "F9"
        case kVK_F10:
            character = "F10"
        case kVK_F11:
            character = "F11"
        case kVK_F12:
            character = "F12"
        default:
            character = charactersIgnoringModifiers
        }
        
        return character
    }
}
