//
//  RocketFuel.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 01/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa

class RocketFuel {
  
  static let defaultManager = RocketFuel()
  
  var delegate: RocketFuelDelegate?
  
  var assertionID: IOPMAssertionID = IOPMAssertionID(0)
  
  var assertion: IOReturn = 0
  
  var notificationRunLoopSource: CFRunLoopSource?
  
  var durationTimer: NSTimer?
  
  var isActive: Bool {
    return false
  }
  
}
