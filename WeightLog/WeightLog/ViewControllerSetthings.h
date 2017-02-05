//
//  ViewControllerSetthings.h
//  Weight Log
//
//  Created by 前川 幸広 on 2014/09/07.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewController.h"
#import "Setthings.h"
#import "DBInit.h"
#import "NADView.h"
#import "ViewTabData.h"

@interface ViewControllerSetthings : UIViewController<UITextFieldDelegate,NADViewDelegate>
{
    Setthings *_setthingData;
    DBInit *_dbInit;
    
    ViewTabData * _tempData;

}
@property (nonatomic, retain) NADView * nadView;
@property (weak, nonatomic) IBOutlet UITextField *bodyHeight;
@property (weak, nonatomic) IBOutlet UITextField *bodyWeight;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segUnit;
- (IBAction)actSegUnit:(id)sender;
- (IBAction)btnAllReset:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAllResetOutlet;
@end
