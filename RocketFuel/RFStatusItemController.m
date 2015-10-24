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
#import "RFAboutWindow.h"

@interface RFStatusItemController () <RFStatusItemViewDelegate, RocketFuelDelegate, NSMenuDelegate>

@property (nonatomic, strong) NSMenu *menu;
@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) RFStatusItemView *statusItemView;
@property (nonatomic, strong) RocketFuel *rocketFuel;
@property (nonatomic, strong) RFAboutWindow *aboutWindow;
@property (nonatomic, readonly, getter = isMenuDark) BOOL menuDark;

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
    self.statusItemView.image = [self imageForCurrentState];
    self.statusItemView.image.template = YES;
    self.statusItemView.delegate = self;
}

#pragma mark DELEGATE METHODS

- (void)statusItemView:(RFStatusItemView *)view
   didReceiveLeftClick:(NSEvent *)theEvent {
    [self.rocketFuel toggleSleepMode];
}

- (void)statusItemView:(RFStatusItemView *)view
  didReceiveRightClick:(NSEvent *)theEvent {
    [view openMenu:self.menu];
}

#pragma mark MENU METHODS

- (NSMenu *)menu {
    if (!_menu) {
        _menu = [[NSMenu alloc] initWithTitle:@"RocketFuel"];
        _menu.delegate = self;
        NSMenuItem *aboutMenu = [[NSMenuItem alloc] initWithTitle:@"About"
                                                           action:@selector(openAboutWindow:)
                                                    keyEquivalent:@""];
        aboutMenu.target = self;
        [_menu addItem:aboutMenu];
        [_menu addItem:[NSMenuItem separatorItem]];
        [_menu addItemWithTitle:@"Quit"
                         action:@selector(terminate:)
                  keyEquivalent:@""];
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
    return (self.isActive) ? [self imageForActiveState] : [self imageForIdleState];
}

- (NSImage *)imageForIdleState {
    return (self.isMenuDark) ? [self imageForPushedState] : [NSImage imageNamed:imageStateIdle];
}

- (NSImage *)imageForActiveState {
    return [NSImage imageNamed:imageStateActive];
}

- (NSImage *)imageForPushedState {
    return [NSImage imageNamed:imageStatePushed];
}

#pragma mark TASK CONTROLLER DELEGATE METHODS

- (void)rocketFuel:(RocketFuel *)rocketFuel
   didChangeStatus:(BOOL)sleepMode {
    self.statusItemView.image = (sleepMode) ? [self imageForActiveState] : [self imageForIdleState];
}

#pragma mark TASK CONTROLLER METHODS

- (RocketFuel *)rocketFuel {
    if (!_rocketFuel) {
        _rocketFuel = [RocketFuel engage];
        _rocketFuel.delegate = self;
    }
    
    return _rocketFuel;
}

- (BOOL)isActive {
    return self.rocketFuel.active;
}

- (void)requestTermination {
    [self.rocketFuel toggleSleepMode];
}

- (void)requestActivation {
    [self.rocketFuel toggleSleepMode];
}

#pragma mark MISC METHODS

- (void)openAboutWindow:(id)sender {
    self.aboutWindow = [[RFAboutWindow alloc] init];
    [self.aboutWindow showWindow:self];
    [self.aboutWindow.window makeKeyAndOrderFront:self];
    [self.aboutWindow.window setLevel:NSFloatingWindowLevel];
}


- (BOOL)isMenuDark {
    return [NSAppearance.currentAppearance.name hasPrefix:@"NSAppearanceNameVibrantDark"];
}

@end
