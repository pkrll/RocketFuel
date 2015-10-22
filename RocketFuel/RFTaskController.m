/*!
 *  RFTaskController.m
 *  RocketFuel
 *
 *  Created by Ardalan Samimi on 22/10/15.
 *  Copyright © 2015 Saturn Five. All rights reserved.
 */

#import "RFTaskController.h"

@interface RFTaskController ()

@property (nonatomic) NSTask *task;
@property (nonatomic) NSString *path;
@property (nonatomic) NSMutableArray *arguments;

@end

@implementation RFTaskController

+ (instancetype)engage {
    return [[super alloc] init];
}

- (instancetype)init {
    self = [super init];

    if (self) {
        self.path = @"/usr/bin/caffeinate";
    }
    
    return self;
}

- (void)toggleSleepMode {
    if (_task) {
        [self terminate];
    } else {
        [self launch];
    }
}

- (void)launch {
    [self.arguments addObject:@"-di"];
    [self task];
}

- (void)terminate {
    if ([self.task isRunning]) {
        [_task terminate];
    }

    _task = nil;
}

- (BOOL)isSleepModeOn {
    return [_task isRunning];
}

- (NSTask *)task {
    if (!_task) {
        _task = [NSTask launchedTaskWithLaunchPath:self.path
                                         arguments:self.arguments];
    }
    
    return _task;
}

- (NSMutableArray *)arguments {
    if (!_arguments) {
        _arguments = [NSMutableArray array];
    }
    
    return _arguments;
}

@end
