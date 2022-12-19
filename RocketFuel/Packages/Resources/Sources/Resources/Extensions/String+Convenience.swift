//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation

public extension String {
    static func localized(key: String) -> Self {
        NSLocalizedString(key, bundle: .module, comment: "")
    }
    
    static func localized(key: String, arguments: CVarArg...) -> Self {
        let format = NSLocalizedString(key, bundle: .module, comment: "")
        let string = Self.localizedStringWithFormat(format, arguments)
        
        return string
    }
}
