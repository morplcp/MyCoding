//
//  CityDataManager.h
//  FoodMemory
//
//  Created by morplcp on 15/12/10.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityDataManager : NSObject

@property (nonatomic, strong)NSArray *cityArray;

+(CityDataManager *)sharedDataManager;

@end
