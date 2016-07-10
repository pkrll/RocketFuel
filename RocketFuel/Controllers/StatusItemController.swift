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

  let rocketFuel: RocketFuel = RocketFuel()
  /**
   *  The about window.
   */
  var aboutWindowController: AboutWindowController?
  /**
   *  The preferences window.
   */
  var preferencesWindowController: PreferencesWindowController?
  /**
   *  Determines if the application should be started on system launch.
   */
  var shouldLaunchAtLogin: Bool {
    get {
      return Preferences.bool(forKey: .LaunchAtLogin)
    }
    set (mode) {
      let status = self.addApplicationToLoginItems(mode)
      
      if status {
        Preferences.save(mode, forKey: .LaunchAtLogin)
      }
    }
  }
  /**
   *  Toggles the left click activation mode.
   */
  var shouldActivateOnLeftClick: Bool {
    get {
      return Preferences.bool(forKey: .LeftClickActivation)
    }
    set (mode) {
      Preferences.save(mode, forKey: .LeftClickActivation)
    }
  }
  /**
   *  Determines if the application should deactivate when the system reaches a certain battery level.
   */
  var shouldDeactivateOnBatteryLevel: Int {
    get {
      return self.rocketFuel.shouldStopAtBatteryLevel
    }
    set (level) {
      self.rocketFuel.shouldStopAtBatteryLevel = level
    }
  }
  
  // --------------------------------------------
  // MARK: - Initialization
  // --------------------------------------------
  
  override init() {
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
        let level = Preferences.value(forKey: .StopAtBatteryLevel) as? Int ?? 0
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
