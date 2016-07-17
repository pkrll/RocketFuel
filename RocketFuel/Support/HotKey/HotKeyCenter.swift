//
//  HotKeyCenter.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 17/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa
import Carbon

class HotKeyCenter {
  
  static let sharedManager = HotKeyCenter(shouldInstallEventHandler: true)
  
  private var hotKeys: [Int: HotKey] = [:]
  
  init(shouldInstallEventHandler: Bool = false) {
    if shouldInstallEventHandler {
      self.installEventHandler()
    }
  }
  
  func register(hotKey: HotKey?) {
    guard let hotKey = hotKey where hotKey.id > -1 && self.hotKeys[hotKey.id] == nil else { return }
    
    var hotKeyRef: EventHotKeyRef = nil
    var hotKeyID = EventHotKeyID()
    
    hotKeyID.id = UInt32(hotKey.id)
    hotKeyID.signature = UTGetOSTypeFromString("RKFL")
    print(hotKey.modifier)
    
    let status = RegisterEventHotKey(UInt32(hotKey.keyCode), UInt32(hotKey.modifier), hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
    guard status == noErr else { return }
    hotKey.hotKeyRef = hotKeyRef
    self.hotKeys[hotKey.id] = hotKey
  }
  
  func unregister(hotKey: HotKey?) {
    guard let hK = hotKey, let hotKey = self.hotKeys[hK.id] else { return }
    UnregisterEventHotKey(hotKey.hotKeyRef)
    self.hotKeys.removeValueForKey(hotKey.id)
  }
  
  private func installEventHandler() {
    var eventType = EventTypeSpec()
    eventType.eventClass = OSType(kEventClassKeyboard)
    eventType.eventKind = OSType(kEventHotKeyPressed)
    
    InstallEventHandler(GetApplicationEventTarget(), {(nextHanlder, theEvent, userData) -> OSStatus in
      /// Check that hkCom in indeed your hotkey ID and handle it.
      return HotKeyCenter.sharedManager.handleEvent(theEvent)
      }, 1, &eventType, nil, nil)
  }
  
  func handleEvent(event: EventRef) -> OSStatus {
    guard Int(GetEventClass(event)) == kEventClassKeyboard else { return -1 }
    var hotKeyID = EventHotKeyID()
    let status = GetEventParameter(event, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil, sizeof(EventHotKeyID), nil, &hotKeyID)
    guard status == noErr else { return status }
    
    guard let hotKey = self.hotKeys[Int(hotKeyID.id)] else { return -1 }
    
    hotKey.action?()
    
    return noErr
  }
  
}