/*!
 *  RFMenu.h
 *  RocketFuel
 *
 *  Created by Ardalan Samimi on 26/10/15.
 *  Copyright © 2015 Saturn Five. All rights reserved.
 */

#import "RFMenu.h"

@implementation RFMenu

- (instancetype)initMainMenuWithTitle:(NSString *)title {
    self = [super initWithTitle:title];
    
    if (self) {
        [self addItemsToMainMenu];
    }
    
    return self;
}

- (instancetype)initSubMenuWithTitle:(NSString *)title {
    self = [super initWithTitle:title];
    
    if (self) {
        
    }
    
    return self;
}

- (void)addItemsToMainMenu {
    self.autoStartMenu = [[NSMenuItem alloc] initWithTitle:@"Launch at Login"
                                                    action:nil
                                             keyEquivalent:@""];
    self.durationMenu = [[NSMenuItem alloc] initWithTitle:@"Deactivate After"
                                                   action:nil
                                            keyEquivalent:@""];
    self.aboutAppMenu = [[NSMenuItem alloc] initWithTitle:@"About"
                                                   action:nil
                                            keyEquivalent:@""];
    self.shutdownMenu = [[NSMenuItem alloc] initWithTitle:@"Quit"
                                                   action:@selector(terminate:)
                                            keyEquivalent:@""];
    [self addItem:self.autoStartMenu];
    [self addItem:self.durationMenu];
    [self addItem:[NSMenuItem separatorItem]];
    [self addItem:self.aboutAppMenu];
    [self addItem:[NSMenuItem separatorItem]];
    [self addItem:self.shutdownMenu];
}

- (void)addItemWithTitle:(NSString *)title
                     tag:(int)tag
                selector:(SEL)selector
                  target:(id)sender {
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:title
                                                  action:selector
                                           keyEquivalent:@""];
    item.tag = tag;
    item.target = sender;
    [self addItem:item];
}

- (void)resetStateForMenuItems {
    for (NSMenuItem *item in self.itemArray) {
        item.state = NSOffState;
    }
}

@end
