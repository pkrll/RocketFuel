//
//  AboutWindowController.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 05/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Cocoa

class AboutWindowController: NSWindowController {
  
  fileprivate var applicationVersion: String = "Version \(Constants.bundleVersion)"
  
  init() {
    let window = NSWindow(contentRect: NSRect(x: 478, y: 364, width: 344, height: 157),
                          styleMask: [.titled, .closable],
                          backing: NSWindow.BackingStoreType.buffered, defer: false)
    window.isReleasedWhenClosed = true
    window.isOneShot = true
    super.init(window: window)
    
    self.loadSubviews()
    self.windowDidLoad()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func loadSubviews() {
    let year = Calendar.current.component(.year, from: Date())

    let imageView = NSImageView(frame: NSRect(x: 20, y: 43, width: 108, height: 94))
    imageView.image = NSImage(named: NSImage.Name(rawValue: "Rocket"))
    imageView.imageFrameStyle = .none
    imageView.imageScaling = .scaleProportionallyDown
    
    let titleLabel = NSTextField(frame: NSRect(x: 146, y: 98, width: 192, height: 39))
    titleLabel.isBordered = false
    titleLabel.isEditable = false
    titleLabel.isSelectable = false
    titleLabel.textColor = .labelColor
    titleLabel.backgroundColor = .controlColor
    titleLabel.stringValue = Constants.applicationName
    titleLabel.font = NSFont(name: "HelveticaNeue-Thin", size: 32)
    
    let versionLabel = NSTextField(frame: NSRect(x: 146, y: 76, width: 192, height: 23))
    versionLabel.isBordered = false
    versionLabel.isEditable = false
    versionLabel.isSelectable = false
    versionLabel.textColor = .labelColor
    versionLabel.backgroundColor = .controlColor
    versionLabel.stringValue = self.applicationVersion
    versionLabel.font = NSFont(name: "HelveticaNeue-Light", size: 15)

    let authorLabel = NSTextField(frame: NSRect(x: 146, y: 43, width: 192, height: 25))
    authorLabel.isBordered = false
    authorLabel.isEditable = false
    authorLabel.isSelectable = false
    authorLabel.textColor = .labelColor
    authorLabel.backgroundColor = .controlColor
    authorLabel.stringValue = "Created by Ardalan Samimi"
    authorLabel.font = NSFont(name: "HelveticaNeue", size: 11)

    let copyrightLabel = NSTextField(frame: NSRect(x: 20, y: 20, width: 308, height: 15))
    copyrightLabel.isBordered = false
    copyrightLabel.isEditable = false
    copyrightLabel.isSelectable = false
    copyrightLabel.textColor = .labelColor
    copyrightLabel.backgroundColor = .controlColor
    copyrightLabel.stringValue = "Copyright © \(year) Ardalan Samimi. All rights reserved."
    copyrightLabel.font = NSFont(name: "HelveticaNeue", size: 11)
    copyrightLabel.alignment = .center
    
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
