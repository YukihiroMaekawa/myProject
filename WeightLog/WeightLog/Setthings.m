//
//  Setthings.m
//  Weight Log
//
//  Created by 前川 幸広 on 2014/09/07.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "Setthings.h"

@implementation Setthings

- (id)init
{
    if (self = [super init])
    {
        [self loadAppVersion];
        [self loadIsFirstLogin];
        [self loadBodyHeight];
        [self loadBodyWeight];
        [self loadUnit];
    }
    return self;
}

- (void) saveAll{
    [self saveAppVersion];
    [self saveIsFirstLogin];
    [self saveBodyHeight];
    [self saveBodyWeight];
    [self saveUnit];
}

- (void) resetAllData{
    self.appVersion = @"1.00";
    self.isFirstLogin = YES;
    self.bodyHeight = @"";
    self.bodyWeight = @"";
    self.unit       = 0; //50g
    [self saveAll];
}

// AppVersion
- (void) loadAppVersion{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.appVersion = [defaults stringForKey:@"appVersion"];
}
- (void) saveAppVersion{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.appVersion forKey:@"appVersion"];
    if ( ![defaults synchronize] ) {NSLog( @"failed ..." );}
}

//isFirstLogin
- (void) loadIsFirstLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.isFirstLogin = [defaults boolForKey:@"isFirstLogin"];
}
- (void) saveIsFirstLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.isFirstLogin forKey:@"isFirstLogin"];
    if ( ![defaults synchronize] ) {NSLog( @"failed ..." );}
}

//bodyHeight
- (void) loadBodyHeight{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.bodyHeight = [defaults stringForKey:@"bodyHeight"];
}
- (void) saveBodyHeight{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.bodyHeight forKey:@"bodyHeight"];
    if ( ![defaults synchronize] ) {NSLog( @"failed ..." );}
}

//bodyWeight
- (void) loadBodyWeight{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.bodyWeight = [defaults stringForKey:@"bodyWeight"];
}
- (void) saveBodyWeight{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.bodyWeight forKey:@"bodyWeight"];
    if ( ![defaults synchronize] ) {NSLog( @"failed ..." );}
}

//unit
- (void) loadUnit{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.unit = [defaults integerForKey:@"unit"];
}
- (void) saveUnit{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.unit forKey:@"unit"];
    if ( ![defaults synchronize] ) {NSLog( @"failed ..." );}
}


@end
