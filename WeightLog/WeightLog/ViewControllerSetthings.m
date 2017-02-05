//
//  ViewControllerSetthings.m
//  Weight Log
//
//  Created by 前川 幸広 on 2014/09/07.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerSetthings.h"
#import "Setthings.h"
#import "Utility.h"

@interface ViewControllerSetthings ()

@end

@implementation ViewControllerSetthings

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
    [self.view addSubview:self.nadView]; // 最初から表示する場合
    [self.nadView setDelegate:self];

    
    self.bodyHeight.delegate = self;
    self.bodyWeight.delegate = self;
    
    // 背景をキリックしたら、キーボードを隠す
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];

    // Do any additional setup after loading the view.
    [[self.btnAllResetOutlet layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[self.btnAllResetOutlet layer] setBorderWidth:1.0];
    
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.navigationItem.title = @"設定";
    self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.000];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

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
    if (![Utility chkDecimal:self.bodyHeight.text]){self.bodyHeight.text = @"";}
    if (![Utility chkDecimal:self.bodyWeight.text]){self.bodyWeight.text = @"";}

    // 値補正
    self.bodyHeight.text  = [NSString stringWithFormat:@"%.1f",self.bodyHeight.text.doubleValue];
    self.bodyWeight.text  = [Utility convDecimalData:self.bodyWeight.text];

    // 保存処理
    [self saveSetthings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) saveSetthings{
    _setthingData.bodyHeight = self.bodyHeight.text;
    _setthingData.bodyWeight = self.bodyWeight.text;
    _setthingData.unit       = [self.segUnit selectedSegmentIndex];
    [_setthingData saveAll];
}

- (void) loadSetthings{
    self.bodyHeight.text              = _setthingData.bodyHeight;
    self.bodyWeight.text              = _setthingData.bodyWeight;
    self.segUnit.selectedSegmentIndex = _setthingData.unit;
}

- (IBAction)actSegUnit:(id)sender {
    // 保存処理
    [self saveSetthings];
}

- (IBAction)btnAllReset:(id)sender {
    // １行で書くタイプ（複数ボタンタイプ）
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"すべてのデータを消去" message:@"本当に削除しますか。"
                              delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
    [alert show];
}

// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            // 設定情報初期化
            [_setthingData resetAllData];
            
            _setthingData = [[Setthings alloc] init];
            [self loadSetthings];
            
            _dbInit = [[DBInit alloc]init];
            [_dbInit resetAllData];

            break;
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    _setthingData = [[Setthings alloc] init];
    [self loadSetthings];
    
    NSLog(@"%@",[Utility getBMI:_setthingData.bodyWeight]);
}
@end
