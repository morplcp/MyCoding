//
//  LCPGetRongCloudToken.h
//  AFNetworkingTest
//
//  Created by morplcp on 15/11/28.
//  Copyright © 2015年 李成鹏.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaSecurity.h"
typedef void (^MyBlock)(id);
@interface LCPGetRongCloudToken : NSObject
@property(nonatomic, strong) NSString * app_key;
@property(nonatomic, strong) NSString * appSecret;

/**
 *  获取融云Token接口
 */
- (void)getTokenWithUserId:(NSString *)userId Name:(NSString *)name PortraitUri:(NSString *)portraitUri CallBack:(MyBlock)callBack;

@end
