//
//  StatusItemView.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 22/12/15.
//  Copyright © 2015 Ardalan Samimi. All rights reserved.
//

import Cocoa

class StatusItemView: NSView {
    
    private let statusItem: NSStatusItem
    private var statusImage: NSImage?
    private var highlightMode: Bool = false

    internal var delegate: StatusItemViewDelegate?
    
    init(withStatusItem item: NSStatusItem) {
        let frame = NSMakeRect(0, 0, item.length, NSStatusBar.systemStatusBar().thickness)
        self.statusItem = item
        super.init(frame: frame)

        self.statusItem.view = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(dirtyRect: NSRect) {
        // Below code shortened and stolen from: http://blog.shpakovski.com/2011/07/cocoa-popup-window-in-status-bar.html
        if let image = self.statusImage {
            self.statusItem.drawStatusBarBackgroundInRect(dirtyRect, withHighlight: self.highlightMode)
            
            let bounds = self.bounds
            let height = image.size.height
            let width = image.size.width
            let iconX = round( CGFloat(NSWidth(bounds) - width) / 2.0)
            let iconY = round( CGFloat(NSHeight(bounds) - height) / 2.0)
            let point = NSMakePoint(iconX, iconY)
            
            image.drawAtPoint(point, fromRect: NSZeroRect, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1.0)
        }
    }
    
    func toggleHighlight(mode: Bool) {
        self.highlightMode = mode
        self.needsDisplay = true
    }
    
    func setImage(image: NSImage) {
        self.statusImage = image
        self.needsDisplay = true
    }
    
    override func mouseDown(theEvent: NSEvent) {
        self.delegate?.statusItemView(self, didReceiveLeftClick: theEvent)
    }
    
    override func rightMouseDown(theEvent: NSEvent) {
        self.delegate?.statusItemView(self, didReceiveRightClick: theEvent)
    }
    
    func openMenu(menu: NSMenu) {
        self.statusItem.popUpStatusItemMenu(menu)
    }
    
}