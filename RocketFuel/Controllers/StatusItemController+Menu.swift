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
    let state = (self.rocketFuel.isActive) ? "Deactivate Rocket Fuel" : "Activate Rocket Fuel"

    _ = menu.addItem(withTitle: state, tag: MenuItemTag.normal(.activate).rawValue)
    
    menu.addSeparatorItem()
    
    _ = menu.addItem(withTitle: "Launch at Login", tag: MenuItemTag.normal(.launchAtLogin).rawValue, state: self.shouldLaunchAtLogin)
    _ = menu.addItem(withTitle: "Left Click Activation", tag: MenuItemTag.normal(.leftClickActivation).rawValue, state: self.shouldActivateOnLeftClick)
    let item = menu.addItem(withTitle: "Deactivate After", tag: 0, state: false, isClickable: false)
    item?.submenu = self.timeoutSubmenu
    
    menu.addSeparatorItem()
    
    _ = menu.addItem(withTitle: "Preferences…", tag: MenuItemTag.normal(.preferences).rawValue)
    _ = menu.addItem(withTitle: "About Rocket Fuel…", tag: MenuItemTag.normal(.about).rawValue)
    
    menu.addSeparatorItem()
    
    _ = menu.addItem(withTitle: "Quit", tag: MenuItemTag.normal(.terminate).rawValue)
    
    menu.delegate = self
    
    return menu
  }
  
  var timeoutSubmenu: Menu {
    let menu = Menu(title: "Submenu")
    let timeout = self.rocketFuel.timeout
    
    _ = menu.addItem(withTitle: "5 Minutes", tag: 300, state: (300 == timeout))
    _ = menu.addItem(withTitle: "15 Minutes", tag: 900, state: (900 == timeout))
    _ = menu.addItem(withTitle: "30 Minutes", tag: 1800, state: (1800 == timeout))
    _ = menu.addItem(withTitle: "1 Hour", tag: 3600, state: (3600 == timeout))
    _ = menu.addItem(withTitle: "Never", tag: 0, state: (0 == timeout))
    
    // Add a new menu item if the timeout is user defined. 
    if [300, 900, 1800, 3600, 0].contains(timeout) == false {
      let time = Time.humanReadableTime(fromSeconds: timeout)
      menu.addSeparatorItem()
      _ = menu.addItem(withTitle: time, tag: Int(timeout), state: true)
    }
    
    menu.delegate = self
    
    return menu
  }
  
  func didClickMenuItem(_ menuItem: NSMenuItem) {
    switch MenuItemTag(rawValue: menuItem.tag) {
    case .normal(.activate):
      self.toggleState()
    case .normal(.launchAtLogin):
      self.shouldLaunchAtLogin = !self.shouldLaunchAtLogin
      menuItem.state = self.shouldLaunchAtLogin.intValue()
    case .normal(.leftClickActivation):
      self.shouldActivateOnLeftClick = !self.shouldActivateOnLeftClick
      menuItem.state = self.shouldActivateOnLeftClick.intValue()
    case .normal(.preferences):
      self.openPreferences()
    case .normal(.about):
      self.openAbout()
    case .normal(.terminate):
      self.terminate()
    case .custom(let timeout):
      self.request(.activation, withDuration: Double(timeout))
    }
  }

  func menuDidClose(_ menu: NSMenu) {
    self.statusItem.menu = nil
  }
  
}
