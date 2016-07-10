//
//  AppDelegate.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 22/12/15.
//  Copyright © 2015 Ardalan Samimi. All rights reserved.
//
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  var statusItemController: StatusItemController = StatusItemController()
  
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    Preferences.registerDefaults()
  }
  
  func applicationShouldChangeState() {
    if self.statusItemController.rocketFuel.isActive {
      self.statusItemController.request(.Termination)
    } else {
      self.statusItemController.request(.Activation)
    }
  }
  
  func applicationShouldActivate(withDuration duration: Double) {
    self.statusItemController.request(.Activation, withDuration: duration)
  }
  
  func applicationShouldDeactivate(atBatteryLevel level: Int) {
    // This function is called either from the Preferences Window or an apple script.
    Preferences.save(level, forKey: PreferencesType.StopAtBatteryLevel)
    self.statusItemController.shouldDeactivateOnBatteryLevel = level
  }

}