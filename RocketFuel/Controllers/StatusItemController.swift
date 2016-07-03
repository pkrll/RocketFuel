//
//  StatusItemController.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 01/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa

enum RequestType: Int {

  case Activation, Termination

}

class StatusItemController: NSObject, NSMenuDelegate {
  
  // --------------------------------------------
  // MARK: - Public Properties
  // --------------------------------------------
  
  /**
   *  The item that is displayed in the system status bar.
   */
  let statusItem: NSStatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)
  /**
   *  The RocketFuel Default Manager.
   */
  let rocketFuel: RocketFuel = RocketFuel.defaultManager
  /**
   *  Determines if the application should be started on launch.
   */
  var shouldLaunchAtLogin: Bool {
    get {
      return NSUserDefaults.standardUserDefaults().boolForKey(Preference.LaunchAtLogin.rawValue)
    }
    set (mode) {
      self.addApplicationToLoginItems(mode)
    }
  }
  /**
   *  Toggles the left click activation mode.
   */
  var shouldActivateOnLeftClick: Bool {
    get {
      return NSUserDefaults.standardUserDefaults().boolForKey(Preference.LeftClickActivation.rawValue)
    }
    set (mode) {
      let defaults = NSUserDefaults.standardUserDefaults()
      defaults.setBool(mode, forKey: Preference.LeftClickActivation.rawValue)
    }
  }
  
  // --------------------------------------------
  // MARK: - Initialization
  // --------------------------------------------
  
  override init() {
    super.init()
  }
  
  // --------------------------------------------
  // MARK: - Activation / Termination Methods
  // --------------------------------------------
  
  /**
   *  Request activation or termination of Rocket Fuel.
   *
   *  - Parameter type: The request type.
   */
  func request(type: RequestType) {
    switch type {
      case .Activation:
        break
      case .Termination:
        break
    }
  }
  /**
   *  Toggle Rocket Fuel state.
   */
  func toggleState() {
    let state: RequestType = (RocketFuel.defaultManager.isActive) ? .Termination : .Activation
    self.request(state)
  }
  /**
   *  Terminates the app.
   */
  func terminate() {
    if self.rocketFuel.isActive {
      self.rocketFuel.stop()
    }
    
    NSApp.terminate(self)
  }
  
}
