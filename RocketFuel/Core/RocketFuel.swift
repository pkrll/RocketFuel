//
//  RocketFuel.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 01/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class RocketFuel {
  
  // --------------------------------------------
  // MARK: - Public Properties
  // --------------------------------------------
  
  /**
   *  The default manager.
   */
  static let defaultManager = RocketFuel()
  /**
   *  The delegate.
   */
  var delegate: RocketFuelDelegate?
  /**
   *  The assertion id.
   */
  var assertionID: IOPMAssertionID = IOPMAssertionID(0)
  /**
   *  The assertion status.
   */
  var assertion: IOReturn = 0
  /**
   *  The timer for the assertion.
   */
  var durationTimer: Timer?
  /**
   *  The timeout for the assertion.
   */
  var timeout: Double = 0
  /**
   *  The run loop for the power source call back.
   */
  var notificationRunLoopSource: CFRunLoopSource?
  /**
   *  Returns true if Rocket Fuel is activated.
   */
  var isActive: Bool {
    return (self.assertionID != IOPMAssertionID(0))
  }
  /**
   *  If set Rocket Fuel will stop when the battery charge is below the specified level.
   */
  var shouldStopAtBatteryLevel: Int {
    get {
      return self.minimumBatteryLevel
    }
    set {
      self.minimumBatteryLevel = newValue
      self.removeNotificationRunLoopSource()
      self.beginMonitorBatteryLevel()
    }
  }
  
  // --------------------------------------------
  // MARK: - Private Properties
  // --------------------------------------------
  
  /**
   *  Defines the minimum battery level.
   */
  fileprivate var minimumBatteryLevel: Int = 0
  
  // --------------------------------------------
  // MARK: - Private Methods
  // --------------------------------------------
  
  /**
   *  Begins monitoring battery level changes.
   * 
   *  This method will create a Run Loop Source that notifies when a power source information change has been made.
   */
  fileprivate func beginMonitorBatteryLevel() {
    guard self.minimumBatteryLevel > 0 else { return }

    let powerSourceCallback: IOPowerSourceCallbackType = { context in
      let this = Unmanaged<RocketFuel>.fromOpaque(UnsafeRawPointer(context)!).takeUnretainedValue()
      this.checkBatteryLevel()
    }
    // Get notifications on power source updates
    let this = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
    self.notificationRunLoopSource = IOPSNotificationCreateRunLoopSource(powerSourceCallback, this).takeUnretainedValue()
    CFRunLoopAddSource(CFRunLoopGetCurrent(), self.notificationRunLoopSource, CFRunLoopMode.defaultMode)
  }
  /**
   *  Checks the battery level. If it is below the minimum level allowed, Rocket Fuel will stop.
   */
  fileprivate func checkBatteryLevel() {
    // If on AC power the battery limit should not matter.
    guard IOPSGetTimeRemainingEstimate() > -2 else { return }
    
    if Battery.currentCharge <= self.minimumBatteryLevel  {
      self.stop()
    }
  }
  /**
   *  Removes the IOPS Notification Run Loop Source.
   */
  fileprivate func removeNotificationRunLoopSource() {
    if let runLoopSource = self.notificationRunLoopSource {
      CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, CFRunLoopMode.defaultMode)
      self.notificationRunLoopSource = nil
    }
  }

}
