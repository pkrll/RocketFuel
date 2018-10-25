//
//  RocketFuel+Assertions.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 03/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Foundation
import UserNotifications

extension RocketFuel {

  // --------------------------------------------
  // MARK: - Public Methods
  // --------------------------------------------

  /**
   *  Activate Rocket Fuel.
   *
   *  Creates a PM assertion.
   *
   *  - Parameters:
   *    - assertionType: The type of the assertion.
   *    - duration: The duration of the assertion.
   *    - stopAtBatteryLevel: The minimum battery level before releasing the assertion.
   */
  func start(_ assertionType: AssertionType, duration: Double = 0, stopAtBatteryLevel: Int = 0, stopOnBatteryMode: Bool = false) -> Bool {
    guard self.createAssertion(ofType: assertionType, withDuration: duration) else { return false }

    if duration > 0 {
      self.durationTimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(self.timerDidExpire), userInfo: nil, repeats: false)
    }

    self.shouldDeactivate(atBatteryLevel: stopAtBatteryLevel, onBatteryMode: stopOnBatteryMode)

    self.delegate?.rocketFuel(self, didChangeStatus: true)

    return true
  }
  
  @objc func timerDidExpire() {
    let title   = "Saturn Five is no longer running"
    var message = "Saturn Five has deactivated"
    
    if self.timeout > 0 {
      let timeout = Int(self.timeout / 60)
      message += " after \(timeout) minutes"
    }

    self.showNotification(withTitle: title, andMessage: message)
    self.deactivate()
  }
  
  /**
   *  Deactivate Rocket Fuel.
   */
  @objc func deactivate() {
    self.assertion = IOPMAssertionRelease(self.assertionID)
    self.assertionID = IOPMAssertionID(0)
    self.delegate?.rocketFuel(self, didChangeStatus: false)

    if self.durationTimer != nil {
      self.durationTimer?.invalidate()
      self.durationTimer = nil
    }

    self.shouldDeactivate(atBatteryLevel: 0, onBatteryMode: false)
  }

  // --------------------------------------------
  // MARK: - Private Methods
  // --------------------------------------------

  /**
   *  Creates an assertion.
   */
  fileprivate func createAssertion(ofType type: AssertionType, withDuration duration: Double) -> Bool {
    if self.isActive {
      self.deactivate()
    }

    self.timeout = duration

    var assertionType: CFString
    switch type {
      case .preventIdleSystemSleep:
        assertionType = kIOPMAssertPreventUserIdleSystemSleep as CFString
      case .preventIdleDisplaySleep:
        assertionType = kIOPMAssertPreventUserIdleDisplaySleep as CFString
    }

    self.assertion = IOPMAssertionCreateWithDescription(assertionType, "Rocket Fuel" as CFString, nil, nil, nil, duration, kIOPMAssertionTimeoutActionRelease as CFString, &self.assertionID)

    return self.assertion == kIOReturnSuccess
  }

}
