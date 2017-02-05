//
//  ViewTabData.h
//  Weight Log
//
//  Created by 前川 幸広 on 2014/09/04.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewTabData : NSObject{}
+ (ViewTabData *)sharedManager;

@property BOOL isMainTab;
@property NSDate *editDate;

@end
