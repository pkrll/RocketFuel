//
//  RocketFuel+Assertions.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 03/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Foundation

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
  func start(assertionType: AssertionType, duration: Double = 0, stopAtBatteryLevel: Int = 0) -> Bool {
    guard self.createAssertion(ofType: assertionType, withDuration: duration) else { return false }
    
    if duration > 0 {
      self.durationTimer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: #selector(self.stop), userInfo: nil, repeats: false)
    }
    
    self.shouldStopAtBatteryLevel = stopAtBatteryLevel
    
    self.delegate?.rocketFuel(self, didChangeStatus: true)
    
    return true
  }
  /**
   *  Deactivate Rocket Fuel.
   */
  @objc func stop() {
    self.assertion = IOPMAssertionRelease(self.assertionID)
    self.assertionID = IOPMAssertionID(0)
    self.delegate?.rocketFuel(self, didChangeStatus: false)
    
    if self.durationTimer != nil {
      self.durationTimer?.invalidate()
      self.durationTimer = nil
    }

    self.shouldStopAtBatteryLevel = 0
  }
  
  // --------------------------------------------
  // MARK: - Private Methods
  // --------------------------------------------
  
  /**
   *  Creates an assertion.
   */
  private func createAssertion(ofType type: AssertionType, withDuration duration: Double) -> Bool {
    if self.isActive {
      self.stop()
    }
    
    self.timeout = duration
    
    var assertionType: CFString
    switch type {
      case .PreventIdleSystemSleep:
        assertionType = kIOPMAssertPreventUserIdleSystemSleep
      case .PreventIdleDisplaySleep:
        assertionType = kIOPMAssertPreventUserIdleDisplaySleep
    }
    
    self.assertion = IOPMAssertionCreateWithDescription(assertionType, "Rocket Fuel", nil, nil, nil, duration, kIOPMAssertionTimeoutActionRelease, &self.assertionID)
    
    return self.assertion == kIOReturnSuccess
  }

}