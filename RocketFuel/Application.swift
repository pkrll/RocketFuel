//
//  Application.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 24/12/15.
//  Copyright © 2015 Ardalan Samimi. All rights reserved.
//
import Cocoa

@objc(Application)
class Application: NSApplication {
  
  @objc internal var isActivated: Int {
    return RocketFuel.defaultManager.isActive.intValue()
  }
  
}
