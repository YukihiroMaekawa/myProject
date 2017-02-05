//
//  ViewControllerGraph.m
//  Weight Log
//
//  Created by 前川 幸広 on 2014/09/06.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerGraph.h"
#import "EntityDWeight.h"
#import "ViewGraphLine.h"
#import "Utility.h"

@interface ViewControllerGraph ()

@end

@implementation ViewControllerGraph

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // (2) NADView の作成    
    NSString * screenSize = [Utility screenSize];
    int viewX; int viewY; int viewWidth; int viewHeight;
    if([screenSize isEqual:@"4.7Inch"]){
        viewX = 0; viewY = 569; viewWidth = 375; viewHeight = 50;
    }else if([screenSize isEqual:@"5.5Inch"]){
        viewX = 0; viewY = 638; viewWidth = 414; viewHeight = 50;
    }else{
        viewX = 0; viewY = 470; viewWidth = 320; viewHeight = 50;
    }
    self.nadView = [[NADView alloc] initWithFrame:CGRectMake(viewX, viewY, viewWidth, viewHeight)];
    // (3) ログ出力の指定 [self.nadView setIsOutputLog:NO];
    // (4) set apiKey, spotId.
    [self.nadView setNendID:@"e4fc45fd1832bdd03fffaf417969c3f5b5be1417" spotID:@"230076"];
    [self.nadView setDelegate:self]; //(5)
    [self.nadView load]; //(6)
    //[self.view addSubview:self.nadView]; // 最初から表示する場合
    [self.nadView setDelegate:self];

    _db = [[DBConnector alloc] init];

    // 日付初期化
    [self initDate];    
}

// データ初期設定
- (void)initilizeData{
    //
    _barTitle= [NSString stringWithFormat:@"%@年%@月"
                ,[self.pDateMonth substringWithRange:NSMakeRange(0 ,4)]
                ,[self.pDateMonth substringWithRange:NSMakeRange(4 ,2)]
                ];
    
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.navigationItem.title = _barTitle;
    self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.000];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    UIBarButtonItem* left1 = [[UIBarButtonItem alloc]
                              initWithTitle:@"◀︎"
                              style:UIBarButtonItemStyleBordered
                              target:self
                              action:@selector(backDate:)];
    self.navigationItem.leftBarButtonItems = @[left1];
    
    UIBarButtonItem* right1 = [[UIBarButtonItem alloc]
                               initWithTitle:@"▶︎"
                               style:UIBarButtonItemStyleBordered
                               target:self
                               action:@selector(goDate:)];
    
    self.navigationItem.rightBarButtonItems = @[right1];
    
    [self getData];
    [self createGraph];
}

-(void)initDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *df  = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyyMM";
    NSString *strDate;
    strDate = [df stringFromDate:date];
    self.pDateMonth = strDate;
}

- (void) getData{
    _tableLabelVal  = [[NSMutableArray alloc] init];
    _tableDataXVal  = [[NSMutableArray alloc] init];
    _tableDataYVal  = [[NSMutableArray alloc] init];
    /*
    [_tableLabelVal addObject:@"1,,,,,,,,,10,,,,,,,,,,20,,,,,,,,,,30"];
    [_tableDataXVal  addObject:@"0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29"];
    [_tableDataYVal addObject:@"70,71,72,73,74,70,71,72,73,74,70,71,72,73,74,70,71,72,73,74,70,71,72,73,74,70,71,72,73,74"];
    [_tableGraphData addObject:@"70"];
    */
    
    //表示付きの日付を全て登録
    NSString *dateStr;
    NSDate *date;
    NSDateFormatter *df  = [[NSDateFormatter alloc]init]; //変換用
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    
    dateStr = [NSString stringWithFormat:@"%@/%@/01"
               ,[self.pDateMonth substringWithRange:NSMakeRange(0, 4)]
               ,[self.pDateMonth substringWithRange:NSMakeRange(4 ,2)]
               ];
    df.dateFormat = @"yyyy/MM/dd";
    date = [df dateFromString:dateStr];
    
    comps = [[NSDateComponents alloc] init];
    comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    NSInteger dateMonthNow = comps.month;
    
    int addDay = 0;
    
    [_db dbOpen];
    
    _minWeight = 0;
    _maxWeight = 0;
    _avgWeight = 0;
    _inputCnt  = 0;
    while (true){
        comps = [[NSDateComponents alloc] init];
        [comps setDay:addDay];
        NSDate *date2 = [calendar dateByAddingComponents:comps toDate:date options:0];
        
        // 年・月・日を取得
        comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date2];
        if (dateMonthNow != comps.month){break;}
        
        NSString *date2Str;
        df.dateFormat = @"yyyy/MM/dd";
        date2Str = [df stringFromDate:date2];
        NSLog(@"%@",date2Str);
        
        EntityDWeight * entityDWeight = [[EntityDWeight alloc] initWithSelect:_db :date2Str];
        // 1日、5日、・・・30日
        if (addDay == 0 || (addDay + 1) % 5 == 0){
            
            int setDay = 1;
            if(addDay > 0 ){
                setDay = addDay + 1;
            }
            [_tableLabelVal addObject:[NSString stringWithFormat:@"%d",setDay]];
            
        }else{
            //labelVal = [NSString stringWithFormat:@"%@,",labelVal];
            [_tableLabelVal addObject:@""];
        }
        // 0から連番
        [_tableDataXVal addObject:[NSString stringWithFormat:@"%d",addDay]];

        double weight    = 0;
        double weight2   = 0;
        double weightSet = 0;

        if (entityDWeight.isExist
         &&  ( [entityDWeight.pWeight  length] != 0
            || [entityDWeight.pWeight2 length] != 0
             )
            ){
            //体重が登録されている場合は設定する
            NSLog(@"weightP  %@",entityDWeight.pWeight);
            NSLog(@"weightP2 %@",entityDWeight.pWeight2);
            
            if([entityDWeight.pWeight length] > 0){
                weight = [Utility convDecimalData:entityDWeight.pWeight].doubleValue;
            }
            if([entityDWeight.pWeight2 length] > 0){
                weight2 = [Utility convDecimalData:entityDWeight.pWeight2].doubleValue;
            }
            // 朝晩で軽い体重を設定
            weightSet = weight;
            if(weight > weight2 && weight2 != 0){
                weightSet = weight2;
            }
            
            if(_minWeight == 0 && _maxWeight == 0){
                _minWeight = weightSet;
                _maxWeight = weightSet;
            }else if(weightSet < _minWeight){
                _minWeight = weightSet;
            }else if(weightSet > _maxWeight){
                _maxWeight = weightSet;
            }
            
            _inputCnt ++;
            _avgWeight += weightSet;
        }
        NSLog(@"setWiehgt %f",weightSet);
        [_tableDataYVal addObject:[NSString stringWithFormat:@"%f",weightSet]];
        
        addDay++;
    }
    
    //平均体重
    if(_inputCnt > 0){
        _avgWeight = _avgWeight / _inputCnt;
    }
    
    //画面表示
    _lblAvgWeight.text = @"";
    _lblMaxWeight.text = @"";
    _lblMinWeight.text = @"";
    
    if([_setthingData.bodyWeight isEqual:@""]){
        _lblSetthingWeight.text = [NSString stringWithFormat:@"%@" ,[Utility convDecimalData:_setthingData.bodyWeight]];
    }else{
        _lblSetthingWeight.text = [NSString stringWithFormat:@"%@Kg" ,[Utility convDecimalData:_setthingData.bodyWeight]];
    }
    
    if(_inputCnt > 0){
    _lblAvgWeight.text = [NSString stringWithFormat:@"%@Kg",[Utility convDecimalData:[NSString stringWithFormat:@"%f" ,_avgWeight]]];
    _lblMaxWeight.text = [NSString stringWithFormat:@"%@Kg",[Utility convDecimalData:[NSString stringWithFormat:@"%f" ,_maxWeight]]];
    _lblMinWeight.text = [NSString stringWithFormat:@"%@Kg",[Utility convDecimalData:[NSString stringWithFormat:@"%f" ,_minWeight]]];
        
    _lblBMI.text = [NSString stringWithFormat:@"%@(%@)"
                    ,[Utility getBMI:_lblAvgWeight.text]
                    ,[Utility getBMIJudge:_lblAvgWeight.text]
                    ];
    }

    [_db dbClose];
}

- (void) createGraph{
    [_viewGraph removeFromSuperview];
    
    NSString * screenSize = [Utility screenSize];
    int viewWidth; int viewHeight;
    if([screenSize isEqual:@"4.7Inch"]){
        viewWidth = 375; viewHeight = 280;
    }else if([screenSize isEqual:@"5.5Inch"]){
        viewWidth = 414; viewHeight = 280;
    }else{
        viewWidth = 320; viewHeight = 280;
    }

    _viewGraph = [[ViewGraphLine alloc] initWithFrame:CGRectMake(0, 85, viewWidth, viewHeight)];
//    _viewGraph = [[ViewGraphLine alloc] initWithFrame:CGRectMake(0, 85, 320, 280)];
    
    _viewGraph.viewX = 0;
    _viewGraph.viewY = 0;
    _viewGraph.viewWidth = viewWidth;
    _viewGraph.viewHeight = viewHeight;
    
    _viewGraph.xTitle = @"";
    _viewGraph.yTitle = @"";
    
    _viewGraph.xLabelArr = _tableLabelVal;
    _viewGraph.xDataArr  = _tableDataXVal;
    _viewGraph.yDataArr  = _tableDataYVal;
    
    //kg
    NSLog(@"minW %f", _minWeight);
    NSLog(@"maxW %f", _maxWeight);

    
    double min;
    double length;
    double interVal;

    min      = floor(_minWeight) - 1;
    if(min < 0){min=0;} // 何も入力していない場合
    if (floor(_maxWeight) - floor(_minWeight) < 5){
        interVal = 1;
        length   = 5;
    }else if(_maxWeight - _minWeight < 10){
        interVal = 2;
        length   = 10;
    }else if(_maxWeight - _minWeight < 15){
        interVal = 3;
        length   = 15;
    }else{
        interVal = 4;
        length   = 20;
    }

    _viewGraph.yMin    = min;
    _viewGraph.yLength = length;
    _viewGraph.yIntervalLength = interVal; //(_maxWeight  - _minWeight) + 1 / 5;
    
    [_viewGraph createGraphLine];
    [self.view addSubview:_viewGraph];
}

-(void)backDate:(id)sender {
    // 1ヶ月前に戻る
    [self dateChange:-1];
}
-(void)goDate:(id)sender {
    // 1ヶ月前に戻る
    [self dateChange:1];
}

-(void)dateChange : (int)addMonth{
    // 現在表示中の日付から月を変更
    NSString *dateStr = [NSString stringWithFormat:@"%@/%@/01"
                         ,[self.pDateMonth substringWithRange:NSMakeRange(0, 4)]
                         ,[self.pDateMonth substringWithRange:NSMakeRange(4 ,2)]
                         ];
    NSDateFormatter *df  = [[NSDateFormatter alloc]init]; //変換用
    df.dateFormat = @"yyyy/MM/dd";
    
    NSDate *date = [df dateFromString:dateStr];
    NSDateComponents *comps= [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [comps setMonth:addMonth];
    NSDate *date2 = [calendar dateByAddingComponents:comps toDate:date options:0];
    
    df.dateFormat = @"yyyyMM";
    self.pDateMonth = [df stringFromDate:date2];
    
    // 初期表示
    [self initilizeData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //  通知受信の設定
    NSNotificationCenter*   nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(applicationWillEnterForeground) name:@"applicationWillEnterForeground" object:nil];

     _setthingData = [[Setthings alloc] init];
    [self initilizeData];
}

- (void)applicationWillEnterForeground
{
    // 日付初期化
    [self initDate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
