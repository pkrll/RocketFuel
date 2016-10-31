//
//  MenuItemTag.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 01/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Foundation

enum MenuItemTag {
  
  case normal(NormalMenuItem)
  case custom(Int)
  
  enum NormalMenuItem: Int {
    case activate = 1
    case launchAtLogin
    case leftClickActivation
    case preferences
    case about
    case terminate
  }
  
  var rawValue: Int {
    switch self {
    case .normal(let tag):
      return tag.rawValue
    case .custom(let tag):
      return tag
    }
  }
  
  init(rawValue: Int) {
    if let item = NormalMenuItem(rawValue: rawValue) {
      self = MenuItemTag.normal(item)
    } else {
      self = MenuItemTag.custom(rawValue)
    }
  }
  
}
