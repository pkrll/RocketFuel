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
  var activationHotKey: HotKey?
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    Preferences.registerDefaults()
    self.applicationShouldLoadHotKey()
  }
  
  func applicationShouldChangeState() {
    if self.statusItemController.rocketFuel.isActive {
      self.statusItemController.request(.termination)
    } else {
      self.statusItemController.request(.activation)
    }
  }
  
  func applicationShouldActivate(withDuration duration: Double) {
    self.statusItemController.request(.activation, withDuration: duration)
  }
  
  func applicationShouldDeactivate(atBatteryLevel level: Int) {
    // This function is called either from the Preferences Window or an apple script.
    Preferences.save(level as AnyObject, forKey: PreferencesType.StopAtBatteryLevel)
    self.statusItemController.shouldDeactivateOnBatteryLevel = level
  }
  
}
