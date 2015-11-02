/*!
 *  RFAppleScript.m
 *  RocketFuel
 *
 *  Created by Ardalan Samimi on 23/10/15.
 *  Copyright © 2015 Saturn Five. All rights reserved.
 */

#import "RFAppleScript.h"
#import "AppDelegate.h"

@implementation RFAppleScript

- (void)toggle {
    AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
    [appDelegate toggleRocketFuel];
}

- (void)duration {
    NSInteger duration = [self.directParameter integerValue];
    if (!duration) {
        duration = 1;
    }

    AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
    [appDelegate activateWithDuration:duration];
}

- (id)performDefaultImplementation {
    SEL commandName = NSSelectorFromString(self.commandDescription.commandName);
    // Was it a valid command?
    if ([self respondsToSelector:commandName]) {
        IMP imp = [self methodForSelector:commandName];
        void (* func)(id, SEL) = (void *)imp;
        func(self, commandName);
    }
    

    
    return NO;
}

@end
