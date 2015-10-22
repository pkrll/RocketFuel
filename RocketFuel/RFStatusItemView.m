//
//  RFStatusItemView.m
//  RocketFuel
//
//  Created by Ardalan Samimi on 22/10/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

#import "RFStatusItemView.h"

@interface RFStatusItemView ()

@property (nonatomic, readonly) NSStatusItem *statusItem;

@end

@implementation RFStatusItemView

+ (instancetype)newWithStatusItem:(NSStatusItem *)item {
    return [[super alloc] initWithStatusItem:item];
}

- (instancetype)initWithStatusItem:(NSStatusItem *)item {
    self = [super initWithFrame:NSMakeRect(0, 0, item.length, NSStatusBar.systemStatusBar.thickness)];
    
    if (self) {
        _statusItem = item;
        _statusItem.view = self;
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    // Below code shortened and stolen from: http://blog.shpakovski.com/2011/07/cocoa-popup-window-in-status-bar.html
    [self.statusItem drawStatusBarBackgroundInRect:dirtyRect
                                     withHighlight:self.highlightMode];
    float width = self.image.size.width;
    float height = self.image.size.height;
    NSRect bounds = self.bounds;
    CGFloat iconX = roundf((NSWidth(bounds) - width) / 2);
    CGFloat iconY = roundf((NSHeight(bounds) - height) / 2);
    [self.image drawAtPoint: NSMakePoint(iconX, iconY)
                   fromRect:NSZeroRect
                  operation:NSCompositeSourceOver
                   fraction:1.0];
}

- (void)mouseDown:(NSEvent *)theEvent {
    
    [self setNeedsDisplay:YES];
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    [self.delegate RFStatusItemView:self
               didReceiveRightClick:theEvent];
    [self setNeedsDisplay:YES];
}

- (void)openMenu {
    
}

@end
