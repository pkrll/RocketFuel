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
    if (self.statusItemController.isActive) {
        [self.statusItemController requestTermination];
    }
}

#pragma mark APPLESCRIPT METHODS

- (void)toggleRocketFuel {
    if (!_statusItemController) {
        [self loadStatusItemController];
    }
    
    if (self.statusItemController.isActive) {
        [self.statusItemController requestTermination];
    } else {
        [self.statusItemController requestActivation];
    }
}

- (void)activateWithDuration:(NSInteger)duration {
    if (!_statusItemController) {
        [self loadStatusItemController];
    }
    
    [self.statusItemController requestActivationForDuration:duration];
}

- (NSNumber *)isActive {
    BOOL state = self.statusItemController.isActive;
    return [NSNumber numberWithBool:state];
}

@end
