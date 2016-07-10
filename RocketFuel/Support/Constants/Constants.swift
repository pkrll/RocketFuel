//
//  Constants.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 01/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa

struct Constants {
  /**
   *  The application name.
   */
  static let applicationName: String = "Rocket Fuel"
  /**
   *  The full application version.
   */
  static let applicationVersion: String = "Version \(Constants.bundleVersion) (\(Constants.bundleBuild))"
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
  /**
   *  The Application's bundle identifier.
   */
  static let bundleIdentifier: String = NSBundle.mainBundle().bundleIdentifier!

}