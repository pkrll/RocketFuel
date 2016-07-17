//
//  PreferencesWindowController.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 05/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa

class PreferencesWindowController: NSWindowController, RecorderDelegate {
  
  var batteryLevelPopUpButton: NSPopUpButton?
  var shortcutRecorder: KeyRecorderField?
  
  init() {
    let window = NSWindow(contentRect: NSRect(x: 478, y: 364, width: 238, height: 220), styleMask: NSTitledWindowMask | NSClosableWindowMask, backing: NSBackingStoreType.Buffered, defer: false)
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
    let appDelegate = (NSApplication.sharedApplication().delegate as! AppDelegate)
    let generalBox = NSBox(frame: NSRect(x: 17, y: 57, width: 204, height: 151))
    generalBox.title = "General"

    self.shortcutRecorder = KeyRecorderField(frame: NSRect(x: 18, y: 8, width: 160, height: 23))
    self.shortcutRecorder?.recorderDelegate = self
    
    if let shortcut = Preferences.value(forKey: PreferencesType.ActivationHotKey) as? NSDictionary {
      self.shortcutRecorder?.keyCode = shortcut.objectForKey("keyCode") as? Int ?? -1
      self.shortcutRecorder?.modifierFlags = shortcut.objectForKey("modifierFlags") as? Int ?? 0
      self.shortcutRecorder?.stringValue = shortcut.objectForKey("readable") as? String ?? ""
    }
    
    let shortcutLabel = NSTextField(frame: NSRect(x: 18, y: 32, width: 162, height: 18))
    shortcutLabel.lineBreakMode = .ByWordWrapping
    shortcutLabel.editable = false
    shortcutLabel.selectable = false
    shortcutLabel.stringValue = "Activate/Deactivate:"
    shortcutLabel.bordered = false
    shortcutLabel.textColor = NSColor.blackColor()
    shortcutLabel.backgroundColor = NSColor.controlColor()
    
    self.batteryLevelPopUpButton = NSPopUpButton(frame: NSRect(x: 18, y: 52, width: 160, height: 26))
    self.batteryLevelPopUpButton?.addItemsWithTitles(["Off", "5%", "10%", "15%", "20%"])
    self.batteryLevelPopUpButton?.itemArray.forEach { (item: NSMenuItem) in
      item.tag = (self.batteryLevelPopUpButton?.indexOfItem(item) ?? 0) * 5
    }
    
    let custom = appDelegate.statusItemController.shouldDeactivateOnBatteryLevel
    if custom > 0 && self.batteryLevelPopUpButton?.itemTitles.contains("\(custom)%") == false ?? false {
      self.batteryLevelPopUpButton?.addItemWithTitle("\(custom)%")
      self.batteryLevelPopUpButton?.itemWithTitle("\(custom)%")?.tag = custom
    }
    
    let batteryLevelLabel = NSTextField(frame: NSRect(x: 18, y: 80, width: 162, height: 34))
    batteryLevelLabel.lineBreakMode = .ByWordWrapping
    batteryLevelLabel.editable = false
    batteryLevelLabel.selectable = false
    batteryLevelLabel.stringValue = "Deactivate when battery level is below:"
    batteryLevelLabel.bordered = false
    batteryLevelLabel.textColor = NSColor.blackColor()
    batteryLevelLabel.backgroundColor = NSColor.controlColor()

    generalBox.addSubview(self.shortcutRecorder!)
    generalBox.addSubview(shortcutLabel)
    generalBox.addSubview(self.batteryLevelPopUpButton!)
    generalBox.addSubview(batteryLevelLabel)

    let doneButton = NSButton(frame: NSRect(x: 152, y: 13, width: 72, height: 32))
    doneButton.bezelStyle = .RoundedBezelStyle
    doneButton.title = "Done"
    doneButton.action = #selector(self.doneButtonTapped(_:))
    
    self.window?.contentView?.addSubview(generalBox)
    self.window?.contentView?.addSubview(doneButton)
  }
 
  override func windowDidLoad() {
    self.window?.center()
    let option = Preferences.value(forKey: .StopAtBatteryLevel) as? Int ?? 0
    self.batteryLevelPopUpButton?.selectItemWithTag(option)
  }
  
  func doneButtonTapped(sender: AnyObject?) {
    // The App Delegate will handle the save
    let appDelegate = (NSApplication.sharedApplication().delegate as! AppDelegate)
    let level = self.batteryLevelPopUpButton?.selectedTag() ?? 0
    let hotKey = HotKey(keyCode: self.shortcutRecorder!.keyCode, modifier: self.shortcutRecorder!.modifierFlags ?? 0, readable: self.shortcutRecorder!.stringValue, action: appDelegate.applicationShouldChangeState)
    
    appDelegate.applicationShouldDeactivate(atBatteryLevel: level)
    appDelegate.applicationShouldRegisterHotKey(hotKey)

    self.close()
  }
  
}