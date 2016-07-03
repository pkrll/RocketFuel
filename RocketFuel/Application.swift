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
  
  internal var isActivated: Int {
//    let delegate: AppDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
//    return delegate.isActive
    return 0
  }
  
}
