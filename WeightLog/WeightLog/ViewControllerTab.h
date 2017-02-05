//
//  ViewControllerTab.h
//  Weight Log
//
//  Created by 前川 幸広 on 2014/08/12.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBInit.h"
#import "Setthings.h"
#import "ViewTabData.h"


@interface ViewControllerTab : UITabBarController <UITabBarControllerDelegate>
{
    ViewTabData *_tempData;
    Setthings *_setthingData;
    DBInit *_dbInit;
}
@end

@protocol ViewControllerTabDelegate

- (void)didSelect:(ViewControllerTab *)tabBarController;

@end
