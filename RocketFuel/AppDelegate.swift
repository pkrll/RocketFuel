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
  
  func applicationWillTerminate(aNotification: NSNotification) {
    Preferences.save(self.statusItemController.rocketFuel.isActive, forKey: PreferencesType.LastApplicationState)
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
    self.statusItemController.shouldDeactivateOnBatteryLevel = level
  }

}