//
//  StatusItemController.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 01/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa

class StatusItemController: NSObject, MenuDelegate, RocketFuelDelegate, NSWindowDelegate {
  
  // --------------------------------------------
  // MARK: - Public Properties
  // --------------------------------------------
  
  /**
   *  The item that is displayed in the system status bar.
   */  
  let statusItem: NSStatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)

  let rocketFuel: RocketFuel!
  /**
   *  The about window.
   */
  var aboutWindowController: AboutWindowController?
  /**
   *  The preferences window.
   */
  var preferencesWindowController: PreferencesWindowController?
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
      defaults.synchronize()
    }
  }
  
  // --------------------------------------------
  // MARK: - Initialization
  // --------------------------------------------
  
  override init() {
    self.rocketFuel = RocketFuel()
    super.init()
    self.configureStatusItem()
    self.rocketFuel.delegate = self
  }
  
  // --------------------------------------------
  // MARK: - Activation / Termination Methods
  // --------------------------------------------
  
  /**
   *  Request activation or termination of Rocket Fuel.
   *
   *  - Parameter type: The request type.
   */
  func request(type: RequestType, withDuration duration: Double = 0) {
    switch type {
      case .Activation:
        let level = NSUserDefaults.standardUserDefaults().integerForKey(Preference.StopAtBatteryLevel.rawValue)
        self.rocketFuel.start(AssertionType.PreventIdleSystemSleep, duration: duration, stopAtBatteryLevel: level)
      case .Termination:
        self.rocketFuel.stop()
    }
  }
  /**
   *  Toggle Rocket Fuel state.
   */
  func toggleState() {
    let state: RequestType = (self.rocketFuel.isActive) ? .Termination : .Activation
    self.request(state, withDuration: self.rocketFuel.timeout)
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

  // --------------------------------------------
  // MARK: - Rocket Fuel Delegate Methods
  // --------------------------------------------
  
  func rocketFuel(_: RocketFuel, didChangeStatus mode: Bool) {
    self.statusItem.button?.image = self.imageForStatusIcon(forState: mode)
  }
  
}
