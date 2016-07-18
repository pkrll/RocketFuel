//
//  MenuItemTag.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 01/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Foundation

enum MenuItemTag {
  
  case Normal(NormalMenuItem)
  case Custom(Int)
  
  enum NormalMenuItem: Int {
    case Activate = 1
    case LaunchAtLogin
    case LeftClickActivation
    case Preferences
    case About
    case Terminate
  }
  
  var rawValue: Int {
    switch self {
    case .Normal(let tag):
      return tag.rawValue
    case .Custom(let tag):
      return tag
    }
  }
  
  init(rawValue: Int) {
    if let item = NormalMenuItem(rawValue: rawValue) {
      self = MenuItemTag.Normal(item)
    } else {
      self = MenuItemTag.Custom(rawValue)
    }
  }
  
}
