//
//  KeyRecorderField.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 17/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa
import Carbon

class KeyRecorderField: NSSearchField {
  
  let placeholderStringForCaptureMode = "Type Shortcut…"
  let placeholderStringForNormalMode = "Click To Set Shortcut…"
  
  var recorderDelegate: RecorderDelegate?
  
  var keyCode: Int = -1
  var modifierFlags: Int = 0
  
  var captureMode: Bool {
    return self.placeholderString == self.placeholderStringForCaptureMode
  }
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    self.alignment = .Center
    self.refusesFirstResponder = true
    
    (self.cell as? NSSearchFieldCell)?.searchButtonCell = nil
    
    self.endCapture()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func beginCapture() {
    self.stringValue = ""
    self.placeholderString = self.placeholderStringForCaptureMode
    
    self.keyCode = -1
    self.modifierFlags = 0
  }
  
  func endCapture() {
    self.placeholderString = self.placeholderStringForNormalMode
  }
  
  override func mouseDown(theEvent: NSEvent) {
    self.recorderDelegate?.recorderDidReceiveMouseDown(self)
  }
  
  override func keyDown(theEvent: NSEvent) {
    let keyCode = theEvent.keyCode
    let modifierFlags = theEvent.modifierFlags//.intersect(NSEventModifierFlags.DeviceIndependentModifierFlagsMask)
    var character: String?
    
    switch Int(keyCode) {
    case kVK_F1:
      character = "F1"
    case kVK_F2:
      character = "F2"
    case kVK_F3:
      character = "F3"
    case kVK_F4:
      character = "F4"
    case kVK_F5:
      character = "F5"
    case kVK_F6:
      character = "F6"
    case kVK_F7:
      character = "F7"
    case kVK_F8:
      character = "F8"
    case kVK_F9:
      character = "F9"
    case kVK_F10:
      character = "F10"
    case kVK_F11:
      character = "F11"
    case kVK_F12:
      character = "F12"
    default:
      character = theEvent.charactersIgnoringModifiers
    }
    
    self.keyCode = Int(keyCode)
    self.modifierFlags = 0
    
    if modifierFlags.contains(.CommandKeyMask) {
      character = "⌘" + character!
      self.modifierFlags |= cmdKey
    }
    
    if modifierFlags.contains(.AlternateKeyMask) {
      character = "⌥" + character!
      self.modifierFlags |= optionKey
    }
    
    if modifierFlags.contains(.ShiftKeyMask) {
      character = "⇧" + character!
      self.modifierFlags |= shiftKey
    }
    
    if modifierFlags.contains(.ControlKeyMask) {
      character = "^" + character!
      self.modifierFlags |= controlKey
    }
    
    self.stringValue = character ?? ""
    self.recorderDelegate?.recorderDidReceiveKeyDown(self)
  }
  
}
