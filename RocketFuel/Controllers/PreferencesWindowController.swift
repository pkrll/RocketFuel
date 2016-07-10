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
  
  @IBAction func buttonCloseTapped(sender: AnyObject) {
    let threshold = self.batteryLevelPopUpButton.selectedTag()
    Preferences.save(threshold, forKey: .StopAtBatteryLevel)
    (NSApplication.sharedApplication().delegate as! AppDelegate).applicationShouldDeactivate(atBatteryLevel: threshold)
    self.close()
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    let option = Preferences.value(forKey: .StopAtBatteryLevel) as? Int ?? 0
    self.batteryLevelPopUpButton.selectItemWithTag(option)
  }

}