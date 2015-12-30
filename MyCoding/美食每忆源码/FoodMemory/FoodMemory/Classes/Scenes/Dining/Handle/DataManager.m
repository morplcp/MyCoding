//
//  DataManager.m
//  FoodMemory
//
//  Created by morplcp on 15/12/12.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "DataManager.h"

static DataManager *manager = nil;

@interface DataManager ()

@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation DataManager

+(DataManager *)shareaManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self requestData];
    }
    return self;
}

- (void)requestData{
    [LCPNetWorking getNetWorkingData:kMusicList_URL Method:@"get" Parameter:nil CallBack:^(id object, id error) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:object];
        NSArray *array = dict[@"songs"];
        self.imgURL = dict[@"img"];
        for (NSDictionary * dic in array) {
            // 初始化model
            Music * music = [Music new];
            [music setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:music];
        }
        [self request];
    }];
}

- (void)request{
    [LCPNetWorking getNetWorkingData:kMusic Method:@"get" Parameter:nil CallBack:^(id object, id error) {
        NSArray *array = object[@"songs"];
        for (NSDictionary * dic in array) {
            // 初始化model
            Music * music = [Music new];
            [music setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:music];
        }
        self.callBack();
    }];
}

- (Music *)musicModelWithIndex:(NSInteger)index{
    return self.allMusic[index];
}

- (NSArray *)allMusic{
    return self.dataArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
