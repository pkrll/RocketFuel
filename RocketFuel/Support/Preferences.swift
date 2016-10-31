//
//  Preferences.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 10/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Foundation

struct Preferences {
  
  static func registerDefaults() {
    let defaultsPath = Bundle.main.path(forResource: "UserDefaults", ofType: "plist")
    let userDefaults = NSDictionary(contentsOfFile: defaultsPath!) as! [String: AnyObject]
    UserDefaults.standard.register(defaults: userDefaults)
    UserDefaults.standard.synchronize()
  }
  
  static func value(forKey key: PreferencesType) -> AnyObject? {
    return UserDefaults.standard.value(forKey: key.rawValue) as AnyObject?
  }
  
  static func bool(forKey key: PreferencesType) -> Bool {
    return UserDefaults.standard.bool(forKey: key.rawValue)
  }
  
  static func dictionary(forKey key: PreferencesType) -> NSDictionary? {
    return Preferences.value(forKey: key) as? NSDictionary
  }
  
  static func save(_ value: AnyObject, forKey: PreferencesType) {
    UserDefaults.standard.set(value, forKey: forKey.rawValue)
    UserDefaults.standard.synchronize()
  }
  
  static func remove(_ key: PreferencesType) {
    UserDefaults.standard.removeObject(forKey: key.rawValue)
    UserDefaults.standard.synchronize()
  }
  
  static func reset() {
    let domainName = Constants.bundleIdentifier
    UserDefaults.standard.removePersistentDomain(forName: domainName)
  }
  
}
