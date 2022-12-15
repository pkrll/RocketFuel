//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation

extension Menu {
    public enum Item {
        case button(
            title: String,
            selected: Bool = false,
            keyEquivalent: String = "",
            children: [Self]? = nil,
            action: (() async -> Void)? = nil
        )
        case separator
    }
}
