//
//  DBInit.m
//  Weight Log
//
//  Created by 前川 幸広 on 2014/08/12.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "DBInit.h"
#import "DBConnector.h"

@implementation DBInit

// 初期化
- (id)init
{
    if (self = [super init])
    {
        _db         = [[DBConnector alloc]init];
    }
    return self;
}

- (void) initData{
    NSString *sql;
    
    [_db dbOpen];
    
    sql = @"CREATE TABLE IF NOT EXISTS d_weight"
    "("
    " date          TEXT"
    ",date_month    TEXT"
    ",weight        TEXT"
    ",fat           TEXT"
    ",weight2       TEXT"
    ",fat2          TEXT"
    ",meal_lv       TEXT"
    ",exercise_lv   TEXT"
    ",memo          TEXT"
    ",PRIMARY KEY(date)"
    ")";
    [_db executeUpdate:sql];
    [_db dbClose];
}

- (void) resetAllData{
    NSString *sql;
    
    [_db dbOpen];
    
    sql = @"DELETE FROM d_weight";
    [_db executeUpdate:sql];
    [_db dbClose];
}
@end
