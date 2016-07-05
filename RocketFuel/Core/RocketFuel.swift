//
//  RocketFuel.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 01/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa

class RocketFuel {
  
  // --------------------------------------------
  // MARK: - Public Properties
  // --------------------------------------------
  
  static let defaultManager = RocketFuel()
  
  var delegate: RocketFuelDelegate?
  
  var assertionID: IOPMAssertionID = IOPMAssertionID(0)
  
  var assertion: IOReturn = 0
  
  var notificationRunLoopSource: CFRunLoopSource?
  
  var durationTimer: NSTimer?
  /**
   *  The timeout for the assertion.
   */
  var timeout: Double = 0
  
  var isActive: Bool {
    return (self.assertionID != IOPMAssertionID(0))
  }
  
  var shouldStopAtBatteryLevel: Int {
    get {
      return self.minimumBatteryLevel
    }
    set {
      self.minimumBatteryLevel = newValue

      guard newValue > 0 else {
        self.removeNotificationRunLoopSource()
        return
      }

      self.beginMonitorBatteryLevel()
    }
  }
  
  // --------------------------------------------
  // MARK: - Private Properties
  // --------------------------------------------
  
  private var minimumBatteryLevel: Int = 0
  
  // --------------------------------------------
  // MARK: - Private Methods
  // --------------------------------------------

  private func beginMonitorBatteryLevel() {
    self.removeNotificationRunLoopSource()
  
    let powerSourceCallback: IOPowerSourceCallbackType = { context in
      let this = Unmanaged<RocketFuel>.fromOpaque(COpaquePointer(context)).takeRetainedValue()
      this.checkBatteryLevel()
    }
    // Get notifications on power source updates
    let this = UnsafeMutablePointer<Void>(Unmanaged.passUnretained(self).toOpaque())
    self.notificationRunLoopSource = IOPSNotificationCreateRunLoopSource(powerSourceCallback, this).takeRetainedValue()
    CFRunLoopAddSource(CFRunLoopGetCurrent(), notificationRunLoopSource, kCFRunLoopDefaultMode)
  }
  
  private func checkBatteryLevel() {
    print("Checking battery level...")
    
    if Battery.currentCharge <= self.minimumBatteryLevel {
      self.stop()
      self.removeNotificationRunLoopSource()
    }
  }
  
  private func removeNotificationRunLoopSource() {
    if self.notificationRunLoopSource != nil {
      CFRunLoopRemoveSource(CFRunLoopGetCurrent(), self.notificationRunLoopSource, kCFRunLoopDefaultMode)
    }
  }

  
}
