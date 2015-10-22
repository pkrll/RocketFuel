//
//  RFStatusItemView.h
//  RocketFuel
//
//  Created by Ardalan Samimi on 22/10/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

@class RFStatusItemView;

@protocol RFStatusItemViewDelegate <NSObject>

- (void)RFStatusItemView:(RFStatusItemView *)view
     didReceiveLeftClick:(NSEvent *)theEvent;
- (void)RFStatusItemView:(RFStatusItemView *)view
    didReceiveRightClick:(NSEvent *)theEvent;

@end

@interface RFStatusItemView : NSView

@property (weak) id delegate;
@property (nonatomic) BOOL highlightMode;
@property (nonatomic, strong) NSImage *image;

- (instancetype)initWithStatusItem:(NSStatusItem *)item;

@end
