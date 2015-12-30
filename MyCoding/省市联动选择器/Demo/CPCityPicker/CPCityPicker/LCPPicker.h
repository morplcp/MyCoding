//
//  LCPPicker.h
//  FoodMemory
//
//  Created by morplcp on 15/12/10.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityDataManager.h"
typedef void (^CytyBlock)(NSString *city);
@interface LCPPicker : UIView

@property(nonatomic, copy)CytyBlock selectCity;
// 字典初始化
- (instancetype)initWithDictionary:(NSArray *)cityArray;

// 显示
- (void)show;

- (void)close;

@end
