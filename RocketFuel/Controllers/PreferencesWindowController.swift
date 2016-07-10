//
//  PreferencesWindowController.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 05/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa

class PreferencesWindowController: NSWindowController {
  
  var batteryLevelPopUpButton: NSPopUpButton?
  
  init() {
    let window = NSWindow(contentRect: NSRect(x: 478, y: 364, width: 238, height: 188), styleMask: NSTitledWindowMask | NSClosableWindowMask, backing: NSBackingStoreType.Buffered, defer: false)
    window.releasedWhenClosed = true
    window.oneShot = true
    super.init(window: window)
    self.configureViews()
    self.windowDidLoad()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureViews() {
    let generalBox = NSBox(frame: NSRect(x: 17, y: 57, width: 204, height: 111))
    generalBox.title = "General"
    
    let text = NSTextField(frame: NSRect(x: 18, y: 41, width: 162, height: 34))
    text.lineBreakMode = .ByWordWrapping
    text.editable = false
    text.selectable = false
    text.stringValue = "Deactivate when battery level is below:"
    text.bordered = false
    text.textColor = NSColor.blackColor()
    text.backgroundColor = NSColor.controlColor()
    
    self.batteryLevelPopUpButton = NSPopUpButton(frame: NSRect(x: 18, y: 9, width: 163, height: 26))
    self.batteryLevelPopUpButton?.addItemsWithTitles(["Off", "5%", "10%", "15%", "20%"])
    self.batteryLevelPopUpButton?.itemArray.forEach { (item: NSMenuItem) in
      item.tag = (self.batteryLevelPopUpButton?.indexOfItem(item) ?? 0) * 5
    }
    
    generalBox.addSubview(text)
    generalBox.addSubview(self.batteryLevelPopUpButton!)

    let doneButton = NSButton(frame: NSRect(x: 152, y: 13, width: 72, height: 32))
    doneButton.bezelStyle = .RoundedBezelStyle
    doneButton.title = "Done"
    doneButton.action = #selector(self.savePreferencesAndClose(_:))
    
    self.window?.contentView?.addSubview(generalBox)
    self.window?.contentView?.addSubview(doneButton)
  }
 
  override func windowDidLoad() {
    self.window?.center()
    let option = Preferences.value(forKey: .StopAtBatteryLevel) as? Int ?? 0
    self.batteryLevelPopUpButton?.selectItemWithTag(option)
  }
  
  func savePreferencesAndClose(sender: AnyObject?) {
    // The App Delegate will handle the save
    let level = self.batteryLevelPopUpButton?.selectedTag() ?? 0
    (NSApplication.sharedApplication().delegate as! AppDelegate).applicationShouldDeactivate(atBatteryLevel: level)
    self.close()
  }
  
}