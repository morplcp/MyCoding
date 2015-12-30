//
//  LCPGetRongCloudToken.m
//  AFNetworkingTest
//
//  Created by morplcp on 15/11/28.
//  Copyright © 2015年 李成鹏.com. All rights reserved.
//

#import "LCPGetRongCloudToken.h"
#define BASE_URL @"https://api.cn.rong.io/user/getToken.json"
@implementation LCPGetRongCloudToken

- (void)getTokenWithUserId:(NSString *)userId Name:(NSString *)name PortraitUri:(NSString *)portraitUri CallBack:(MyBlock)callBack{
    if (!_app_key || !_appSecret) {
        NSLog(@"请先设置appkey和appSecret");
        return;
    }
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 @"name":name,
                                 @"portraitUri":portraitUri,
                                 };
    __block NSString *token = nil;
    [self getNetDataWithParameter:parameters CallBack:^(id data) {
        if (data == nil) {
            callBack(nil);
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                id parseData = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
                token = parseData[@"token"];
                callBack(token);
            });
        }
    }];
}

// 获取网络数据私有方法
- (void)getNetDataWithParameter:(NSDictionary *)params CallBack:(MyBlock)callBack{
    // 创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BASE_URL]];
    // 设置请求方式
    [request setHTTPMethod:@"post"];
    // 设置请求参数
    NSData *tempData = [self httpBodyFromParamDictionary:params];
    [request setHTTPBody:tempData];
    NSString *appkey = self.app_key;
    NSString *nonce = [NSString stringWithFormat:@"%d", arc4random_uniform(10000)];
    NSString *Timestamp = [NSString stringWithFormat:@"%ld",time(NULL)];
    NSString *appSecret = self.appSecret;
    [request setValue:appkey forHTTPHeaderField:@"App-Key"];
    [request setValue:nonce forHTTPHeaderField:@"Nonce"];
    [request setValue:Timestamp forHTTPHeaderField:@"Timestamp"];
    [request setValue:appSecret forHTTPHeaderField:@"appSecret"];
    [request setValue:[self getSHA1String] forHTTPHeaderField:@"Signature"];
    // 创建session会话
    NSURLSession *session = [NSURLSession sharedSession];
    // 创建任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data == nil) {
            callBack(nil);
        }else{
            callBack(data);
        }
    }];
    [task resume];
}

// 请求参数设置
- (NSData *)httpBodyFromParamDictionary:(NSDictionary *)params
{
    NSMutableString * data = [NSMutableString string];
    for (NSString * key in params.allKeys) {
        [data appendFormat:@"%@=%@&",key,params[key]];
    }
    return [[data substringToIndex:data.length-1] dataUsingEncoding:NSUTF8StringEncoding];
}


/**
 *  获取sha1哈希加密字符串
 *
 *  @return 哈希加密字符串
 */
- (NSString *)getSHA1String{
    if (self.appSecret) {
        NSString *str = [NSString stringWithFormat:@"%@%@%@",self.appSecret,[NSString stringWithFormat:@"%d",arc4random_uniform(10000)],[NSString stringWithFormat:@"%ld",time(NULL)]];
        CocoaSecurityResult *result_sha1 = [CocoaSecurity sha1:str];
        return result_sha1.hex;
    }else{
        NSLog(@"请设置appSecret");
        return nil;
    }
}

@end
