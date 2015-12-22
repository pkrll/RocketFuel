//
//  StatusItemController.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 22/12/15.
//  Copyright © 2015 Ardalan Samimi. All rights reserved.
//

import Cocoa

class StatusItemController: NSObject {
    
    private let statusItem: NSStatusItem
    private let statusItemView: StatusItemView
    
    override init() {
        self.statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)
        self.statusItemView = StatusItemView(withStatusItem: self.statusItem)
        super.init()

    }
    
    private func didLoad() {
        
    }
    
}