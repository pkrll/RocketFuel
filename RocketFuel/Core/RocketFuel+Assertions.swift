//
//  RocketFuel+Assertions.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 03/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Foundation

extension RocketFuel {
  
  func start(assertionType: AssertionType, duration: Double = 0, stopAtBatteryLevel: Int = 0) -> Bool {
    guard self.createAssertion(ofType: assertionType) else { return false }
    
    if duration > 0 {
      self.durationTimer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: #selector(self.stop), userInfo: nil, repeats: false)
    }
    
    if stopAtBatteryLevel > 0 {
      let powerSourceCallback: IOPowerSourceCallbackType = { context in
        let this = Unmanaged<RocketFuel>.fromOpaque(COpaquePointer(context)).takeRetainedValue()
        this.checkBatteryLevel()
      }
      // Get notifications on power source updates
      let this = UnsafeMutablePointer<Void>(Unmanaged.passUnretained(self).toOpaque())
      self.notificationRunLoopSource = IOPSNotificationCreateRunLoopSource(powerSourceCallback, this).takeRetainedValue()
      CFRunLoopAddSource(CFRunLoopGetCurrent(), notificationRunLoopSource, kCFRunLoopDefaultMode)
    }
    
    return true
  }
 
  @objc func stop() {
    self.assertion = IOPMAssertionRelease(self.assertionID)
    
    guard let _ = self.durationTimer else { return }
    self.durationTimer?.invalidate()
    self.durationTimer = nil
  }
  
  func createAssertion(ofType type: AssertionType) -> Bool {
    var assertionType: CFString
    switch type {
      case .PreventIdleSystemSleep:
        assertionType = kIOPMAssertPreventUserIdleSystemSleep
      case .PreventIdleDisplaySleep:
        assertionType = kIOPMAssertPreventUserIdleDisplaySleep
    }
    
    self.assertion = IOPMAssertionCreateWithName(assertionType, UInt32(kIOPMAssertionLevelOn), "Rocket Fuel is active", &self.assertionID)

    return self.assertion == kIOReturnSuccess
  }
  
  func checkBatteryLevel() {
    print("Checking battery level...")
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let batteryLevel = userDefaults.integerForKey("batteryLevelThreshold")
    
    if Battery.currentCharge <= batteryLevel {
      self.stop()
      CFRunLoopRemoveSource(CFRunLoopGetCurrent(), self.notificationRunLoopSource, kCFRunLoopDefaultMode)
    }
  }
  
}