//
//  ViewController.m
//  Weight Log
//
//  Created by 前川 幸広 on 2014/08/10.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewController.h"
#import "DBConnector.h"
#import "EntityDWeight.h"
#import "Utility.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    
    // Do any additional setup after loading the view, typically from a nib.

    self.txtWeight.delegate  = self;
    self.txtFat.delegate     = self;
    self.txtWeight2.delegate = self;
    self.txtFat2.delegate    = self;
    
    // 背景をキリックしたら、キーボードを隠す
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    
    //ボタンの枠
    [[self.btnWeightMinus layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[self.btnWeightMinus layer] setBorderWidth:1.0];
    [[self.btnWeightPlus layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[self.btnWeightPlus layer] setBorderWidth:1.0];

    [[self.btnFatMinus layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[self.btnFatMinus layer] setBorderWidth:1.0];
    [[self.btnFatPlus layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[self.btnFatPlus layer] setBorderWidth:1.0];

    [[self.btnWeight2Minus layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[self.btnWeight2Minus layer] setBorderWidth:1.0];
    [[self.btnWeight2Plus layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[self.btnWeight2Plus layer] setBorderWidth:1.0];

    [[self.btnFat2Minus layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[self.btnFat2Minus layer] setBorderWidth:1.0];
    [[self.btnFat2Plus layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[self.btnFat2Plus layer] setBorderWidth:1.0];

    // 初回起動時用
    _db = [[DBConnector alloc] init];
}

// データ初期設定
- (void)initilizeData{
    _tempData = [ViewTabData sharedManager];
    _setthingData = [[Setthings alloc] init];
    
    // 初回起動チェック
    if(_setthingData.isFirstLogin){
        // 初回のガイダンス
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"はじめに"
                              message:@"設定メニューからプロフィールを登録してください。"
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil
                              ];
        alert.delegate = self;
        [alert show];
        
        // 次回以降は起動しないようにする
        _setthingData.isFirstLogin = NO;
        [_setthingData saveIsFirstLogin];
    }
    
    // 目標
    self.lblSetthingWeight.text = @"";
    if(![_setthingData.bodyWeight isEqual:@""]){
        self.lblSetthingWeight.text = [NSString stringWithFormat:@"%@Kg",_setthingData.bodyWeight];
    }

    // 日付の設定
    NSDateFormatter *df  = [[NSDateFormatter alloc]init];
    [df setLocale:[NSLocale currentLocale]];
    [df setDateStyle:NSDateFormatterFullStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
 
    NSLog(@"%@" ,_editDate);
    
    NSDate *yesterDayDate;
    BOOL isMainTab = NO;
    // 当日分のtabが押された場合は当日分
    if(_tempData.isMainTab){
        isMainTab = YES;
        _date = [NSDate date];
    }else{
        _date = _tempData.editDate;
    }
    
    _barTitle= [df stringFromDate:_date];
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.navigationItem.title = _barTitle;
    self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.000];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    df.dateFormat = @"yyyy/MM/dd";
    NSString *strDate;
    strDate = [df stringFromDate:_date];

    // 初期表示用のデータ取得と初期表示
    [_db dbOpen];
    EntityDWeight * entityDWeight = [[EntityDWeight alloc] initWithSelect:_db :strDate];
    
    self.txtWeight.text  = [Utility convDecimalData:entityDWeight.pWeight];
    self.txtFat.text     = [Utility convDecimalData:entityDWeight.pFat];
    self.txtWeight2.text = [Utility convDecimalData:entityDWeight.pWeight2];
    self.txtFat2.text    = [Utility convDecimalData:entityDWeight.pFat2];
    self.txtWeight.placeholder  = @"";
    self.txtFat.placeholder     = @"";
    self.txtWeight2.placeholder = @"";
    self.txtFat2.placeholder    = @"";
    
    if(entityDWeight.pMealLv.length == 0){
        self.segMeal.selectedSegmentIndex = 2;
    }else{
        self.segMeal.selectedSegmentIndex = entityDWeight.pMealLv.intValue;
    }
    if(entityDWeight.pExerciseLv.length == 0){
        self.segExercise.selectedSegmentIndex = 2;
    }else{
        self.segExercise.selectedSegmentIndex = entityDWeight.pExerciseLv.intValue;
    }
    
    //当日分の入力がない場合は前日をプレイスフォルダに設定
    //if(isMainTab){
        // 前日日付を求める
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:-1];
        yesterDayDate = [calendar dateByAddingComponents:comps toDate:_date options:0];

        df.dateFormat = @"yyyy/MM/dd";
        NSString *strYesterDayDate = [df stringFromDate:yesterDayDate];
        EntityDWeight * entityDWeight2 = [[EntityDWeight alloc] initWithSelect:_db :strYesterDayDate];
        //前日分に入力があれば
        if(entityDWeight2.isExist){
            if(self.txtWeight.text.length == 0){
                self.txtWeight.placeholder  = [Utility convDecimalData:entityDWeight2.pWeight];
            }
            if(self.txtFat.text.length == 0){
                self.txtFat.placeholder  = [Utility convDecimalData:entityDWeight2.pFat];
            }
            if(self.txtWeight2.text.length == 0){
                self.txtWeight2.placeholder  = [Utility convDecimalData:entityDWeight2.pWeight2];
            }
            if(self.txtFat2.text.length == 0){
                self.txtFat2.placeholder  = [Utility convDecimalData:entityDWeight2.pFat2];
            }
        }
    //}
    
    [_db dbClose];
}

// キーボードを隠す処理
- (void)closeKeyboard {
    [self.view endEditing: YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField{
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField*)textField{
    // 値チェック
    if (![Utility chkDecimal:self.txtWeight.text]) {self.txtWeight.text  = @"";}
    if (![Utility chkDecimal:self.txtFat.text])    {self.txtFat.text     = @"";}
    if (![Utility chkDecimal:self.txtWeight2.text]){self.txtWeight2.text = @"";}
    if (![Utility chkDecimal:self.txtFat2.text])   {self.txtFat2.text    = @"";}

    // 値補正
    self.txtWeight.text  = [Utility convDecimalData:self.txtWeight.text];
    self.txtFat.text     = [Utility convDecimalData:self.txtFat.text];
    self.txtWeight2.text = [Utility convDecimalData:self.txtWeight2.text];
    self.txtFat2.text    = [Utility convDecimalData:self.txtFat2.text];
    
    //入力データ更新
    [self updateWeight];
}

-(void)updateWeight{
    NSDateFormatter *df  = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy/MM/dd";
    NSString *strDate;
    strDate = [df stringFromDate:_date];

    df.dateFormat = @"yyyyMM";
    NSString *strDate2;
    strDate2 = [df stringFromDate:_date];
    
    [_db dbOpen];
    EntityDWeight * entityDWeight = [[EntityDWeight alloc] initWithSelect:_db :strDate];
    
    // 未入力の未登録は登録しない、未入力の登録済は削除
    if(   [self.txtWeight.text length]  == 0
       && [self.txtFat.text length]     == 0
       && [self.txtWeight2.text length] == 0
       && [self.txtFat2.text length]    == 0
       ){
        if(entityDWeight.isExist == YES){
            [entityDWeight doDelete:_db];
        }
    }
    else{
        entityDWeight.pKeyDate    = strDate;
        entityDWeight.pDateMonth  = strDate2;
        entityDWeight.pWeight     = self.txtWeight.text;
        entityDWeight.pFat        = self.txtFat.text;
        entityDWeight.pWeight2    = self.txtWeight2.text;
        entityDWeight.pFat2       = self.txtFat2.text;
        entityDWeight.pMealLv     = [NSString stringWithFormat:@"%ld" ,(long)self.segMeal.selectedSegmentIndex];
        entityDWeight.pExerciseLv = [NSString stringWithFormat:@"%ld" ,(long)self.segExercise.selectedSegmentIndex];
        
        if(entityDWeight.isExist == YES){
            [entityDWeight doUpdate:_db];
        }else
        {
            [entityDWeight doInsert:_db];
        }
    }

    [_db dbClose];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //  通知受信の設定
    NSNotificationCenter*   nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(applicationWillEnterForeground) name:@"applicationWillEnterForeground" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    //初期表示
    [self initilizeData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (![self.navigationController.viewControllers containsObject:self]) {
        //戻るを押された
        [self updateWeight];
    }
    
    [super viewWillDisappear:animated];
}

- (void)applicationWillEnterForeground
{
    [self initilizeData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segMealAct:(id)sender {
    [self updateWeight];
}

- (IBAction)segExerciseAct:(id)sender {
    [self updateWeight];
}

- (IBAction)actBtnWeightMinus:(id)sender {
    NSString *baseData;
    if ([self.txtWeight.text length] > 0){
        baseData = self.txtWeight.text;
    }else if ([self.txtWeight.placeholder length] > 0){
        self.txtWeight.text = self.txtWeight.placeholder;
        return;
    }else{return;}
    self.txtWeight.text = [Utility calcData:0 :baseData];
    [self updateWeight];
}

- (IBAction)actBtnWeightPlus:(id)sender {
    NSString *baseData;
    if ([self.txtWeight.text length] > 0){
        baseData = self.txtWeight.text;
    }else if ([self.txtWeight.placeholder length] > 0){
        self.txtWeight.text = self.txtWeight.placeholder;
        return;
    }else{return;}
    self.txtWeight.text = [Utility calcData:1 :baseData];
    [self updateWeight];
}
- (IBAction)actBtnFatMinus:(id)sender {
    NSString *baseData;
    if ([self.txtFat.text length] > 0){
        baseData = self.txtFat.text;
    }else if ([self.txtFat.placeholder length] > 0){
        self.txtFat.text = self.txtFat.placeholder;
        return;
    }else{return;}
    self.txtFat.text = [Utility calcData:0 :baseData];
    [self updateWeight];
}

- (IBAction)actBtnFatPlus:(id)sender {
    NSString *baseData;
    if ([self.txtFat.text length] > 0){
        baseData = self.txtFat.text;
    }else if ([self.txtFat.placeholder length] > 0){
        self.txtFat.text = self.txtFat.placeholder;
        return;
    }else{return;}
    self.txtFat.text = [Utility calcData:1 :baseData];
    [self updateWeight];
}
- (IBAction)actBtnWeight2Minus:(id)sender {
    NSString *baseData;
    if ([self.txtWeight2.text length] > 0){
        baseData = self.txtWeight2.text;
    }else if ([self.txtWeight2.placeholder length] > 0){
        self.txtWeight2.text = self.txtWeight2.placeholder;
        return;
    }else{return;}
    self.txtWeight2.text = [Utility calcData:0 :baseData];
    [self updateWeight];
}

- (IBAction)actBtnWeight2Plus:(id)sender {
    NSString *baseData;
    if ([self.txtWeight2.text length] > 0){
        baseData = self.txtWeight2.text;
    }else if ([self.txtWeight2.placeholder length] > 0){
        self.txtWeight2.text = self.txtWeight2.placeholder;
        return;
    }else{return;}
    self.txtWeight2.text = [Utility calcData:1 :baseData];
    [self updateWeight];
}
- (IBAction)actBtnFat2Minus:(id)sender {
    NSString *baseData;
    if ([self.txtFat2.text length] > 0){
        baseData = self.txtFat2.text;
    }else if ([self.txtFat2.placeholder length] > 0){
        self.txtFat2.text = self.txtFat2.placeholder;
        return;
    }else{return;}
    self.txtFat2.text = [Utility calcData:0 :baseData];
    [self updateWeight];
}

- (IBAction)actBtnFat2Plus:(id)sender {
    NSString *baseData;
    if ([self.txtFat2.text length] > 0){
        baseData = self.txtFat2.text;
    }else if ([self.txtFat2.placeholder length] > 0){
        self.txtFat2.text = self.txtFat2.placeholder;
        return;
    }else{return;}
    self.txtFat2.text = [Utility calcData:1 :baseData];
    [self updateWeight];
}

@end
