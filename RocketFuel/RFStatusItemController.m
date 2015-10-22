//
//  RFStatusItemController.m
//  RocketFuel
//
//  Created by Ardalan Samimi on 22/10/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

#import "RFStatusItemController.h"
#import "RFStatusItemView.h"

@interface RFStatusItemController () <RFStatusItemViewDelegate>

@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) RFStatusItemView *statusItemView;

@end

@implementation RFStatusItemController

NSString *const menuItemImageIdle = @"rocketIdle";
NSString *const menuItemImageActive = @"rocketActive";
NSString *const menuItemImagePushed = @"rocketPushed";

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
    self.statusItemView.image = [NSImage imageNamed:menuItemImageIdle];
}

#pragma mark DELEGATE METHODS

- (void)RFStatusItemView:(RFStatusItemView *)view
     didReceiveLeftClick:(NSEvent *)theEvent {
    
}

- (void)RFStatusItemView:(RFStatusItemView *)view
    didReceiveRightClick:(NSEvent *)theEvent {
    NSImage *newImage;
    
    if ([self.statusItemView.image.name isEqualToString:menuItemImageIdle]) {
        newImage = [NSImage imageNamed:menuItemImageActive];
    } else {
        newImage = [NSImage imageNamed:menuItemImageIdle];
    }
    
    self.statusItemView.image = newImage;
    self.statusItemView.highlightMode = !self.statusItemView.highlightMode;
}

@end
