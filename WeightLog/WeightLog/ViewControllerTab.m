//
//  ViewControllerTab.m
//  Weight Log
//
//  Created by 前川 幸広 on 2014/08/12.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerTab.h"

@interface ViewControllerTab ()

@end

@implementation ViewControllerTab

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    // Do any additional setup after loading the view.
    
    _setthingData = [[Setthings alloc] init];
    //初回起動時の判定
    if([_setthingData.appVersion length] == 0){
        // 設定初期化
        [_setthingData resetAllData];
        
        // DB初期化
        _dbInit = [[DBInit alloc]init];
        [_dbInit initData];
    }

    // 起動時当日日付にしたい
    _tempData = [ViewTabData sharedManager];
    _tempData.isMainTab = YES;

}

- (void)viewWillAppear:(BOOL)animated
{
    // 必ず親クラスのviewWillAppear:メソッドを呼ぶこと
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// タブ選択delegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    // navigation bar には適用できなかったので
    if ([viewController conformsToProtocol:@protocol(ViewControllerTabDelegate)]) {
        [(UIViewController < ViewControllerTabDelegate > *) viewController didSelect : self];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
