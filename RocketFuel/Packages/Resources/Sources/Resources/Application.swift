//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation

public enum Application {
    public static var applicationDisplayName: String {
        Bundle.main.displayName ?? "Rocket Fuel"
    }
    public static var versionString: String {
        Bundle.main.shortVersionString ?? "2"
    }
    public static var appScheme: String {
#if DEBUG
        return "rocketfuel-debug"
#else
        return "rocketfuel"
#endif
    }
    public static var hasDeveloperSettings: Bool {
#if DEBUG
        return true
#else
        return ConfigurationProfile.isInstalled
#endif
    }
}
