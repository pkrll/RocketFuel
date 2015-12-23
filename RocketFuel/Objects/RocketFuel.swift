//
//  RocketFuel.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 23/12/15.
//  Copyright © 2015 Ardalan Samimi. All rights reserved.
//

import Foundation

class RocketFuel: NSObject {
    
    internal var delegate: RocketFuelDelegate?
    
    internal var duration: Int = 0
    
    internal var isActive: Bool {
        return self.task?.running ?? false
    }
    
    private var active: Bool {
        get {
            return self.isActive
        }
        set (mode) {
            self.delegate?.rocketFuel(self, didChangeStatus: mode)
        }
    }
    
    private var task: NSTask?
    
    private var arguments: [String] {
        var argument: String = "-di"
        
        if self.duration > 0 {
            argument += "t \(self.duration)"
        }
        
        return [argument]
    }
    
    func toggle() {
        if (self.task != nil) {
            self.terminate()
        } else {
            self.activate()
        }
    }
    
    func terminate() {
        if self.isActive {
            self.task?.terminate()
        } else {
            self.didTerminate()
        }
    }
    
    func activate() {
        self.task = NSTask.launchedTaskWithLaunchPath(Global.caffeinate, arguments: self.arguments)
        self.task?.terminationHandler = { task in
            self.didTerminate()
        }
        
        self.active = self.isActive
    }
    
    func didTerminate() {
        self.task = nil
        self.active = self.isActive
    }
}