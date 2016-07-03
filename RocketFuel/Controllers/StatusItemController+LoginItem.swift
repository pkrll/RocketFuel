//
//  StatusItemController+LoginItem.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 03/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa
import ServiceManagement

extension StatusItemController {
  
  func addApplicationToLoginItems(mode: Bool) -> Bool {
    let status = SMLoginItemSetEnabled("com.ardalansamimi.RocketFuelHelper", mode)
    
    if status {
      let defaults = NSUserDefaults.standardUserDefaults()
      defaults.setBool(mode, forKey: Preference.LaunchAtLogin.rawValue)
      defaults.synchronize()
    } else {
      let alert = NSAlert()
      alert.messageText = "An error occured. Rocket Fuel could not be added to the login items."
      alert.runModal()
    }
    
    return status
  }
  
}