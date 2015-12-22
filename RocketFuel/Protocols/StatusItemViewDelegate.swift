//
//  StatusItemViewDelegate.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 22/12/15.
//  Copyright © 2015 Ardalan Samimi. All rights reserved.
//

import Cocoa

protocol StatusItemViewDelegate {
    func statusItemView(statusItemView: StatusItemView, didReceiveLeftClick theEvent: NSEvent)
    func statusItemView(statusItemView: StatusItemView, didReceiveRightClick theEvent: NSEvent)
}

