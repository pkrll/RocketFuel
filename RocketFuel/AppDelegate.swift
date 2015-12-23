//
//  AppDelegate.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 22/12/15.
//  Copyright © 2015 Ardalan Samimi. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItemController: StatusItemController!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        self.statusItemController = StatusItemController()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }


}

