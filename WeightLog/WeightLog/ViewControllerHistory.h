//
//  ViewControllerHistory.h
//  Weight Log
//
//  Created by 前川 幸広 on 2014/08/12.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBConnector.h"
#import "ViewTabData.h"
#import "ViewGraphLine.h"
#import "NADView.h"

@interface ViewControllerHistory : UIViewController<UITableViewDelegate, UITableViewDataSource,NADViewDelegate>

{
    DBConnector *_db;
    NSMutableArray * _tableKey;
    NSMutableArray * _tableVal;
    NSDate * _editDate;
    
    ViewTabData * _tempData;
    
    NSString *_barTitle;
    NSString *_currentDateStr;
}
@property (nonatomic, retain) NADView * nadView;
@property (nonatomic) NSString *pDateMonth;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
