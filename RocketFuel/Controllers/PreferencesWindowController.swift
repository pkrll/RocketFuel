//
//  PreferencesWindowController.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 05/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa

class PreferencesWindowController: NSWindowController, RecorderDelegate {
  
  var powerSourceButton: NSButton?
  var batteryLevelPopUpButton: NSPopUpButton?
  var shortcutRecorder: KeyRecorderField?
  
  init() {
    let window = NSWindow(contentRect: NSRect(x: 478, y: 364, width: 238, height: 260), styleMask: [.titled, .closable], backing: NSWindow.BackingStoreType.buffered, defer: false)
    window.isReleasedWhenClosed = true
    window.isOneShot = true
    super.init(window: window)
    self.configureViews()
    self.windowDidLoad()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureViews() {
    let appDelegate = (NSApplication.shared.delegate as! AppDelegate)
    let generalBox = NSBox(frame: NSRect(x: 17, y: 57, width: 204, height: 191))
    generalBox.title = "General"

    self.shortcutRecorder = KeyRecorderField(frame: NSRect(x: 18, y: 8, width: 160, height: 23))
    self.shortcutRecorder?.recorderDelegate = self
    
    if let shortcut = Preferences.value(forKey: PreferencesType.ActivationHotKey) as? NSDictionary {
      self.shortcutRecorder?.keyCode = shortcut.object(forKey: "keyCode") as? Int ?? -1
      self.shortcutRecorder?.modifierFlags = shortcut.object(forKey: "modifierFlags") as? Int ?? 0
      self.shortcutRecorder?.stringValue = shortcut.object(forKey: "readable") as? String ?? ""
    }
    
    let shortcutLabel = NSTextField(frame: NSRect(x: 18, y: 32, width: 162, height: 18))
    shortcutLabel.lineBreakMode = .byWordWrapping
    shortcutLabel.isEditable = false
    shortcutLabel.isSelectable = false
    shortcutLabel.stringValue = "Activate/Deactivate:"
    shortcutLabel.isBordered = false
    shortcutLabel.textColor = NSColor.black
    shortcutLabel.backgroundColor = NSColor.controlColor
    
    self.powerSourceButton = NSButton(frame: NSRect(x: 18, y: 120, width: 220, height: 34))
    self.powerSourceButton?.setButtonType(.switch)
    self.powerSourceButton?.title = "Disable on battery mode"
    
    self.batteryLevelPopUpButton = NSPopUpButton(frame: NSRect(x: 18, y: 52, width: 160, height: 26))
    self.batteryLevelPopUpButton?.addItems(withTitles: ["Off", "5%", "10%", "15%", "20%"])
    self.batteryLevelPopUpButton?.itemArray.forEach { (item: NSMenuItem) in
      item.tag = (self.batteryLevelPopUpButton?.index(of: item) ?? 0) * 5
    }
    
    let custom = appDelegate.statusItemController.shouldDeactivateOnBatteryLevel
    if custom > 0 && self.batteryLevelPopUpButton?.itemTitles.contains("\(custom)%") == false {
      self.batteryLevelPopUpButton?.addItem(withTitle: "\(custom)%")
      self.batteryLevelPopUpButton?.item(withTitle: "\(custom)%")?.tag = custom
    }
    
    let batteryLevelLabel = NSTextField(frame: NSRect(x: 18, y: 80, width: 162, height: 34))
    batteryLevelLabel.lineBreakMode = .byWordWrapping
    batteryLevelLabel.isEditable = false
    batteryLevelLabel.isSelectable = false
    batteryLevelLabel.stringValue = "Deactivate when battery level is below:"
    batteryLevelLabel.isBordered = false
    batteryLevelLabel.textColor = NSColor.black
    batteryLevelLabel.backgroundColor = NSColor.controlColor

    generalBox.addSubview(self.shortcutRecorder!)
    generalBox.addSubview(shortcutLabel)
    generalBox.addSubview(self.batteryLevelPopUpButton!)
    generalBox.addSubview(batteryLevelLabel)
    generalBox.addSubview(self.powerSourceButton!)
    
    let doneButton = NSButton(frame: NSRect(x: 152, y: 13, width: 72, height: 32))
    doneButton.bezelStyle = .rounded
    doneButton.title = "Done"
    doneButton.action = #selector(self.doneButtonTapped(_:))
    
    self.window?.contentView?.addSubview(generalBox)
    self.window?.contentView?.addSubview(doneButton)
  }
 
  override func windowDidLoad() {
    self.window?.center()
    
    let batteryLevel = Preferences.value(forKey: .StopAtBatteryLevel) as? Int ?? 0
    self.batteryLevelPopUpButton?.selectItem(withTag: batteryLevel)
    
    let batteryMode = Preferences.value(forKey: .DisableOnBatteryMode) as? Bool ?? false
    self.powerSourceButton?.state = (batteryMode) ? NSControl.StateValue.on : NSControl.StateValue.off
  }
  
  @objc func doneButtonTapped(_ sender: AnyObject?) {
    // The App Delegate will handle the save
    let appDelegate = (NSApplication.shared.delegate as! AppDelegate)
    let level = self.batteryLevelPopUpButton?.selectedTag() ?? 0
    let hotKey = HotKey(keyCode: self.shortcutRecorder!.keyCode, modifier: self.shortcutRecorder!.modifierFlags, readable: self.shortcutRecorder!.stringValue, action: appDelegate.applicationShouldChangeState)
    
    appDelegate.applicationShouldDeactivate(atBatteryLevel: level)
    appDelegate.applicationShouldRegisterHotKey(hotKey)
    
    if let buttonState = self.powerSourceButton?.state {
      let state = (buttonState == NSControl.StateValue.on) ? true : false
      appDelegate.applicationShouldDeactivate(onBatteryMode: state)
    }

    self.close()
  }
  
}
