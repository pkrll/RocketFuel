//
//  StatusItemController+Menu.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 01/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa

extension StatusItemController {
  
  var menu: Menu {
    let menu = Menu(title: Constants.bundleName)
    let state = (RocketFuel.defaultManager.isActive) ? "Deactivate Rocket Fuel" : "Activate Rocket Fuel"
        
    menu.addItem(withTitle: state, tag: MenuItemTag.Normal(.Activate).rawValue)
    
    menu.addSeparatorItem()
    
    menu.addItem(withTitle: "Launch at Login", tag: MenuItemTag.Normal(.LaunchAtLogin).rawValue, state: self.shouldLaunchAtLogin)
    menu.addItem(withTitle: "Left Click Activation", tag: MenuItemTag.Normal(.LeftClickActivation).rawValue, state: self.shouldActivateOnLeftClick)
    let item = menu.addItem(withTitle: "Deactivate After", tag: 0, state: false, isClickable: false)
    item?.submenu = self.timeoutSubmenu
    
    menu.addSeparatorItem()
    
    menu.addItem(withTitle: "Preferences…", tag: MenuItemTag.Normal(.Preferences).rawValue)
    menu.addItem(withTitle: "About Rocket Fuel…", tag: MenuItemTag.Normal(.About).rawValue)
    
    menu.addSeparatorItem()
    
    menu.addItem(withTitle: "Quit", tag: MenuItemTag.Normal(.Terminate).rawValue)
    
    menu.delegate = self
    
    return menu
  }
  
  var timeoutSubmenu: Menu {
    let menu = Menu(title: "Submenu")

    menu.addItem(withTitle: "5 Minutes", tag: 300, state: (300 == self.rocketFuel.timeout))
    menu.addItem(withTitle: "15 Minutes", tag: 900, state: (900 == self.rocketFuel.timeout))
    menu.addItem(withTitle: "30 Minutes", tag: 1800, state: (1800 == self.rocketFuel.timeout))
    menu.addItem(withTitle: "1 Hour", tag: 3600, state: (3600 == self.rocketFuel.timeout))
    menu.addItem(withTitle: "Never", tag: 0)
    
    menu.delegate = self
    
    return menu
  }
  
  func didClickMenuItem(menuItem: NSMenuItem) {
    switch MenuItemTag(rawValue: menuItem.tag) {
    case .Normal(.Activate):
      self.toggleState()
    case .Normal(.LaunchAtLogin):
      self.shouldLaunchAtLogin = !self.shouldLaunchAtLogin
      menuItem.state = Int(self.shouldLaunchAtLogin)
    case .Normal(.LeftClickActivation):
      self.shouldActivateOnLeftClick = !self.shouldActivateOnLeftClick
      menuItem.state = Int(self.shouldActivateOnLeftClick)
    case .Normal(.Preferences):
      self.openPreferences()
    case .Normal(.About):
      self.openAbout()
    case .Normal(.Terminate):
      self.terminate()
    case .Custom(let timeout):
      self.request(.Activation, withDuration: Double(timeout))
    }
  }

  func menuDidClose(menu: NSMenu) {
    self.statusItem.menu = nil
  }
  
}
