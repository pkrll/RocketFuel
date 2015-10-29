/*!
 *  RFStatusItemController.m
 *  RocketFuel
 *
 *  Created by Ardalan Samimi on 22/10/15.
 *  Copyright © 2015 Saturn Five. All rights reserved.
 */

#import "RFStatusItemController.h"
#import "RFStatusItemView.h"
#import "RFMenu.h"
#import "RocketFuel.h"
#import "RFAboutWindow.h"

@interface RFStatusItemController () <RFStatusItemViewDelegate, RocketFuelDelegate, NSMenuDelegate>

@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) RFStatusItemView *statusItemView;
@property (nonatomic, strong) RFMenu *menu;
@property (nonatomic, strong) RFMenu *subMenu;
@property (nonatomic, strong) RocketFuel *rocketFuel;
@property (nonatomic, strong) RFAboutWindow *aboutWindow;
@property (nonatomic) BOOL applicationWillLaunchAtLogin;
@property (nonatomic, readonly, getter = isMenuDark) BOOL menuDark;

@end

@implementation RFStatusItemController

@synthesize applicationWillLaunchAtLogin = _applicationWillLaunchAtLogin;

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
    self.statusItemView.toolTip = [self statusItemToolTip];
}

- (NSString *)statusItemToolTip {
    NSString *bundleName = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *bundleShort = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *bundleBuild = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"%@ %@ (%@)", bundleName, bundleShort, bundleBuild];
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

- (RFMenu *)menu {
    if (!_menu) {
        _menu = [[RFMenu alloc] initMainMenuWithTitle:@"RocketFuel"];
        
        _menu.autoStartMenu.action = @selector(toggleLaunchAtLogin:);
        _menu.autoStartMenu.target = self;
        _menu.autoStartMenu.state = self.applicationWillLaunchAtLogin;
        
        _menu.durationMenu.submenu = self.subMenu;
        
        _menu.aboutAppMenu.action = @selector(openAboutWindow:);
        _menu.aboutAppMenu.target = self;
        
        _menu.delegate = self;
    }
    
    return _menu;
}

- (RFMenu *)subMenu {
    if (!_subMenu) {
        _subMenu = [[RFMenu alloc] initSubMenuWithTitle:@"RocketFuel Submenu"];
        [_subMenu addItemWithTitle:@"5 Minutes"
                               tag:300
                          selector:@selector(deactivateAfterDuration:)
                            target:self];
        [_subMenu addItemWithTitle:@"15 Minutes"
                               tag:900
                          selector:@selector(deactivateAfterDuration:)
                            target:self];
        [_subMenu addItemWithTitle:@"30 Minutes"
                               tag:1800
                          selector:@selector(deactivateAfterDuration:)
                            target:self];
        [_subMenu addItemWithTitle:@"1 Hour"
                               tag:3600
                          selector:@selector(deactivateAfterDuration:)
                            target:self];
        [_subMenu addItemWithTitle:@"Never"
                               tag:0
                          selector:@selector(deactivateAfterDuration:)
                            target:self];
    }
    
    return _subMenu;
}

- (void)menuWillOpen:(NSMenu *)menu {
    self.statusItemView.image = [self imageForPushedState];
    self.statusItemView.highlightMode = YES;
}

- (void)menuDidClose:(NSMenu *)menu {
    self.statusItemView.image = [self imageForCurrentState];
    self.statusItemView.highlightMode = NO;
}

- (void)toggleLaunchAtLogin:(NSMenuItem *)sender {
    self.applicationWillLaunchAtLogin = !self.applicationWillLaunchAtLogin;
    sender.state = self.applicationWillLaunchAtLogin;
}

- (void)openAboutWindow:(id)sender {
    if (self.aboutWindow == nil) {
        self.aboutWindow = [[RFAboutWindow alloc] init];
    }
    
    [self.aboutWindow showWindow:self];
    [self.aboutWindow.window makeKeyAndOrderFront:self];
    [self.aboutWindow.window setLevel:NSFloatingWindowLevel];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(aboutWindowWillClose:)
                                               name:NSWindowWillCloseNotification
                                             object:nil];
}

- (void)aboutWindowWillClose:(id)sender {
    self.aboutWindow = nil;
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)deactivateAfterDuration:(NSMenuItem *)sender {
    NSInteger duration = sender.tag;
    [self.rocketFuel activateWithDuration:duration];
    
    if (sender.state == NSOffState) {
        [self.subMenu resetStateForMenuItems];
        sender.state = NSOnState;
    }
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

- (BOOL)isMenuDark {
    return [NSAppearance.currentAppearance.name hasPrefix:@"NSAppearanceNameVibrantDark"];
}

#pragma mark SETTERS AND GETTERS

- (BOOL)applicationWillLaunchAtLogin {
    if (!_applicationWillLaunchAtLogin) {
        _applicationWillLaunchAtLogin = [self isApplicationInLoginItems];
    }
    
    return _applicationWillLaunchAtLogin;
}

- (void)setApplicationWillLaunchAtLogin:(BOOL)applicationWillLaunchAtLogin {
    if (applicationWillLaunchAtLogin) {
        [self addApplicationToLoginItems];
    } else {
        [self removeApplicationFromLoginItems];
    }
    
    _applicationWillLaunchAtLogin = applicationWillLaunchAtLogin;
}

#pragma mark LAUNCH AT LOGIN METHODS

- (BOOL)isApplicationInLoginItems {
    LSSharedFileListItemRef itemRef = [self itemRefInLoginItems];
    BOOL applicationIsAnLoginItem = NO;

    if (itemRef != NULL) {
        applicationIsAnLoginItem = YES;
        CFRelease(itemRef);
    }
    
    return applicationIsAnLoginItem;
}

- (void)addApplicationToLoginItems {
    LSSharedFileListRef loginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    CFURLRef bundleURL = (__bridge_retained CFURLRef)[NSURL fileURLWithPath:[NSBundle.mainBundle bundlePath]];
    LSSharedFileListItemRef itemRef = LSSharedFileListInsertItemURL(loginItemsRef, kLSSharedFileListItemLast, NULL, NULL, bundleURL, NULL, NULL);
    
    if (itemRef != NULL) {
        CFRelease(itemRef);
    }
    
    CFRelease(bundleURL);
    CFRelease(loginItemsRef);
}

- (void)removeApplicationFromLoginItems {
    LSSharedFileListRef loginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    LSSharedFileListItemRef itemRef = [self itemRefInLoginItems];
    
    if (itemRef != NULL) {
        LSSharedFileListItemRemove(loginItemsRef, itemRef);
        CFRelease(itemRef);
    }
    
    CFRelease(loginItemsRef);
}

- (LSSharedFileListItemRef)itemRefInLoginItems {
    LSSharedFileListItemRef itemRef = NULL;
    LSSharedFileListRef loginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (loginItemsRef != NULL) {
        NSURL *bundleURL = [NSURL fileURLWithPath:[NSBundle.mainBundle bundlePath]];
        NSArray *loginItems = (NSArray *)CFBridgingRelease(LSSharedFileListCopySnapshot(loginItemsRef, NULL));
        CFURLRef itemURLRef = NULL;
        LSSharedFileListItemRef currentItemRef = NULL;
        for (id item in loginItems) {
            currentItemRef = (__bridge_retained LSSharedFileListItemRef)item;
            if (LSSharedFileListItemResolve(currentItemRef, 0, &itemURLRef, NULL) == noErr) {
                if ([(__bridge NSURL *)itemURLRef isEqualTo:bundleURL]) {
                    itemRef = currentItemRef;
                    CFRetain(itemRef);
                }
            }
            
            if (itemURLRef != NULL) {
                CFRelease(itemURLRef);
            }
            
            CFRelease(currentItemRef);
        }
        
        CFRelease(loginItemsRef);
    }
    
    return itemRef;
}

@end
