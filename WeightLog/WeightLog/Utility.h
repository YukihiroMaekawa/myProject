//
//  Utility.h
//  Weight Log
//
//  Created by 前川 幸広 on 2014/09/07.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Setthings.h"
#import <UIKit/UIKit.h>

@interface Utility : NSObject
{
}
+ (BOOL)chkNumeric:(NSString *)checkString;
+ (BOOL)chkDecimal:(NSString *)checkString;
+ (NSString *)calcData :(int)mode :(NSString*)inputValue;
+ (NSString *)convDecimalData :(NSString*)inputValue;
+ (NSString *)getBMI : (NSString*) bodyWeight;
+ (NSString *)getBMIJudge : (NSString*) bodyWeight;
+ (NSString *)screenSize;

@end
