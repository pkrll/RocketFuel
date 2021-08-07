//
//  StatusItemController+StatusItem.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 03/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa

extension StatusItemController {
  
  /**
   *  Configures the Status Item.
   */
  func configureStatusItem() {
    // The bit mask must contain conditions for both right and left click
    let actionMasks = Int((NSEvent.EventTypeMask.leftMouseUp).rawValue | (NSEvent.EventTypeMask.rightMouseUp).rawValue)
    self.statusItem.button!.image = self.imageForStatusIcon()
    self.statusItem.button!.target = self
    self.statusItem.button!.action = #selector(self.didClickStatusItem(_:))
    self.statusItem.button!.sendAction(on: NSEvent.EventTypeMask(rawValue: UInt64(actionMasks)))
    self.statusItem.button!.toolTip = "\(Constants.bundleName) \(Constants.bundleVersion) (\(Constants.bundleBuild))"
  }
  /**
   *  Invoked on iteraction with the Status Item
   *
   *  Note: If the left click activation option is set, the app will activate. Otherwise the menu will be shown.
   */
  @objc func didClickStatusItem(_ sender: NSStatusBarButton) {
    let click: NSEvent = NSApp.currentEvent!
    
    if click.type == NSEvent.EventType.rightMouseUp || click.modifierFlags.contains(NSEvent.ModifierFlags.command) || self.shouldActivateOnLeftClick == false {
      self.statusItem.menu = self.menu
      self.statusItem.popUpMenu(self.menu)
    } else {
      self.toggleState()
    }
  }
  /**
   *  Returns the status icon for a specific state.
   */
  func imageForStatusIcon(forState state: Bool = true) -> NSImage? {
    if self.rocketFuel.isActive && state == true {
      return NSImage(named: StatusItemImage.StatusItemActive.rawValue)
    }
    
    return NSImage(named: StatusItemImage.StatusItemIdle.rawValue)
  }
  
}
