//
//  PreferencesWindowController.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 05/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa

class PreferencesWindowController: NSWindowController {
  
  @IBOutlet var batteryLevelPopUpButton: NSPopUpButton!

  @IBAction func batteryLevelPopUpButtonDidChange(sender: AnyObject) {
    let defaults = NSUserDefaults.standardUserDefaults()
    let threshold = self.batteryLevelPopUpButton.selectedTag()
    defaults.setInteger(threshold, forKey: Preference.StopAtBatteryLevel.rawValue)
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    let defaults = NSUserDefaults.standardUserDefaults()
    let option = defaults.integerForKey(Preference.StopAtBatteryLevel.rawValue)
    self.batteryLevelPopUpButton.selectItemWithTag(option)
  }

}
