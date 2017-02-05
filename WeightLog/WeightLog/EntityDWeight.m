//
//  EntityDWeight.m
//  Weight Log
//
//  Created by 前川 幸広 on 2014/08/12.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "EntityDWeight.h"
#import "DBConnector.h"

@implementation EntityDWeight
// 初期化
- (id)init
{
    if (self = [super init])
    {
        [self initProperty];
    }
    return self;
}

- (id)initWithSelect :(DBConnector *)db :(NSString *)date
{
    if (self = [super init])
    {
        [self initProperty];
        self.pKeyDate = date;
        
        //データ取得
        [self doSelect:db];
    }
    return self;
}

-(void) initProperty{
    self.pKeyDate     = @"";
    self.pDateMonth   = @"";
    self.pWeight      = @"";
    self.pFat         = @"";
    self.pWeight2     = @"";
    self.pFat2        = @"";
    self.pMealLv      = @"";
    self.pExerciseLv  = @"";
    self.pMemo        = @"";
}

-(void) doSelect:(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT "
           " date"
           ",date_month"
           ",weight"
           ",fat"
           ",weight2"
           ",fat2"
           ",meal_lv"
           ",exercise_lv"
           ",memo"
           "    FROM d_weight"
           "   WHERE date = '%@'"
           ,self.pKeyDate
           ];
    
    [db executeQuery:sql];
    
    self.isExist = NO;
    while ([db.results next]) {
        self.isExist = YES;
        self.pDateMonth   = [db.results stringForColumn:@"date_month"];
        self.pWeight      = [db.results stringForColumn:@"weight"];
        self.pFat         = [db.results stringForColumn:@"fat"];
        self.pWeight2     = [db.results stringForColumn:@"weight2"];
        self.pFat2        = [db.results stringForColumn:@"fat2"];
        self.pExerciseLv  = [db.results stringForColumn:@"exercise_lv"];
        self.pMealLv      = [db.results stringForColumn:@"meal_lv"];
        self.pMemo        = [db.results stringForColumn:@"memo"];
    }
}

-(void) doInsert:(DBConnector *)db{
    NSString *sql;
    
    sql = [NSString stringWithFormat
           :@"INSERT INTO d_weight"
           "("
           " date"
           ",date_month"
           ",weight"
           ",fat"
           ",weight2"
           ",fat2"
           ",meal_lv"
           ",exercise_lv"
           ",memo"
           ")"
           " SELECT"
           " '%@'"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ,self.pKeyDate
           ,self.pDateMonth
           ,self.pWeight
           ,self.pFat
           ,self.pWeight2
           ,self.pFat2
           ,self.pMealLv
           ,self.pExerciseLv
           ,self.pMemo
           ];
    [db executeUpdate:sql];
}

-(void) doUpdate :(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"UPDATE d_weight"
           "     SET date_month       = '%@'"
           "        ,weight           = '%@'"
           "        ,fat              = '%@'"
           "        ,weight2          = '%@'"
           "        ,fat2             = '%@'"
           "        ,meal_lv          = '%@'"
           "        ,exercise_lv      = '%@'"
           "        ,memo             = '%@'"
           "   WHERE date = '%@'"
           ,self.pDateMonth
           ,self.pWeight
           ,self.pFat
           ,self.pWeight2
           ,self.pFat2
           ,self.pMealLv
           ,self.pExerciseLv
           ,self.pMemo
           ,self.pKeyDate
           ];
    [db executeUpdate:sql];
}

-(void) doDelete :(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"DELETE FROM d_weight"
           "   WHERE date  = '%@'"
           ,self.pKeyDate
           ];
    [db executeUpdate:sql];
}
@end
