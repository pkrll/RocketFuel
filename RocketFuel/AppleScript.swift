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

  fileprivate var appDelegate: AppDelegate {
    return NSApplication.shared.delegate as! AppDelegate
  }
  
  func Toggle() {
    self.appDelegate.applicationShouldChangeState()
  }
  
  func Duration() {
    // The duration is expressed in minutes in AppleScript, but seconds in the app, so it needs to be translated to seconds to work correctly.
    let duration: Double = ((self.directParameter as AnyObject).doubleValue ?? 0) * 60
    self.appDelegate.applicationShouldActivate(withDuration: duration)
  }
  
  func BatteryLevel() {
    let level: Int = self.directParameter as? Int ?? 0
    self.appDelegate.applicationShouldDeactivate(atBatteryLevel: level)
  }
  
  override func performDefaultImplementation() -> Any? {
    let commandName = self.commandDescription.commandName.components(separatedBy: " ").map { $0.capitalized }.joined(separator: "")
    let commandFunc = NSSelectorFromString(commandName)
    
    // Make sure the command was valid
    if self.responds(to: commandFunc) {
      let imp: IMP = self.method(for: commandFunc)
      typealias function = @convention(c) (AnyObject, Selector) -> Void
      let curriedImplementation = unsafeBitCast(imp, to: function.self)
      curriedImplementation(self, commandFunc)
    }
    
    return false
  }
  
}
