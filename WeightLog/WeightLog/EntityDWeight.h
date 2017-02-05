//
//  EntityDWeight.h
//  Weight Log
//
//  Created by 前川 幸広 on 2014/08/12.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBConnector.h"

@interface EntityDWeight : NSObject
@property (nonatomic)           BOOL     isExist;
@property (nonatomic)           NSString *pKeyDate;
@property (nonatomic)           NSString *pDateMonth;
@property (nonatomic)           NSString *pWeight;
@property (nonatomic)           NSString *pFat;
@property (nonatomic)           NSString *pWeight2;
@property (nonatomic)           NSString *pFat2;
@property (nonatomic)           NSString *pMealLv;
@property (nonatomic)           NSString *pExerciseLv;
@property (nonatomic)           NSString *pMemo;

- (id)initWithSelect :(DBConnector *)db :(NSString *)date;
-(void) doInsert :(DBConnector *)db;
-(void) doUpdate :(DBConnector *)db;
-(void) doDelete :(DBConnector *)db;
@end
