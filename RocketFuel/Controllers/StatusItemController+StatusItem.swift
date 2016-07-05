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
    let actionMasks = Int((NSEventMask.LeftMouseUpMask).rawValue | (NSEventMask.RightMouseUpMask).rawValue)
    self.statusItem.button!.image = self.imageForStatusIcon()
    self.statusItem.button!.target = self
    self.statusItem.button!.action = #selector(self.didClickStatusItem(_:))
    self.statusItem.button!.sendActionOn(actionMasks)
    self.statusItem.button!.toolTip = "\(Constants.bundleName) \(Constants.bundleVersion) (\(Constants.bundleBuild))"
  }
  /**
   *  Invoked on iteraction with the Status Item
   *
   *  Note: If the left click activation option is set, the app will activate. Otherwise the menu will be shown.
   */
  func didClickStatusItem(sender: NSStatusBarButton) {
    let click: NSEvent = NSApp.currentEvent!
    
    if click.type == NSEventType.RightMouseUp || click.modifierFlags.contains(NSEventModifierFlags.CommandKeyMask) || self.shouldActivateOnLeftClick == false {
      self.statusItem.menu = self.menu
      self.statusItem.popUpStatusItemMenu(self.menu)
    } else {
      self.toggleState()
    }
  }
  /**
   *  Returns the status icon for a specific state.
   */
  func imageForStatusIcon(forState state: Bool = true) -> NSImage? {
    if RocketFuel.defaultManager.isActive && state == true {
      return NSImage(named: StatusItemImage.StatusItemActive.rawValue)
    }
    
    return NSImage(named: StatusItemImage.StatusItemIdle.rawValue)
  }
  
}