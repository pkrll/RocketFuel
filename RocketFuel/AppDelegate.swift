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
  
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    Preferences.registerDefaults()
    // Load hot key
    if let hotKeyDict = Preferences.value(forKey: PreferencesType.ActivationHotKey) as? NSDictionary {
      if let keyCode = hotKeyDict.valueForKey("keyCode") as? Int {
        let modifierFlags = hotKeyDict.valueForKey("modifierFlags") as? Int ?? 0
        let readable = hotKeyDict.valueForKey("readable") as? String ?? ""
        print(modifierFlags)
        self.activationHotKey = HotKey(keyCode: keyCode, modifier: modifierFlags, readable: readable, action: self.applicationShouldChangeState)
        HotKeyCenter.sharedManager.register(self.activationHotKey)
      }
    }
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
  
  func applicationShouldRegisterHotKey(hotKey: HotKey) {
    HotKeyCenter.sharedManager.unregister(self.activationHotKey)
    
    if hotKey.keyCode > -1 {
      hotKey.action = self.applicationShouldChangeState
      HotKeyCenter.sharedManager.register(hotKey)

      let dict = NSDictionary(dictionary: ["keyCode": NSNumber(integer: hotKey.keyCode), "modifierFlags": NSNumber(integer: hotKey.modifier), "readable": hotKey.readable])
      
      Preferences.save(dict, forKey: PreferencesType.ActivationHotKey)
    } else {
      Preferences.remove(PreferencesType.ActivationHotKey)
    }
  }
  
}