//
//  AppDelegate.swift
//  RocketFuelHelper
//
//  Created by Ardalan Samimi on 15/05/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    // The helper app will make sure the launch at login option works in a sandboxed environment.
    // http://blog.timschroeder.net/2012/07/03/the-launch-at-login-sandbox-project/
    // If the app is running, the helper app should not do anything.
    var appIsRunning: Bool = false
    let activeApps = NSWorkspace.sharedWorkspace().runningApplications
    
    for app in activeApps {
      if app.bundleIdentifier == "com.ardalansamimi.RocketFuel" {
        appIsRunning = true
      }
    }
    
    if appIsRunning == false {
      let path = NSURL(string: NSBundle.mainBundle().bundlePath)!
      var comp = path.pathComponents
      comp?.removeLast()
      comp?.removeLast()
      comp?.removeLast()
      comp?.append("MacOS")
      comp?.append("RocketFuel")
      let url = NSString.pathWithComponents(comp!)
      if (NSWorkspace.sharedWorkspace().launchApplication(url)) {
      } else {
        NSLog("Rocket Fuel Helper App could not launch Rocket Fuel...")
      }
    }
    
    NSApp.terminate(nil)
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }


}

