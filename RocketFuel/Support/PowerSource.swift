//
//  Battery.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 03/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Foundation

struct PowerSource {

  static var currentCharge: Int? {
    let blob = IOPSCopyPowerSourcesInfo().takeRetainedValue()
    let sources = IOPSCopyPowerSourcesList(blob).takeRetainedValue() as Array

    for source in sources {
      let description = IOPSGetPowerSourceDescription(blob, source).takeUnretainedValue() as NSDictionary

      if let currentCapacity = description[kIOPSCurrentCapacityKey] as? Double, let maxCapacity = description[kIOPSMaxCapacityKey] as? Double {
        return Int((currentCapacity / maxCapacity) * 100.0)
      }
    }

    return nil
  }

  static var onBatteryPower: Bool {
    let blob = IOPSCopyPowerSourcesInfo().takeRetainedValue()
    let sources = IOPSCopyPowerSourcesList(blob).takeRetainedValue() as Array

    for source in sources {
      let description = IOPSGetPowerSourceDescription(blob, source).takeUnretainedValue() as NSDictionary

      if let powerSource = description[kIOPSPowerSourceStateKey] as? String {
        return powerSource == kIOPSBatteryPowerValue
      }
    }

    return false
  }

}
