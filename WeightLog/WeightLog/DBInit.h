//
//  DBInit.h
//  Weight Log
//
//  Created by 前川 幸広 on 2014/08/12.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBConnector.h"

@interface DBInit : NSObject
{
    DBConnector *_db;
}
- (void) initData;
- (void) resetAllData;
@end
