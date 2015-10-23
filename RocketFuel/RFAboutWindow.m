/*!
 *  RFAboutWindow.m
 *  RocketFuel
 *
 *  Created by Ardalan Samimi on 23/10/15.
 *  Copyright © 2015 Saturn Five. All rights reserved.
 */

#import "RFAboutWindow.h"

@interface RFAboutWindow ()

@end

@implementation RFAboutWindow

- (NSString *)applicationVersion {
    NSString *versionShort = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *versionBuild = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"Version %@ (%@)", versionShort, versionBuild];
}

- (NSString *)applicationName {
    return [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleName"];
}

- (instancetype)init {
    self = [super initWithWindowNibName:@"About" owner:self];
    return self;
}

@end
