/*!
 *  AppDelegate.m
 *  RocketFuel
 *
 *  Created by Ardalan Samimi on 22/10/15.
 *  Copyright © 2015 Saturn Five. All rights reserved.
 */

#import "AppDelegate.h"
#import "SFStatusItemController.h"

@interface AppDelegate ()

@property (strong) SFStatusItemController *statusItem;

@end

@implementation AppDelegate

- (void)loadStatusItem {
    self.statusItem = [SFStatusItemController init];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self loadStatusItem];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    if (self.statusItem.isSleepModeOn) {
        [self.statusItem requestTermination];
    }
}

@end
