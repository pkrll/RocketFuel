//
//  Global.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 23/12/15.
//  Copyright © 2015 Ardalan Samimi. All rights reserved.
//
import Foundation

struct Global {
  
  static let caffeinatePath = "/usr/bin/caffeinate"
  
  struct Application {
    /**
     *  The Application's name as set in the bundle.
     */
    static let bundleName: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String
    /**
     *  The Application's version number, set in the bundle.
     */
    static let bundleVersion: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    /**
     *  The Application's build number, set in the bundle.
     */
    static let bundleBuild: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String
    
  }
  
  enum MenuItem: Int {
    
    case activate
    case leftClick
    case autoStart
    case duration
    case aboutApp
    case shutDown
    
  }
  
}