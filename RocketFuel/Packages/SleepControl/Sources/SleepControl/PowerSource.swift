//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation

public struct PowerSource {
    public enum Error: Swift.Error {
        case noPowerSources
    }
    
    public static var currentCharge: Int {
        get throws {
            let blob = IOPSCopyPowerSourcesInfo().takeRetainedValue()
            let sources = IOPSCopyPowerSourcesList(blob).takeRetainedValue() as Array
            
            for source in sources {
                let description = IOPSGetPowerSourceDescription(blob, source).takeUnretainedValue() as NSDictionary
                
                guard let currentCapacity = description[kIOPSCurrentCapacityKey] as? Double,
                      let maxCapacity = description[kIOPSMaxCapacityKey] as? Double
                else {
                    continue
                }
                
                let currentCharge = Int((currentCapacity / maxCapacity) * 100.0)
                return currentCharge
            }
            
            throw Error.noPowerSources
        }
    }
    
    public static var onBatteryPower: Bool {
        let blob = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(blob).takeRetainedValue() as Array
        
        for source in sources {
            let description = IOPSGetPowerSourceDescription(blob, source).takeUnretainedValue() as NSDictionary
            
            guard let powerSource = description[kIOPSPowerSourceStateKey] as? String else {
                continue
            }
            
            let isOnBatteryPower = powerSource == kIOPSBatteryPowerValue
            return isOnBatteryPower
        }
        
        return false
    }    
}
