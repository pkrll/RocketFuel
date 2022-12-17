//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation
import Resources

public enum Application {
    public static var applicationDisplayName: String {
        Bundle.main.displayName ?? "Rocket Fuel"
    }
    public static var versionString: String {
        Bundle.main.shortVersionString ?? "2"
    }
    public static let copyrightText = "Copyright © 2022 Ardalan Samimi. All rights reserved."
    public static var appScheme: String {
        #if DEBUG
        return "rocketfuel-debug"
        #else
        return "rocketfuel"
        #endif
    }
}