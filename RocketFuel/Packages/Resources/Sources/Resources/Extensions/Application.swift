//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation

public enum Application {
    public static var applicationDisplayName: String {
        Bundle.main.displayName ?? "Rocket Fuel"
    }
    public static var versionString: String {
        guard let version = Bundle.main.shortVersionString else {
            return "2"
        }
        
        guard hasDeveloperSettings,
              let buildNumber = Bundle.main.buildNumber
        else {
            return version
        }
        
        return "\(version) (\(buildNumber))"
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

extension Application {
    public struct Version {
        public static let current = Self(string: Application.versionString)
        private static let delimiter = "."
        private let components: [Int]
        
        public init(string: String) {
            components = string.components(separatedBy: Self.delimiter).compactMap(Int.init)
        }
        
        public func lessOrEqual(to other: Version) -> Bool {
            lessOrEqual(components, other.components)
        }
        
        private func lessOrEqual(_ lhs: [Int], _ rhs: [Int]) -> Bool {
            if lhs.count == 0 && rhs.count == 0 {
                return true
            }
            
            let lhsComparision = lhs.first ?? 0
            let rhsComparision = rhs.first ?? 0
            
            guard lhsComparision == rhsComparision else {
                return lhsComparision <= rhsComparision
            }
            
            let version = Array(lhs.dropFirst())
            let otherVersion = Array(rhs.dropFirst())
            
            return lessOrEqual(version, otherVersion)
        }
    }
}
