//
//  CityDataManager.m
//  FoodMemory
//
//  Created by morplcp on 15/12/10.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "CityDataManager.h"

@interface CityDataManager ()

@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation CityDataManager

static CityDataManager *manager = nil;
+(CityDataManager *)sharedDataManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [CityDataManager new];
        [manager parseData];
    });
    return manager;
}

- (void)parseData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"City" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.dataArray = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
}

- (NSArray *)cityArray{
    if (!_cityArray) {
        _cityArray = self.dataArray;
    }
    return _cityArray;
}

@end
