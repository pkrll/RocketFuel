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
    let menuItem = self.addItemWithTitle(title, action: action, keyEquivalent: "")
    menuItem?.target = self
    menuItem?.state = (state) ? NSOnState : NSOffState
    menuItem?.tag = tag
    
    return menuItem
  }
  
  func addSeparatorItem() {
    self.addItem(NSMenuItem.separatorItem())
  }
  
  func menu(withTag tag: Int) -> NSMenuItem? {
    for item in self.itemArray {
      if item.tag == tag {
        return item
      }
    }
    
    return nil
  }
  
  func resetMenuItemStates() {
    for item in self.itemArray {
      item.state = NSOffState
    }
  }
  
  func selectMenuItem(sender: NSMenuItem?) {
    guard let sender = sender else { return }
    if let delegate = self.delegate as? MenuDelegate {
      delegate.didClickMenuItem(sender)
    }
  }
  
}