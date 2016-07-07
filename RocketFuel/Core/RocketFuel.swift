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
  var durationTimer: NSTimer?
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
  
  /**
   *  Defines the minimum battery level.
   */
  private var minimumBatteryLevel: Int = 0
  
  // --------------------------------------------
  // MARK: - Private Methods
  // --------------------------------------------
  
  /**
   *  Begins monitoring battery level changes.
   * 
   *  This method will create a Run Loop Source that notifies when a power source information change has been made.
   */
  private func beginMonitorBatteryLevel() {
    self.removeNotificationRunLoopSource()
  
    let powerSourceCallback: IOPowerSourceCallbackType = { context in
      let this = Unmanaged<RocketFuel>.fromOpaque(COpaquePointer(context)).takeUnretainedValue()
      this.checkBatteryLevel()
    }
    // Get notifications on power source updates
    let this = UnsafeMutablePointer<Void>(Unmanaged.passUnretained(self).toOpaque())
    self.notificationRunLoopSource = IOPSNotificationCreateRunLoopSource(powerSourceCallback, this).takeUnretainedValue()
    CFRunLoopAddSource(CFRunLoopGetCurrent(), notificationRunLoopSource, kCFRunLoopDefaultMode)
  }
  /**
   *  Checks the battery level. If it is below the minimum level allowed, Rocket Fuel will stop.
   */
  private func checkBatteryLevel() {
    print("Checking battery level...")
    print(self.minimumBatteryLevel)
    if Battery.currentCharge <= self.minimumBatteryLevel {
      self.stop()
      self.removeNotificationRunLoopSource()
    }
  }
  /**
   *  Removes the IOPS Notification Run Loop Source.
   */
  private func removeNotificationRunLoopSource() {
    if self.notificationRunLoopSource != nil {
      CFRunLoopRemoveSource(CFRunLoopGetCurrent(), self.notificationRunLoopSource, kCFRunLoopDefaultMode)
    }
  }

  
}
