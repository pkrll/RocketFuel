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
    let defaultsPath = NSBundle.mainBundle().pathForResource("UserDefaults", ofType: "plist")
    let userDefaults = NSDictionary(contentsOfFile: defaultsPath!) as! [String: AnyObject]
    NSUserDefaults.standardUserDefaults().registerDefaults(userDefaults)
    NSUserDefaults.standardUserDefaults().synchronize()
  }
  
  static func value(forKey key: PreferencesType) -> AnyObject? {
    return NSUserDefaults.standardUserDefaults().valueForKey(key.rawValue)
  }
  
  static func bool(forKey key: PreferencesType) -> Bool {
    return NSUserDefaults.standardUserDefaults().boolForKey(key.rawValue)
  }
  
  static func save(value: AnyObject, forKey: PreferencesType) {
    NSUserDefaults.standardUserDefaults().setObject(value, forKey: forKey.rawValue)
    NSUserDefaults.standardUserDefaults().synchronize()
  }
  
  static func reset() {
    let domainName = Constants.bundleIdentifier
    NSUserDefaults.standardUserDefaults().removePersistentDomainForName(domainName)
  }
  
}