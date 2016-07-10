//
//  AboutWindowController.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 05/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa

class AboutWindowController: NSWindowController {
  
  private var applicationVersion: String = "Version \(Constants.bundleVersion) (\(Constants.bundleBuild))"
  
  init() {
    let window = NSWindow(contentRect: NSRect(x: 478, y: 364, width: 344, height: 157), styleMask: NSTitledWindowMask | NSClosableWindowMask, backing: NSBackingStoreType.Buffered, defer: false)
    window.releasedWhenClosed = true
    window.oneShot = true
    super.init(window: window)
    
    self.loadSubviews()
    self.windowDidLoad()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func loadSubviews() {
    let imageView = NSImageView(frame: NSRect(x: 20, y: 43, width: 108, height: 94))
    imageView.image = NSImage(named: "Rocket")
    imageView.imageFrameStyle = .None
    imageView.imageScaling = .ScaleProportionallyDown
    
    let titleLabel = NSTextField(frame: NSRect(x: 146, y: 98, width: 192, height: 39))
    titleLabel.bordered = false
    titleLabel.editable = false
    titleLabel.selectable = false
    titleLabel.textColor = NSColor.blackColor()
    titleLabel.backgroundColor = NSColor.controlColor()
    titleLabel.stringValue = Constants.applicationName
    titleLabel.font = NSFont(name: "HelveticaNeue-Thin", size: 32)
    
    let versionLabel = NSTextField(frame: NSRect(x: 146, y: 76, width: 192, height: 23))
    versionLabel.bordered = false
    versionLabel.editable = false
    versionLabel.selectable = false
    versionLabel.textColor = NSColor.blackColor()
    versionLabel.backgroundColor = NSColor.controlColor()
    versionLabel.stringValue = self.applicationVersion
    versionLabel.font = NSFont(name: "HelveticaNeue-Light", size: 15)

    let authorLabel = NSTextField(frame: NSRect(x: 146, y: 43, width: 192, height: 25))
    authorLabel.bordered = false
    authorLabel.editable = false
    authorLabel.selectable = false
    authorLabel.textColor = NSColor.blackColor()
    authorLabel.backgroundColor = NSColor.controlColor()
    authorLabel.stringValue = "Created by Ardalan Samimi"
    authorLabel.font = NSFont(name: "HelveticaNeue", size: 11)

    let copyrightLabel = NSTextField(frame: NSRect(x: 20, y: 20, width: 308, height: 15))
    copyrightLabel.bordered = false
    copyrightLabel.editable = false
    copyrightLabel.selectable = false
    copyrightLabel.textColor = NSColor.blackColor()
    copyrightLabel.backgroundColor = NSColor.controlColor()
    copyrightLabel.stringValue = "Copyright © 2016 Ardalan Samimi. All rights reserved."
    copyrightLabel.font = NSFont(name: "HelveticaNeue", size: 11)
    copyrightLabel.alignment = .Center
    
    self.window?.contentView?.addSubview(imageView)
    self.window?.contentView?.addSubview(titleLabel)
    self.window?.contentView?.addSubview(versionLabel)
    self.window?.contentView?.addSubview(authorLabel)
    self.window?.contentView?.addSubview(copyrightLabel)
  }
  
  override func windowDidLoad() {
    self.window?.center()
  }
  
}
