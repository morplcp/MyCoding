//
//  Dynamic.h
//  FoodMemory
//
//  Created by morplcp on 15/12/3.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface Dynamic : NSObject

@property (nonatomic, strong) NSString *uId; // 用户ID
@property (nonatomic, strong) NSString *content; // 动态内容
@property (nonatomic, strong) NSArray *imgArray; // 分享图片
@property (nonatomic, assign) NSInteger praise_count; // 点赞人数
@property (nonatomic, assign) NSInteger collection_count; // 收藏人数
@property (nonatomic, assign) NSInteger comments_count; // 评论人数
@property (nonatomic, strong) NSString *location_name; // 地点名

@end
