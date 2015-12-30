//
//  DataManager.h
//  FoodMemory
//
//  Created by morplcp on 15/12/12.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Music.h"
typedef void (^UpdateUI)();
@interface DataManager : NSObject

@property(nonatomic, strong)NSArray *allMusic;
@property(nonatomic, copy) UpdateUI  callBack;
@property(nonatomic, strong)NSString *imgURL;

+(DataManager *)shareaManager;

/**
 *  根据cell的索引返回一个model
 *
 *  @param index 索引值
 *
 *  @return model
 */
- (Music *)musicModelWithIndex:(NSInteger)index;

@end
