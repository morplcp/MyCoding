//
//  UIViewController+AlertMsg.h
//  FoodMemory
//
//  Created by morplcp on 15/12/5.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Option)(BOOL result);
@interface UIViewController (AlertMsg)

// 单纯提示(一定时间后消失)
- (void)alertNoAction:(NSString *)msg Duration:(NSTimeInterval)time;

// 普通提示
- (void)alert:(NSString *)msg;

// 带选择的提示
- (void)confim:(NSString *)msg Handel:(Option)handel;


@end
