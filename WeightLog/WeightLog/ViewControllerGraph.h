//
//  ViewControllerGraph.h
//  Weight Log
//
//  Created by 前川 幸広 on 2014/09/06.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBConnector.h"
#import "ViewGraphLine.h"
#import "Setthings.h"
#import "NADView.h"
#import "ViewTabData.h"

@interface ViewControllerGraph : UIViewController <NADViewDelegate>
{
    ViewTabData * _tempData;
    DBConnector *_db;
    Setthings *_setthingData;

    NSString *_barTitle;
    NSString *_currentDateStr;

    NSMutableArray * _tableLabelVal;
    NSMutableArray * _tableDataXVal;
    NSMutableArray * _tableDataYVal;
    
    ViewGraphLine * _viewGraph;
    double _minWeight;
    double _maxWeight;
    double _avgWeight;
    int _inputCnt;
}
@property (nonatomic, retain) NADView * nadView;
@property (weak, nonatomic) IBOutlet UILabel *lblBMI;
@property (nonatomic) NSString *pDateMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblAvgWeight;
@property (weak, nonatomic) IBOutlet UILabel *lblSetthingWeight;
@property (weak, nonatomic) IBOutlet UILabel *lblMaxWeight;
@property (weak, nonatomic) IBOutlet UILabel *lblMinWeight;
@end
