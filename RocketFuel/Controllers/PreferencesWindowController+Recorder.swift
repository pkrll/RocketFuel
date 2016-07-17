//
//  PreferencesWindowController+Recorder.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 12/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa
import Carbon

extension PreferencesWindowController {
  
  func recorderDidReceiveMouseDown(recorder: KeyRecorderField) {
    if self.shortcutRecorder!.captureMode == false {
      self.shortcutRecorder?.beginCapture()
    }
  }

  func recorderDidReceiveKeyDown(recorder: KeyRecorderField) {
    if self.shortcutRecorder!.captureMode {
      self.shortcutRecorder?.endCapture()
    }
  }
  
  override func mouseDown(theEvent: NSEvent) {
    if self.shortcutRecorder!.captureMode {
      self.shortcutRecorder?.endCapture()
    }
  }
  
  override func keyDown(theEvent: NSEvent) {
    if self.shortcutRecorder!.captureMode {
      self.shortcutRecorder?.keyDown(theEvent)
    }
  }
  
}