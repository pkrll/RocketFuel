//
//  HotKey.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 17/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Foundation
import Carbon

class HotKey {
  
  typealias HotKeyAction = () -> Void
  
  var keyCode: Int
  var modifier: Int
  var readable: String
  var action: HotKeyAction?
  var hotKeyRef: EventHotKeyRef? = nil
  fileprivate(set) var id: Int
  
  init(keyCode: Int, modifier: Int, readable: String, action: HotKeyAction?) {
    self.keyCode = keyCode
    self.modifier = modifier
    self.readable = readable
    self.action = action
    self.id = keyCode
  }
  
}
