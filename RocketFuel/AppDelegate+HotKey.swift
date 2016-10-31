//
//  AppDelegate+HotKey.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 17/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Foundation

extension AppDelegate {
  
  func applicationShouldLoadHotKey() {
    if let hotKeyDict = Preferences.dictionary(forKey: PreferencesType.ActivationHotKey) {
      if let keyCode = hotKeyDict.value(forKey: "keyCode") as? Int {
        let modifierFlags = hotKeyDict.value(forKey: "modifierFlags") as? Int ?? 0
        let readable = hotKeyDict.value(forKey: "readable") as? String ?? ""
        self.activationHotKey = HotKey(keyCode: keyCode, modifier: modifierFlags, readable: readable, action: self.applicationShouldChangeState)
        HotKeyCenter.sharedManager.register(self.activationHotKey)
      }
    }
  }
  
  func applicationShouldRegisterHotKey(_ hotKey: HotKey) {
    HotKeyCenter.sharedManager.unregister(self.activationHotKey)
    
    if hotKey.keyCode > -1 {
      hotKey.action = self.applicationShouldChangeState
      HotKeyCenter.sharedManager.register(hotKey)
      
      let dict = NSDictionary(dictionary: ["keyCode": NSNumber(value: hotKey.keyCode as Int), "modifierFlags": NSNumber(value: hotKey.modifier as Int), "readable": hotKey.readable])
      
      Preferences.save(dict, forKey: PreferencesType.ActivationHotKey)
    } else {
      Preferences.remove(PreferencesType.ActivationHotKey)
    }
  }
  
}
