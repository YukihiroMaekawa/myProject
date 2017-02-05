//
//  ViewController.h
//  Weight Log
//
//  Created by 前川 幸広 on 2014/08/10.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBConnector.h"
#import "ViewTabData.h"
#import "NADView.h"
#import "Setthings.h"

@interface ViewController : UIViewController<UITextFieldDelegate,NADViewDelegate>//,NADViewDelegate
{
    Setthings *_setthingData;
    DBConnector *_db;
    NSDate      *_date;
    ViewTabData * _tempData;
    NSString *_barTitle;
}

//入力
// 編集時の情報
@property (nonatomic) NSDate *editDate;
@property (nonatomic, retain) NADView * nadView;

@property (weak, nonatomic) IBOutlet UITextField *txtWeight;
@property (weak, nonatomic) IBOutlet UITextField *txtFat;
@property (weak, nonatomic) IBOutlet UITextField *txtWeight2;
@property (weak, nonatomic) IBOutlet UITextField *txtFat2;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segMeal;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segExercise;

@property (weak, nonatomic) IBOutlet UILabel *lblSetthingWeight;

// 体重（朝）のプラスとマイナスボタン
@property (weak, nonatomic) IBOutlet UIButton *btnWeightMinus;
@property (weak, nonatomic) IBOutlet UIButton *btnWeightPlus;
- (IBAction)actBtnWeightMinus:(id)sender;
- (IBAction)actBtnWeightPlus:(id)sender;

// 体脂肪（朝）のプラスとマイナスボタン
@property (weak, nonatomic) IBOutlet UIButton *btnFatMinus;
@property (weak, nonatomic) IBOutlet UIButton *btnFatPlus;
- (IBAction)actBtnFatMinus:(id)sender;
- (IBAction)actBtnFatPlus:(id)sender;

// 体重（夜）のプラスとマイナスボタン
@property (weak, nonatomic) IBOutlet UIButton *btnWeight2Minus;
@property (weak, nonatomic) IBOutlet UIButton *btnWeight2Plus;
- (IBAction)actBtnWeight2Minus:(id)sender;
- (IBAction)actBtnWeight2Plus:(id)sender;

// 体脂肪（夜）のプラスとマイナスボタン
@property (weak, nonatomic) IBOutlet UIButton *btnFat2Minus;
@property (weak, nonatomic) IBOutlet UIButton *btnFat2Plus;
- (IBAction)actBtnFat2Minus:(id)sender;
- (IBAction)actBtnFat2Plus:(id)sender;

//イベント
- (IBAction)segMealAct:(id)sender;
- (IBAction)segExerciseAct:(id)sender;
@end
