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
  
  func addApplicationToLoginItems(_ mode: Bool) -> Bool {
    return SMLoginItemSetEnabled("com.ardalansamimi.RocketFuelHelper" as CFString, mode)
  }
  
}
