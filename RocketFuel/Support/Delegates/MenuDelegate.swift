//
//  MenuDelegate.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 05/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa

protocol MenuDelegate: NSMenuDelegate {
  
  func didClickMenuItem(_ menuItem: NSMenuItem)
  
}
