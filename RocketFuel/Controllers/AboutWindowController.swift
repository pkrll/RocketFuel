//
//  AboutWindowController.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 05/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa

class AboutWindowController: NSWindowController {
  
  internal var applicationVersion: String {
    return "Version \(Constants.bundleVersion) (\(Constants.bundleBuild))"
  }
  
}
