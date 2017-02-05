//
//  ViewControllerHistoryNavi.h
//  Weight Log
//
//  Created by 前川 幸広 on 2014/09/07.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerTab.h"
#import "ViewTabData.h"

@interface ViewControllerHistoryNavi : UINavigationController <ViewControllerTabDelegate>
{
    ViewTabData *_tempData;
}

@end
