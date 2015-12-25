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

    private var aboutWindow: AboutWindowController?
    
    private var willLaunchAtLogin: Bool {
        get {
            return self.isApplicationInLoginItems()
        }
        set (mode) {
            if mode {
                self.addApplicationToLoginItems()
            } else {
                self.removeApplicationFromLoginItems()
            }
        }
    }

    private lazy var rocketFuel: RocketFuel = {
        let rocketFuel = RocketFuel()
        
        rocketFuel.delegate = self
        
        return rocketFuel
    }()
    
    private lazy var menu: Menu = {
        [unowned self] in
        let menu = Menu(title: Global.Application.bundleName)
        let action: Selector = "didClickMenuItem:"
        var item: NSMenuItem?
        
        item = menu.addItemWithTitle("Launch at Login", action: action, target: self, tag: Global.MenuItem.autoStart, state: Int(self.willLaunchAtLogin))
        
        item = menu.addItemWithTitle("Deactivate after…", action: nil, target: nil, tag: 0)
        item?.submenu = self.subMenu
        
        menu.addItem(NSMenuItem.separatorItem())
        item = menu.addItemWithTitle("About Rocket Fuel", action: action, target: self, tag: Global.MenuItem.aboutApp)
        
        menu.addItem(NSMenuItem.separatorItem())
        item = menu.addItemWithTitle("Quit", action: "terminate:", target: nil, tag: 0)
        
        menu.delegate = self

        return menu
    }()

    private lazy var subMenu: Menu = {
        let menu = Menu(title: "Submenu")
        let action: Selector = "didClickMenuItem:"

        menu.addItemWithTitle("5 Minutes", action: action, target: self, tag: 300)
        menu.addItemWithTitle("15 Minutes", action: action, target: self, tag: 900)
        menu.addItemWithTitle("30 Minutes", action: action, target: self, tag: 1800)
        menu.addItemWithTitle("1 Hour", action: action, target: self, tag: 3600)
        menu.addItemWithTitle("Never", action: action, target: self, tag: 0)
        
        return menu
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
    
    func requestTermination() {
        if self.isActive {
            self.rocketFuel.terminate()
        }
    }
    
    func requestActivation(withDuration: Double = 0) {
        self.rocketFuel.activate(withDuration: withDuration)
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

            self.rocketFuel.toggle()
        }
    }
    
    func didClickMenuItem(sender: NSMenuItem?) {
        guard let sender = sender else {
            return
        }
        
        switch sender.tag {
            case Global.MenuItem.autoStart:
                self.willLaunchAtLogin = !self.willLaunchAtLogin
                sender.state = Int(self.willLaunchAtLogin)
            case Global.MenuItem.aboutApp:
                self.aboutWindow = AboutWindowController(windowNibName: "About")
                self.aboutWindow?.showWindow(self)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "aboutWindowWillClose:", name: NSWindowWillCloseNotification, object: nil)
            default:
                self.rocketFuel.activate(withDuration: Double(sender.tag))
                self.subMenu.resetStateForMenuItems()
                sender.state = NSOnState
        }
    }

    func menuDidClose(menu: NSMenu) {
        // IMPORTANT: Fixes the issue where the status bar button would only open the menu once the menu has been assigned to it. By removing the reference the button action is freed up, I guess.
        self.statusItem.menu = nil
    }

    func aboutWindowWillClose(sender: AnyObject?) {
        self.aboutWindow = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        self.statusItem.button!.toolTip = "\(Global.Application.bundleName) \(Global.Application.bundleVersion) (\(Global.Application.bundleBuild))"
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
 
    // MARK: AUTO LAUNCH METHODS
    
    func isApplicationInLoginItems() -> Bool {
        let itemRef = self.sharedFileListItemRef()

        if let _ = itemRef {
            return true
        }
        
        return false
    }

    func addApplicationToLoginItems() {
        // Method takeRetainedValue() will get the value of the unmanaged reference and taking ownership.
        let listType = kLSSharedFileListSessionLoginItems.takeRetainedValue()
        let fileList = LSSharedFileListCreate(nil, listType, nil).takeRetainedValue() as LSSharedFileListRef?
        let bundleURL = NSBundle.mainBundle().bundleURL as CFURLRef
        // Using kLSSharedFileListItemBeforeFirst, because kLSSharedFileListItemLast caused a crash.
        let afterItem: LSSharedFileListItem? = kLSSharedFileListItemBeforeFirst.takeRetainedValue()

        LSSharedFileListInsertItemURL(fileList, afterItem, nil, nil, bundleURL, nil, nil)
    }
    
    func removeApplicationFromLoginItems() {
        let listType: CFString = kLSSharedFileListSessionLoginItems.takeUnretainedValue()
        let fileList: LSSharedFileListRef = LSSharedFileListCreate(nil, listType, nil).takeRetainedValue()
        let itemRef: LSSharedFileListItemRef? = self.sharedFileListItemRef()
        
        if itemRef != nil {
            LSSharedFileListItemRemove(fileList, itemRef)
        }
    }

    func sharedFileListItemRef() -> LSSharedFileListItemRef? {
        var itemRef: LSSharedFileListItemRef? = nil
        let listRef: LSSharedFileList? = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue()

        if (listRef != nil) {
            let bundlePath = NSBundle.mainBundle().bundleURL
            let loginItems: CFArray = LSSharedFileListCopySnapshot(listRef, nil).takeRetainedValue()
            var itemURLRef: NSURL
            
            for item in loginItems as NSArray {
                let item = item as! LSSharedFileListItemRef
                itemURLRef = LSSharedFileListItemCopyResolvedURL(item, 0, nil).takeRetainedValue() as NSURL
                
                if itemURLRef == bundlePath {
                    itemRef = item
                }
            }
        }
        
        return itemRef
    }
    
}