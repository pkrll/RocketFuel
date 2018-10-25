//
//  RocketFuel+Notifications.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 2018-10-25.
//  Copyright © 2018 Ardalan Samimi. All rights reserved.
//
import Foundation

extension RocketFuel {
  
  func showNotification(withTitle title: String, andMessage message: String) {
    let notification = NSUserNotification()
    notification.hasActionButton = true
    notification.title = title
    notification.informativeText = message
    NSUserNotificationCenter.default.deliver(notification)
  }
  
}
