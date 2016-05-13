//
//  AppDelegate.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 22/12/15.
//  Copyright © 2015 Ardalan Samimi. All rights reserved.
//
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  private var statusItemController: StatusItemController!
  
  internal var isActive: Int {
    return Int(self.statusItemController.isActive)
  }
  
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    self.loadStatusItemController()
  }
  
  func applicationWillTerminate(aNotification: NSNotification) {
    self.statusItemController.requestTermination()
  }
  
  func applicationShouldChangeState() {
    self.loadStatusItemController()
    
    if self.statusItemController.isActive {
      self.statusItemController.requestTermination()
    } else {
      self.statusItemController.requestActivation()
    }
  }
  
  func applicationShouldActivateWithDuration(duration: Double) {
    self.loadStatusItemController()
    self.statusItemController.requestActivation(duration)
  }
  
  func loadStatusItemController() {
    if self.statusItemController == nil {
      self.statusItemController = StatusItemController()
    }
  }
  
}