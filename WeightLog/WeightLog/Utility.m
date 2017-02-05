//
//  Utility.m
//  Weight Log
//
//  Created by 前川 幸広 on 2014/09/07.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "Utility.h"
#import "Setthings.h"

@implementation Utility

// BMI指数名
+ (NSString *)getBMIJudge : (NSString*) bodyWeight{
    NSString *outputValue;
    
    NSString *bmiDataStr;
    double bmiData;

    //BMI指数が取得
    bmiDataStr = [self getBMI : bodyWeight];
    if([bmiDataStr isEqual:@""]){return @"";} //取得できない場合は実施しない
    bmiData = bmiDataStr.doubleValue;
    
    //BMI判定
    if     (bmiData < 20.0){outputValue = @"痩せぎみ";}
    else if(20.0 <= bmiData && bmiData < 24.0){outputValue = @"普通";}
    else if(24.0 <= bmiData && bmiData < 26.5){outputValue = @"太りぎみ";}
    else{outputValue = @"太りすぎ";}
    return outputValue;
}
// BMI指数
+ (NSString *)getBMI : (NSString*) bodyWeight{
    NSString *outputValue;
    Setthings *setthingData = [[Setthings alloc] init];
    
    // 体重未入力または身長未入力は実施しない
    if(  [bodyWeight isEqual:@""]
      || [setthingData.bodyHeight isEqual:@""]
    ){
        return @"";
    }
    
    // 身長(m) の二乗
    double height = pow(setthingData.bodyHeight.doubleValue / 100 ,2);
    
    NSLog(@"%f / %f",bodyWeight.doubleValue,height);
    
    // BMI指数 (体重 / 身長(m) の二乗)
    outputValue = [NSString stringWithFormat:@"%.1f",bodyWeight.doubleValue / height];

    NSLog(@"%@",outputValue);

    return outputValue;
}


// + - の加算
+ (NSString *)calcData :(int)mode :(NSString*)inputValue{
    double calcVal = 0;
    NSString *outputValue;
    Setthings *setthingData = [[Setthings alloc] init];

    if(setthingData.unit == 0){
        // 50g
        if(mode == 0){
            calcVal = -0.05;
        }else{
            calcVal =  0.05;
        }
    }else{
        // 100g
        if(mode == 0){
            calcVal = -0.1;
        }else{
            calcVal =  0.1;
        }
    }

    if(setthingData.unit == 0){
        // 50g
        outputValue = [NSString stringWithFormat:@"%.2f", inputValue.doubleValue + calcVal];
    }else{
        // 100g
        outputValue = [NSString stringWithFormat:@"%.1f", inputValue.doubleValue + calcVal];
    }

    NSLog(@"%@",outputValue);
    if(outputValue.intValue == 0){
        outputValue = @"";
    }
    return outputValue;
}

// 変換
+ (NSString *)convDecimalData :(NSString*)inputValue
{
    NSString *outputValue;
    Setthings *setthingData = [[Setthings alloc] init];
    
    if(setthingData.unit == 0){
        // 50g
        outputValue = [NSString stringWithFormat:@"%.2f", inputValue.doubleValue];
    }else{
        // 100g
        outputValue = [NSString stringWithFormat:@"%.1f", inputValue.doubleValue];
    }
    
    NSLog(@"%@",outputValue);
    if(outputValue.intValue == 0){
        outputValue = @"";
    }
    return outputValue;
}

// 小数かチェック
+ (BOOL)chkDecimal:(NSString *)checkString
{
    NSString *checkString2;
    
    //未入力は許可
    if ([checkString length] == 0){return YES;}
    
    // .以外で数値チェック
    checkString2 = [checkString stringByReplacingOccurrencesOfString:@"." withString:@""];
    if(![self chkNumeric:checkString2]){return NO;}
    
    // 先頭.はエラー
    checkString2 = [checkString substringToIndex:1];
    if([checkString2 isEqual:@"."]){return NO;}

    // 後方.はエラー
    checkString2 = [checkString substringFromIndex:1];
    if([checkString2 isEqual:@"."]){return NO;}

    // ピリオド複数はエラー
    NSRange range  = [checkString rangeOfString:@"."];
    NSRange range2 = [checkString rangeOfString:@"." options:NSBackwardsSearch];
    
    // ピリオド見つかった場合
    if(range.location != NSNotFound){
        if(range.location != range2.location){
            return NO;
        }
    }
    
    return YES;
}

// 数字のみか （引数は文字列なので注意）
+ (BOOL)chkNumeric:(NSString *)checkString
{
    NSCharacterSet *stringCharacterSet = [NSCharacterSet characterSetWithCharactersInString:checkString];
    
    NSCharacterSet *digitCharacterSet = [NSCharacterSet decimalDigitCharacterSet];
    if ([digitCharacterSet isSupersetOfSet:stringCharacterSet])
    {
        //OK
        return YES;
    } else {
        //NG
        return NO;
    }
}

// iPhone画面サイズ判定
+ (NSString *)screenSize{
    NSString *retValue;
    
    //スクリーンサイズの取得
    CGRect rect1 = [[UIScreen mainScreen] bounds];
    NSLog(@"rect1.size.width : %f , rect1.size.height : %f", rect1.size.width, rect1.size.height);
    
    if(rect1.size.width == 320 && rect1.size.height == 568){
        retValue = @"4Inch";
    }else if(rect1.size.width == 375 && rect1.size.height == 667){
        retValue = @"4.7Inch";
    }else if(rect1.size.width == 414 && rect1.size.height == 736){
        retValue = @"5.5Inch";
    }
    return retValue;
}

@end
