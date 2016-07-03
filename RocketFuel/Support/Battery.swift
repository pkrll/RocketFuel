//
//  Battery.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 03/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Foundation

struct Battery {
  
  static var currentCharge: Int? {
    let blob = IOPSCopyPowerSourcesInfo().takeUnretainedValue()
    let sources = IOPSCopyPowerSourcesList(blob).takeUnretainedValue() as Array
    
    for source in sources {
      let description = IOPSGetPowerSourceDescription(blob, source).takeUnretainedValue() as Dictionary
      
      if let currentCapacity = description[kIOPSCurrentCapacityKey] as? Double, let maxCapacity = description[kIOPSMaxCapacityKey] as? Double {
        return Int((currentCapacity / maxCapacity) * 100.0)
      }
    }
    
    return nil
  }
  
}