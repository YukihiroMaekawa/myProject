//
//  Setthings.h
//  Weight Log
//
//  Created by 前川 幸広 on 2014/09/07.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Setthings : NSObject

- (void) saveAll;
- (void) resetAllData;

- (void) loadAppVersion;
- (void) saveAppVersion;
- (void) loadIsFirstLogin;
- (void) saveIsFirstLogin;
- (void) loadBodyHeight;
- (void) saveBodyHeight;
- (void) loadBodyWeight;
- (void) saveBodyWeight;
- (void) loadUnit;
- (void) saveUnit;

@property BOOL isFirstLogin;
@property NSString *appVersion;
@property NSString *bodyHeight;
@property NSString *bodyWeight;
@property NSInteger unit; // 50g 100g

@end
