//
//  StatusItemController.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 22/12/15.
//  Copyright © 2015 Ardalan Samimi. All rights reserved.
//

import Cocoa

class StatusItemController: NSObject, NSMenuDelegate {
    /**
     *  The item displayed in the status bar.
     */
    private let statusItem: NSStatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)
    
    private lazy var menu: NSMenu = {
        [unowned self] in
        let menu = Menu(title: Global.Application.bundleName)
        
        menu.itemAutoStart.action = "didClickMenu:"
        menu.itemAutoStart.target = self
        menu.itemAutoStart.tag = Global.MenuItem.autoStart
        
        menu.itemAboutApp.action = "didClickMenu:"
        menu.itemAboutApp.target = self
        menu.itemAboutApp.tag = Global.MenuItem.aboutApp
        
        menu.delegate = self
        
        return menu
    }()
    
    private lazy var rocketFuel: RocketFuel = {
        let rocketFuel = RocketFuel()
        
        rocketFuel.delegate = self
        
        return rocketFuel
    }()
    /**
     *  Indicates whether the application is in an active state.
     *  - Returns: If application is in an active state, that is preventing sleep, this property is true.
     */
    internal var isActive: Bool {
        return self.rocketFuel.isActive
    }
    
    override init() {
        super.init()
        self.didLoad()
    }
    /**
     *  Invoked when the user clicks on the status item.
     *  - Note: Depending on which mouse button, the action should differ.
     */
    func didClickStatusItem(sender: NSStatusBarButton) {
        let click: NSEvent = NSApp.currentEvent!

        if click.type == NSEventType.RightMouseUp {
            self.statusItem.menu = self.menu
            self.statusItem.popUpStatusItemMenu(self.menu)
        } else {
            self.statusItem.button!.highlight(false)
            self.statusItem.button!.highlighted = false
            self.rocketFuel.toggle()
        }
    }
    
    func didClickMenu(sender: NSMenuItem?) {
        print(sender)
    }
    
    func menuWillOpen(menu: NSMenu) {
    }

    func menuDidClose(menu: NSMenu) {
        // IMPORTANT: Fixes the issue where the status bar button would only open the menu once the menu has been assigned to it. By removing the reference the button action is freed up, I guess.
        self.statusItem.menu = nil
    }
}

extension StatusItemController: RocketFuelDelegate {
    
    func rocketFuel(rocketFuel: RocketFuel, didChangeStatus mode: Bool) {
        self.statusItem.button!.image = self.statusItemImage(forState: mode)
    }
    
}

private extension StatusItemController {
    /**
     *  Invoked when app is initializing.
     *
     *  Sets up the status item.
     */
    func didLoad() {
        // The bit mask must contain conditions for both right and left click
        let actionMasks = Int((NSEventMask.LeftMouseUpMask).rawValue | (NSEventMask.RightMouseUpMask).rawValue)
        self.statusItem.button!.image = self.statusItemImage()
        self.statusItem.button!.target = self
        self.statusItem.button!.action = "didClickStatusItem:"
        self.statusItem.button!.sendActionOn(actionMasks)
        

    }
    /**
     *  Returns the status bar image for the correct state, or for the specified state.
     */
    func statusItemImage(forState state: Bool = true) -> NSImage {
        if self.isActive && state == true {
            return NSImage(named: StatusItemImage.isActive)!
        }
        
        return NSImage(named: StatusItemImage.isIdle)!
    }
    
}