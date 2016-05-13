//
//  Menu.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 23/12/15.
//  Copyright © 2015 Ardalan Samimi. All rights reserved.
//
import Cocoa

class Menu: NSMenu {
  
  func addItemWithTitle(title: String, action: Selector, target: AnyObject?, tag: Int, state: Int = NSOffState) -> NSMenuItem? {
    let item = self.addItemWithTitle(title, action: action, keyEquivalent: "")
    item?.target = target
    item?.tag = tag
    item?.state = state
    
    return item
  }
  
  func menuWithTag(tag: Int) -> NSMenuItem? {
    for item in self.itemArray {
      if item.tag == tag {
        return item
      }
    }
    
    return nil
  }
  
  func resetStateForMenuItems() {
    for item in self.itemArray {
      item.state = NSOffState
    }
  }
  
}
