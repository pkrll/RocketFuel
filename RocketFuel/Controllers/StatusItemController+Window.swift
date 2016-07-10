//
//  StatusItemController+Window.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 05/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa

extension StatusItemController {
  
  func openPreferences() {
    guard self.preferencesWindowController == nil else { return }
    
    NSApp.activateIgnoringOtherApps(true)
    self.preferencesWindowController = PreferencesWindowController()
    self.preferencesWindowController?.showWindow(nil)
    self.preferencesWindowController?.window?.makeKeyAndOrderFront(nil)
    self.preferencesWindowController?.window?.delegate = self
  }
  
  func openAbout() {
    guard self.aboutWindowController == nil else { return }

    NSApp.activateIgnoringOtherApps(true)
    self.aboutWindowController = AboutWindowController()
    self.aboutWindowController?.showWindow(nil)
    self.aboutWindowController?.window?.makeKeyAndOrderFront(nil)
    self.aboutWindowController?.window?.delegate = self
  }
  
  // --------------------------------------------
  // MARK: - NSWindow Delegate Methods
  // --------------------------------------------
  
  func windowWillClose(notification: NSNotification) {
    if let window = notification.object as? NSWindow {
      if window == self.aboutWindowController?.window {
        self.aboutWindowController = nil
      } else if window == self.preferencesWindowController?.window {
        self.preferencesWindowController = nil
      }
    }
  }
  
}