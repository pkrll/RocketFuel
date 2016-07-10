//
//  AppleScript.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 24/12/15.
//  Copyright © 2015 Ardalan Samimi. All rights reserved.
//
import Cocoa

@objc(AppleScript)
class AppleScript: NSScriptCommand {
  
  private var appDelegate: AppDelegate {
    return NSApplication.sharedApplication().delegate as! AppDelegate
  }
  
  func toggle() {
    self.appDelegate.applicationShouldChangeState()
  }
  
  func duration() {
    // The duration is expressed in minutes in AppleScript, but seconds in the app, so it needs to be translated to seconds to work correctly.
    let duration: Double = self.directParameter!.doubleValue * 60
    self.appDelegate.applicationShouldActivate(withDuration: duration)
  }
  
  func batteryLevel() {
    let level: Int = self.directParameter! as? Int ?? 0
    self.appDelegate.applicationShouldDeactivate(atBatteryLevel: level)
  }
  
  override func performDefaultImplementation() -> AnyObject? {
    let command = NSSelectorFromString(self.commandDescription.commandName)
    // Make sure the command was valid
    if self.respondsToSelector(command) {
      let imp: IMP = self.methodForSelector(command)
      typealias function = @convention(c) (AnyObject, Selector) -> Void
      let curriedImplementation = unsafeBitCast(imp, function.self)
      curriedImplementation(self, command)
    }
    
    return false
  }
  
}