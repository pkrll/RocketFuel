//
//  RocketFuel.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 23/12/15.
//  Copyright © 2015 Ardalan Samimi. All rights reserved.
//

import Foundation

class RocketFuel: NSObject {
  
  internal var delegate: RocketFuelDelegate?
  
  internal var duration: Double = 0
  
  internal var isActive: Bool {
    return self.task?.running ?? false
  }
  
  private var task: NSTask?
  
  private var relaunch: Bool = false
  
  private var active: Bool {
    get {
      return self.isActive
    }
    set (mode) {
      self.delegate?.rocketFuel(self, didChangeStatus: mode)
    }
  }
  
  private var arguments: [String] {
    var argument: String = "-di"
    
    if self.duration > 0 {
      argument = "-dit \(self.duration)"
    }
    
    return [argument]
  }
  
  func toggle() {
    if (self.task == nil) {
      self.activate()
    } else {
      self.relaunch = false
      self.terminate()
    }
  }
  
  func activate() {
    self.task = NSTask.launchedTaskWithLaunchPath(Global.caffeinatePath, arguments: self.arguments)
    self.task?.terminationHandler = { task in
      self.didTerminate()
      // Tells RocketFuel to relaunch the task upon termination. Necessary when changing duration.
      if self.relaunch {
        self.activate()
        self.relaunch = false
      }
    }
    
    self.active = self.isActive
  }
  
  func activate(withDuration duration: Double) {
    self.duration = duration
    
    if self.task == nil {
      self.activate()
    } else {
      self.relaunch = true
      self.terminate()
      // Make sure the post termination cleanup method is called. Termination handler of NSTask does not always do that.
      self.didTerminate()
    }
    
  }
  
  func terminate() {
    if self.isActive {
      self.task?.terminate()
    } else {
      self.didTerminate()
    }
  }
  
  func didTerminate() {
    self.task = nil
    self.active = self.isActive
  }

}