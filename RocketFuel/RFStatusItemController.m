/*!
 *  RFStatusItemController.m
 *  RocketFuel
 *
 *  Created by Ardalan Samimi on 22/10/15.
 *  Copyright © 2015 Saturn Five. All rights reserved.
 */

#import "RFStatusItemController.h"
#import "RFStatusItemView.h"
#import "RocketFuel.h"

@interface RFStatusItemController () <RFStatusItemViewDelegate, NSMenuDelegate>

@property (nonatomic, strong) NSMenu *menu;
@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) RFStatusItemView *statusItemView;
@property (nonatomic, strong) RocketFuel *rocketFuel;

@end

@implementation RFStatusItemController

NSString *const imageStateIdle = @"rocketIdle";
NSString *const imageStateActive = @"rocketActive";
NSString *const imageStatePushed = @"rocketPushed";

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self didLoad];
    }
    
    return self;
}

- (void)didLoad {
    self.statusItem = [NSStatusBar.systemStatusBar statusItemWithLength:NSSquareStatusItemLength];
    self.statusItemView = [[RFStatusItemView alloc] initWithStatusItem:self.statusItem];
    self.statusItemView.image = [NSImage imageNamed:imageStateIdle];
    self.statusItemView.delegate = self;
}

#pragma mark DELEGATE METHODS

- (void)RFStatusItemView:(RFStatusItemView *)view
     didReceiveLeftClick:(NSEvent *)theEvent {
    [self.rocketFuel toggleSleepMode];
    self.statusItemView.image = [self imageForCurrentState];
    [self.statusItemView setNeedsDisplay:YES];
}

- (void)RFStatusItemView:(RFStatusItemView *)view
    didReceiveRightClick:(NSEvent *)theEvent {
    [self.statusItemView openMenu:self.menu];
    self.statusItemView.image = [self imageForCurrentState];
}

#pragma mark MENU METHODS

- (NSMenu *)menu {
    if (!_menu) {
        _menu = [[NSMenu alloc] initWithTitle:@"RocketFuel"];
        _menu.delegate = self;
        [_menu addItemWithTitle:@"Quit"
                         action:@selector(terminate:)
                  keyEquivalent:@"q"];
    }
    
    return _menu;
}

- (void)menuWillOpen:(NSMenu *)menu {
    self.statusItemView.image = [self imageForPushedState];
    self.statusItemView.highlightMode = YES;
}

- (void)menuDidClose:(NSMenu *)menu {
    self.statusItemView.image = [self imageForCurrentState];
    self.statusItemView.highlightMode = NO;
}

#pragma mark IMAGE METHODS

- (NSImage *)imageForCurrentState {
    return ([self isSleepModeOn]) ? [NSImage imageNamed:imageStateActive] : [NSImage imageNamed:imageStateIdle];
}

- (NSImage *)imageForIdleState {
    return [NSImage imageNamed:imageStateIdle];
}

- (NSImage *)imageForActiveState {
    return [NSImage imageNamed:imageStateActive];
}

- (NSImage *)imageForPushedState {
    return [NSImage imageNamed:imageStatePushed];
}

#pragma mark TASK CONTROLLER METHODS

- (RocketFuel *)rocketFuel {
    if (!_rocketFuel) {
        _rocketFuel = [RocketFuel engage];
    }
    
    return _rocketFuel;
}

- (BOOL)isSleepModeOn {
    return self.rocketFuel.sleepMode;
}

- (void)requestTermination {
    [self.rocketFuel toggleSleepMode];
}

@end
