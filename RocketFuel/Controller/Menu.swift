//
//  Menu.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 23/12/15.
//  Copyright © 2015 Ardalan Samimi. All rights reserved.
//

import Cocoa

class Menu: NSMenu {

    internal var itemAutoStart: NSMenuItem = NSMenuItem(title: "Launch at Login", action: nil, keyEquivalent: "")
    internal var itemDuration: NSMenuItem = NSMenuItem(title: "Deactivate After…", action: nil, keyEquivalent: "")
    internal var itemAboutApp: NSMenuItem = NSMenuItem(title: "About Rocket Fuel", action: nil, keyEquivalent: "")
    internal var itemShutDown: NSMenuItem = NSMenuItem(title: "Quit", action: "terminate:", keyEquivalent: "")
    
    override init(title aTitle: String) {
        super.init(title: aTitle)
        self.addItemsToMainMenu()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetStateForMenuItems() {
        for item in self.itemArray {
            item.state = NSOffState
        }
    }
    
}

private extension Menu {
    
    func addItemsToMainMenu() {
        self.addItem(self.itemAutoStart)
        self.addItem(self.itemDuration)
        self.addItem(NSMenuItem.separatorItem())
        self.addItem(self.itemAboutApp)
        self.addItem(NSMenuItem.separatorItem())
        self.addItem(self.itemShutDown)
    }
    
}