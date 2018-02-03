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
//fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l < r
//  case (nil, _?):
//    return true
//  default:
//    return false
//  }
//}
//
//// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
//// Consider refactoring the code to use the non-optional operators.
//fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l <= r
//  default:
//    return !(rhs < lhs)
//  }
//}

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

  // --------------------------------------------
  // MARK: - Private Properties
  // --------------------------------------------
  
  /**
   *  Defines the minimum battery level.
   */
  fileprivate(set) var minimumBatteryLevel: Int = 0
  /**
   *  Determines if the application should stop when switching to battery power.
   */
  fileprivate(set) var shouldStopOnBatteryMode: Bool = false
  /**
   *  Set to true when activated while the computer is on battery mode.
   *
   *  This is used to prevent Rocket Fuel from deactivating if the user turns on the app while in battery mode.
   */
  fileprivate var didStopDuringBatteryMode: Bool = false;
  /**
   *  The current battery charge
   */
  fileprivate var currentBatteryCharge: Int = 0
  /**
   *  Determines if the computer is on battery or AC power.
   */
  fileprivate var onBatteryPower: Bool = false
  
  // --------------------------------------------
  // MARK: - Public Methods
  // --------------------------------------------
  
  /**
   *  Sets the battery level at which to deactivate Rocket Fuel.
   *
   *  - Parameter atBatteryLevel: The minimum battery level
   */
  func shouldDeactivate(atBatteryLevel batteryLevel: Int) {
    self.shouldDeactivate(atBatteryLevel: batteryLevel, onBatteryMode: self.shouldStopOnBatteryMode)
  }
  /**
   *  Toggles whether Rocket Fuel should deactivate when changing power source to battery.
   *
   *  - Parameter onBatteryMode: If true, Rocket Fuel will deactivate when power source changes to battery.
   */
  func shouldDeactivate(onBatteryMode value: Bool) {
    self.shouldDeactivate(atBatteryLevel: self.minimumBatteryLevel, onBatteryMode: value)
  }
  /**
   *  Set the battery level at which to deactivate Rocket Fuel, and whether it should deactivate when changing power source to battery.
   *
   *  - Parameter atBatteryLevel: The minimum battery level
   *  - Parameter onBatteryMode:  If true, Rocket Fuel will deactivate when power source changes to battery.
   */
  func shouldDeactivate(atBatteryLevel batteryLevel: Int, onBatteryMode value: Bool) {
    self.minimumBatteryLevel = batteryLevel
    self.shouldStopOnBatteryMode = value

    if self.isActive {
      self.retrievePowerSourceInformation()
      
      if self.onBatteryPower {
        self.didStopDuringBatteryMode = true
      }
      
      self.removeNotificationRunLoopSource()
      self.beginMonitorBatteryLevel()
    } else {
      self.didStopDuringBatteryMode = false
      self.removeNotificationRunLoopSource()
    }
  }
  
  // --------------------------------------------
  // MARK: - Internal Methods
  // --------------------------------------------
  
  /**
   *  Begins monitoring battery level changes.
   *
   *  This method will create a Run Loop Source that notifies when a power source information change has been made.
   */
  internal func beginMonitorBatteryLevel() {
    guard self.minimumBatteryLevel > 0 else { return }

    let powerSourceCallback: IOPowerSourceCallbackType = { context in
      let this = Unmanaged<RocketFuel>.fromOpaque(UnsafeRawPointer(context)!).takeUnretainedValue()
      this.retrievePowerSourceInformation()
      this.checkPowerSource()
      this.checkBatteryLevel()
    }
    // Get notifications on power source updates
    let this = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
    self.notificationRunLoopSource = IOPSNotificationCreateRunLoopSource(powerSourceCallback, this).takeUnretainedValue()
    CFRunLoopAddSource(CFRunLoopGetCurrent(), self.notificationRunLoopSource, CFRunLoopMode.defaultMode)
  }
  /**
   *  Removes the IOPS Notification Run Loop Source.
   */
  internal func removeNotificationRunLoopSource() {
    if let runLoopSource = self.notificationRunLoopSource {
      CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, CFRunLoopMode.defaultMode)
      self.notificationRunLoopSource = nil
    }
  }

  // --------------------------------------------
  // MARK: - Private Methods
  // --------------------------------------------

  /**
   *  Checks the battery level. If it is below the minimum level allowed, Rocket Fuel will stop.
   */
  fileprivate func checkBatteryLevel() {
    // If on AC power the battery limit should not matter.
    guard self.onBatteryPower else { return }

    if self.currentBatteryCharge <= self.minimumBatteryLevel  {
      self.deactivate()
    }
  }
  /**
   *  Checks the power source. If the power source is battery (and the application was not activated during battery mode) Rocket Fuel will stop.
   */
  fileprivate func checkPowerSource() {
    guard self.isActive && self.onBatteryPower && !self.didStopDuringBatteryMode else { return }

    if self.shouldStopOnBatteryMode {
      self.didStopDuringBatteryMode = true
      self.deactivate()
    }
  }
  /**
   *  Retrieves information on the power source.
   */
  fileprivate func retrievePowerSourceInformation() {
    self.onBatteryPower = PowerSource.onBatteryPower

    if self.onBatteryPower {
      self.currentBatteryCharge = PowerSource.currentCharge ?? 0
    } else {
      self.currentBatteryCharge = 0
      self.didStopDuringBatteryMode = false
    }
  }
  
}
