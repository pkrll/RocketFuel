/*!
 *  RocketFuel.m
 *  RocketFuel
 *
 *  Created by Ardalan Samimi on 22/10/15.
 *  Copyright © 2015 Saturn Five. All rights reserved.
 */

#import "RocketFuel.h"

@interface RocketFuel ()

@property (nonatomic) NSTask *task;
@property (nonatomic) NSString *path;
@property (nonatomic) NSMutableArray *arguments;

@end

@implementation RocketFuel

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
        [self task];
        __weak typeof(self) weakSelf = self;
        [_task setTerminationHandler:^(NSTask * _Nonnull task) {
            [weakSelf terminate];
        }];
    }
}

- (void)terminate {
    if ([self.task isRunning]) {
        [_task terminate];
    }
    
    _task = nil;
    _arguments = nil;
    self.active = self.isActive;
}

- (BOOL)active {
    return self.isActive;
}

- (void)setActive:(BOOL)mode {
    [self.delegate rocketFuel:self
              didChangeStatus:mode];
}

- (BOOL)isActive {
    return [_task isRunning];
}

- (NSTask *)task {
    if (!_task) {
        _task = [NSTask launchedTaskWithLaunchPath:self.path
                                         arguments:self.arguments];
        self.active = self.isActive;
    }
    
    return _task;
}

- (NSMutableArray *)arguments {
    if (!_arguments) {
        NSString *argument;
        if (_duration) {
            argument = [NSString stringWithFormat:@"-dit %li", _duration];
        } else {
            argument = @"-di";
        }
        
        _arguments = [NSMutableArray arrayWithObject:argument];
    }
    
    return _arguments;
}

@end
