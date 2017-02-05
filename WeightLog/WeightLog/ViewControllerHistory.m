//
//  ViewControllerHistory.m
//  Weight Log
//
//  Created by 前川 幸広 on 2014/08/12.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerHistory.h"
#import "EntityDWeight.h"
#import "Utility.h"

@interface ViewControllerHistory ()

@end

@implementation ViewControllerHistory

- (void)viewDidLoad {
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
    
    //self.nadView = [[NADView alloc] initWithFrame:CGRectMake(0, 470, 320, 50)];
    // (3) ログ出力の指定 [self.nadView setIsOutputLog:NO];
    // (4) set apiKey, spotId.
    [self.nadView setNendID:@"e4fc45fd1832bdd03fffaf417969c3f5b5be1417" spotID:@"230076"];
    [self.nadView setDelegate:self]; //(5)
    [self.nadView load]; //(6)
    //[self.view addSubview:self.nadView]; // 最初から表示する場合
    [self.nadView setDelegate:self];

    // デリゲート
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    _db = [[DBConnector alloc] init];

    [[self tableView] setBackgroundColor:[UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0]];

    // 日付初期化
    [self initDate];
}

- (void) getData{
    _tableKey     = [[NSMutableArray alloc] init];
    _tableVal     = [[NSMutableArray alloc] init];

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
    
    NSLog(@"%@",dateStr);
    NSLog(@"%@",date);
    
    comps = [[NSDateComponents alloc] init];
    comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    NSInteger dateMonthNow = comps.month;
    
    int addDay = 0;
    
    [_db dbOpen];

    while (true){
        comps = [[NSDateComponents alloc] init];
        [comps setDay:addDay];
        NSDate *date2 = [calendar dateByAddingComponents:comps toDate:date options:0];
        
        // 年・月・日を取得
        comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date2];
        NSDateComponents* comps2 = [calendar components:NSWeekdayCalendarUnit fromDate:date2];
    
        if (dateMonthNow != comps.month){break;}
        
        NSString *date2Str;
        df.dateFormat = @"yyyy/MM/dd";
        date2Str = [df stringFromDate:date2];
        NSLog(@"%@",date2Str);
        EntityDWeight * entityDWeight = [[EntityDWeight alloc] initWithSelect:_db :date2Str];
        
        NSString *tableValue = @"";
        tableValue = [NSString stringWithFormat:@"%ld,%ld,(朝),%@,%@,(夜),%@,%@,%@,%@"
                    ,(long)comps.day
                    ,(long)comps2.weekday
                      
                    ,[Utility convDecimalData:entityDWeight.pWeight]
                    ,[Utility convDecimalData:entityDWeight.pFat]
                      
                    ,[Utility convDecimalData:entityDWeight.pWeight2]
                    ,[Utility convDecimalData:entityDWeight.pFat2]
                    ,entityDWeight.pMealLv
                    ,entityDWeight.pExerciseLv
                    ];
        
        [_tableKey addObject:date2];
        [_tableVal addObject:tableValue];
        
        addDay++;
    }
    
    [_db dbClose];
}

/**
 * テーブルのセルの数を返す
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableKey count];
}

// セルの高さを返す. セルが生成される前に実行されるので独自に計算する必要がある
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}
/**
 * 指定されたインデックスパスのセルを作成する
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    NSArray * arrValue = [[_tableVal objectAtIndex:indexPath.row] componentsSeparatedByString:@","];
    
    int idxRow = 0;
    for (NSString *valueRow in arrValue){
        //位置変数
        int x     = 0; int y      = 0;
        int width = 0; int height = 0;
        float fontSize = 15.0f;
        
        NSString *value = @"";
        //表示位置と内容の編集
        switch (idxRow) {
            case 0:
                // 日付
                fontSize = 15.0f;
                x = 15; y = 9;  width = 50; height = 24;
                if ([valueRow length] > 0){
                    value = [NSString stringWithFormat:@"%@ 日" ,valueRow];
                }
                break;
            case 1:
                // 曜日
                fontSize = 15.0f;
                x = 15; y = 26; width = 50; height = 24;
                if ([valueRow length] > 0){
                    value = [self getDayValue:valueRow.intValue];
                }
                break;
            case 2:
                // 朝ラベル
                x = 60; y = 0;  width = 50; height = 24;
                if ([valueRow length] > 0){
                    value = [NSString stringWithFormat:@"%@" ,valueRow];
                }
                break;
            case 3:
                // 体重(朝)
                x = 93; y = 0;  width = 60; height = 24;
                if ([valueRow length] > 0){
                    value = [NSString stringWithFormat:@"%@Kg" ,valueRow];
                }
                break;
            case 4:
                // 体脂肪率(朝)
                x = 163; y = 0; width = 60; height = 24;
                if ([valueRow length] > 0){
                    value = [NSString stringWithFormat:@"%@%%" ,valueRow];
                }
                break;
            case 5:
                // 夜ラベル
                x = 60; y = 17;  width = 50; height = 24;
                if ([valueRow length] > 0){
                    value = [NSString stringWithFormat:@"%@" ,valueRow];
                }
                break;
            case 6:
                // 体重(夜)
                x = 93; y = 17;  width = 60; height = 24;
                if ([valueRow length] > 0){
                    value = [NSString stringWithFormat:@"%@Kg" ,valueRow];
                }
                NSLog(@"%@",value);
                break;
            case 7:
                // 体脂肪率(夜)
                x = 163; y = 17; width = 60; height = 24;
                if ([valueRow length] > 0){
                    value = [NSString stringWithFormat:@"%@%%" ,valueRow];
                }
                break;
            case 8:
                // 食事LV
                fontSize = 14.4f;
                x = 58; y = 34;  width = 117; height = 24;
                if ([valueRow length] > 0){
                    value = [NSString stringWithFormat:@"食事Lv%@" ,[self getLv:valueRow.intValue]];
                }
                break;
            case 9:
                // 運動LV
                fontSize = 14.4f;
                x = 179; y = 34;  width = 117; height = 24;
                if ([valueRow length] > 0){
                    value = [NSString stringWithFormat:@"運動Lv%@" ,[self getLv:valueRow.intValue]];
                }
                break;
                
            default:
                break;
        }

        //表示内容
        UILabel *labelCell;
        labelCell = [[UILabel alloc] initWithFrame:CGRectMake(x ,y ,width ,height)];
        labelCell.textColor = [UIColor whiteColor];
        labelCell.text = value;
        //labelCell.backgroundColor = [UIColor blueColor];
        
        UIFont *uiFont  = [UIFont systemFontOfSize:fontSize];
        [labelCell setFont:uiFont];

        [cell.contentView addSubview:labelCell];
        
        idxRow++;
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _editDate = [_tableKey objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"inputSegue" sender:self];
}


- (NSString *)getLv :(int)lv{
    NSString *retValue = @"";
    
    for (int i = 0; i <= lv; i++) {
        retValue = [NSString stringWithFormat:@"%@■",retValue];
    }
    NSLog(@"%@" ,retValue);
    return  retValue;
}

- (NSString *)getDayValue :(int)index{
    NSString* retValue = @"";
    switch (index) {
        case 1:
            retValue = @"(日)";
            break;
        case 2:
            retValue = @"(月)";
            break;
        case 3:
            retValue = @"(火)";
            break;
        case 4:
            retValue = @"(水)";
            break;
        case 5:
            retValue = @"(木)";
            break;
        case 6:
            retValue = @"(金)";
            break;
        case 7:
            retValue = @"(土)";
            break;
        default:
            break;
    }
    return retValue;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"inputSegue"]) {
        _tempData = [ViewTabData sharedManager];
        _tempData.editDate = _editDate;
        _tempData.isMainTab = NO;
        /*
        ViewController *view = segue.destinationViewController;
        view.editDate = _editDate;
        */
    }
}

// データ初期設定
- (void)initilizeData{
    
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
    [self.tableView reloadData];

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

-(void)initDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *df  = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyyMM";
    NSString *strDate;
    strDate = [df stringFromDate:date];
    self.pDateMonth = strDate;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //  通知受信の設定
    NSNotificationCenter*   nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(applicationWillEnterForeground) name:@"applicationWillEnterForeground" object:nil];

    [self initilizeData];
}

- (void)applicationWillEnterForeground
{
    // 日付初期化
    [self initDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
