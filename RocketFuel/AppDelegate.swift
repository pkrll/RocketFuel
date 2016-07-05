//
//  AppDelegate.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 22/12/15.
//  Copyright © 2015 Ardalan Samimi. All rights reserved.
//
import Cocoa
import ServiceManagement

// IOPS notification callback on power source change


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  var statusItemController: StatusItemController?
  
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    self.loadStatusItem()
  }
  
  func applicationWillTerminate(aNotification: NSNotification) {
    
  }
  
  func applicationShouldChangeState() {
    self.loadStatusItem()
    
    if RocketFuel.defaultManager.isActive {
      self.statusItemController?.request(.Termination)
    } else {
      self.statusItemController?.request(.Activation)
    }
  }
  
  func applicationShouldActivateWithDuration(duration: Double) {
    self.loadStatusItem()
    self.statusItemController?.request(.Activation, withDuration: duration)
  }
  
  private func loadStatusItem() {
    if self.statusItemController == nil {
      self.statusItemController = StatusItemController()
    }
  }
  
}