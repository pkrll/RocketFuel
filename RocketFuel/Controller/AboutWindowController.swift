//
//  AboutWindowController.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 23/12/15.
//  Copyright © 2015 Ardalan Samimi. All rights reserved.
//

import Cocoa

class AboutWindowController: NSWindowController {
    
    internal var applicationVersion: String {
        return "Version \(Global.Application.bundleVersion) (\(Global.Application.bundleBuild))"
    }
    
}
