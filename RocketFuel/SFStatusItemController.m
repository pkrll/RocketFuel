/*!
 *  SFStatusItemController.m
 *  RocketFuel
 *
 *  Created by Ardalan Samimi on 22/10/15.
 *  Copyright © 2015 Saturn Five. All rights reserved.
 */

#import "SFStatusItemController.h"
#import "SFRocketFuel.h"

@interface SFStatusItemController ()

@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSMenu *statusMenu;
@property (nonatomic, strong) SFRocketFuel *RocketFuel;

@end

@implementation SFStatusItemController

NSString *const menuItemImageIdle = @"rocketIdle";
NSString *const menuItemImageActive = @"rocketActive";
NSString *const menuItemImagePushed = @"rocketPushed";

+ (instancetype)init {
    return [[super alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self objectDidLoad];
    }
    
    return self;
}

- (void)objectDidLoad {
    self.RocketFuel = [SFRocketFuel engage];
    self.statusMenu = [self menuWithItems];
    self.statusItem = [NSStatusBar.systemStatusBar statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.image = [NSImage imageNamed:menuItemImageIdle];
    self.statusItem.menu = self.statusMenu;
}

- (NSMenu *)menuWithItems {
    NSMenu *statusMenuBar = [[NSMenu alloc] initWithTitle:@"RocketFuel"];
    NSMenuItem *activate = [[NSMenuItem alloc] initWithTitle:@"Activate"
                                                      action:@selector(activate:)
                                               keyEquivalent:@"a"];
    NSMenuItem *separator = [NSMenuItem separatorItem];
    NSMenuItem *terminate = [[NSMenuItem alloc] initWithTitle:@"Quit"
                                                       action:@selector(terminate:)
                                                keyEquivalent:@"q"];
    activate.target = self;
    terminate.target = self;
    [statusMenuBar addItem:activate];
    [statusMenuBar addItem:separator];
    [statusMenuBar addItem:terminate];
    return statusMenuBar;
}

- (void)terminate:(id)sender {
    [[NSApplication sharedApplication] terminate:sender];
}

- (void)activate:(id)sender {
    [self.RocketFuel toggleSleepMode];
    [self menuItemShouldDisplayActiveIcon:self.RocketFuel.isSleepModeOn];
}

- (void)menuItemShouldDisplayActiveIcon:(BOOL)isActive {
    NSString *imageName = (isActive) ? menuItemImageActive : menuItemImageIdle;
    self.statusItem.image = [NSImage imageNamed:imageName];
}

- (BOOL)isSleepModeOn {
    return self.RocketFuel.isSleepModeOn;
}

- (void)requestTermination {
    [self.RocketFuel toggleSleepMode];
}

@end
