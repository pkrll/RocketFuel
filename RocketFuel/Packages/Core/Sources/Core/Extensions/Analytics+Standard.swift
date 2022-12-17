//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Analytics
import Foundation

extension Analytics {
#if DEBUG
    static let standard = Analytics(token: nil)
#else
    static let standard = Analytics(token: "")
#endif
}
