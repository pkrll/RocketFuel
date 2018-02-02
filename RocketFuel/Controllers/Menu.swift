//
//  Menu.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 01/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa

class Menu: NSMenu {
  
  func addItem(withTitle title: String, tag: Int, state: Bool = false, isClickable: Bool = true) -> NSMenuItem? {
    
    let action = (isClickable) ? #selector(self.selectMenuItem(_:)) : nil
    let menuItem = self.addItem(withTitle: title, action: action, keyEquivalent: "")
    menuItem.target = self
    menuItem.state = (state) ? NSControl.StateValue.on : NSControl.StateValue.off
    menuItem.tag = tag
    
    return menuItem
  }
  
  func addSeparatorItem() {
    self.addItem(NSMenuItem.separator())
  }
  
  func menu(withTag tag: Int) -> NSMenuItem? {
    for item in self.items {
      if item.tag == tag {
        return item
      }
    }
    
    return nil
  }
  
  func resetMenuItemStates() {
    for item in self.items {
      item.state = NSControl.StateValue.off
    }
  }
  
  @objc func selectMenuItem(_ sender: NSMenuItem?) {
    guard let sender = sender else { return }
    if let delegate = self.delegate as? MenuDelegate {
      delegate.didClickMenuItem(sender)
    }
  }
  
}
