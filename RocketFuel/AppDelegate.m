/*!
 *  AppDelegate.m
 *  RocketFuel
 *
 *  Created by Ardalan Samimi on 22/10/15.
 *  Copyright © 2015 Saturn Five. All rights reserved.
 */

#import "AppDelegate.h"
#import "RFStatusItemController.h"

@interface AppDelegate ()

@property (strong) RFStatusItemController *statusItemController;

@end

@implementation AppDelegate

- (void)loadStatusItemController {
    self.statusItemController = [[RFStatusItemController alloc] init];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self loadStatusItemController];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    if (self.statusItemController.isSleepModeOn) {
        [self.statusItemController requestTermination];
    }
}

@end
