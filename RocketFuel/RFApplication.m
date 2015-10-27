/*!
 *  RFApplication.m
 *  RocketFuel
 *
 *  Created by Ardalan Samimi on 23/10/15.
 *  Copyright © 2015 Saturn Five. All rights reserved.
 */

#import "RFApplication.h"
#import "AppDelegate.h"

@implementation RFApplication

- (NSNumber *)isActivated {
    AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
    return appDelegate.isActive;
}

@end
