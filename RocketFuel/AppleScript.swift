//
//  AppleScript.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 24/12/15.
//  Copyright © 2015 Ardalan Samimi. All rights reserved.
//

import Cocoa
@objc(AppleScript)
class AppleScript: NSScriptCommand {

    private var appDelegate: AppDelegate {
        return NSApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func toggle() {
        self.appDelegate.applicationShouldChangeState()
    }
    
    func duration() {
        let duration: Int = self.directParameter!.integerValue
        self.appDelegate.applicationShouldActivateWithDuration(duration)
    }
    
    override func performDefaultImplementation() -> AnyObject? {
        let command = NSSelectorFromString(self.commandDescription.commandName)
        // Make sure the command was valid
        if self.respondsToSelector(command) {
            let imp: IMP = self.methodForSelector(command)
            typealias function = @convention(c) (AnyObject, Selector) -> Void
            let curriedImplementation = unsafeBitCast(imp, function.self)
            curriedImplementation(self, command)
        }
        
        return false
    }
    
}
