//
//  LeanCloudDBHelper.m
//  LoveChat
//
//  Created by morplcp on 15/11/30.
//  Copyright © 2015年 李成鹏.com. All rights reserved.
//

#import "LeanCloudDBHelper.h"
#import <objc/message.h>

@implementation LeanCloudDBHelper

// 保存对象
+ (void)saveObjectWithClassName:(NSString *)className Model:(id)model CallBack:(Callback)callback{
    AVObject *post = [AVObject objectWithClassName:className];
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList([model class], &propertyCount);
    for (int i = 0; i < propertyCount; i++) {
        objc_property_t property = propertys[i];
        const char * key = property_getName(property);
        id value = [model valueForKey:[NSString stringWithUTF8String:key]];
        [post setObject:value forKey:[NSString stringWithUTF8String:key]];
    }
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error != nil) callback(NO);
        else callback(YES);
        [post saveEventually];
    }];
}

// 删除对象
+ (void)deleteObjectWithClassName:(NSString *)className ObjectId:(NSString *)objectId CallBack:(Callback)callback{
    AVQuery *query = [AVQuery queryWithClassName:className];
    AVObject *object = [query getObjectWithId:objectId];
    if (object) {
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error != nil) callback(NO);
            else callback(succeeded);
        }];
    }else callback(NO);
}

// 查询所有
+ (void)findAllWithClassName:(NSString *)className HasArrayKey:(NSString *)fileArrayKey Return:(ReturnObject)returnObject{
    AVQuery *query = [AVQuery queryWithClassName:className];
    if (fileArrayKey) {
        [query includeKey:fileArrayKey];
    }
    query.cachePolicy = kAVCachePolicyNetworkElseCache;
    query.maxCacheAge = 24*3600;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) returnObject(objects);
        else returnObject(error);
    }];
}

// 分页查询所有
+ (void)findObjectByPageWithClassName:(NSString *)className HasArrayKey:(NSString *)fileArrayKey PageSize:(int)pageSize Page:(int)page Return:(ReturnObject)returnObject{
    AVQuery *query = [AVQuery queryWithClassName:className];
    if (fileArrayKey) {
        [query includeKey:fileArrayKey];
    }
    query.cachePolicy = kAVCachePolicyNetworkElseCache;
    query.maxCacheAge = 24*3600;
    query.limit = pageSize;
    query.skip = pageSize * (page - 1);
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) returnObject(objects);
        else returnObject(error);
    }];
}

// 查询本地缓存
+ (void)findAllCachesWithClassName:(NSString *)className HasArrayKey:(NSString *)fileArrayKey Return:(ReturnObject)returnObject{
    AVQuery *query = [AVQuery queryWithClassName:className];
    if (fileArrayKey) {
        [query includeKey:fileArrayKey];
    }
    query.cachePolicy = kAVCachePolicyCacheOnly;
    query.maxCacheAge = 24*3600;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) returnObject(objects);
        else returnObject(error);
    }];
}

// 条件查询
+ (void)findObjectWithClassName:(NSString *)className ConditionKey:(NSString *)conditionKey ConditionValue:(id)conditionValue HasArrayKey:(NSString *)fileArrayKey Return:(ReturnObject)returnObject{
    AVQuery *query = [AVQuery queryWithClassName:className];
    if (fileArrayKey) {
        [query includeKey:fileArrayKey];
    }
    query.cachePolicy = kAVCachePolicyNetworkElseCache;
    query.maxCacheAge = 24*3600;
    [query whereKey:conditionKey equalTo:conditionValue];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) returnObject(objects);
        else returnObject(error);
    }];
}
// 分页条件查询
+ (void)findObjectWithClassName:(NSString *)className ConditionKey:(NSString *)conditionKey ConditionValue:(id)conditionValue HasArrayKey:(NSString *)fileArrayKey PageSize:(int)pageSize Page:(int)page Return:(ReturnObject)returnObject{
    AVQuery *query = [AVQuery queryWithClassName:className];
    if (fileArrayKey) {
        [query includeKey:fileArrayKey];
    }
    query.cachePolicy = kAVCachePolicyNetworkElseCache;
    query.maxCacheAge = 24*3600;
    query.limit = pageSize;
    query.skip = pageSize * (page - 1);
    [query orderByDescending:@"createdAt"];
    [query whereKey:conditionKey equalTo:conditionValue];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) returnObject(objects);
        else returnObject(error);
    }];
}

// 获取记录个数
+ (void)getCountWithClassName:(NSString *)className ConditionKey:(NSString *)conditionKey ConditionValue:(id)conditionValue Return:(ReturnObject)returnObject{
    AVQuery *query = [AVQuery queryWithClassName:className];
    if (conditionKey && conditionValue) {
        [query whereKey:conditionKey equalTo:conditionValue];
    }
    [query countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if (!error) returnObject([NSString stringWithFormat:@"%ld",number]);
        else returnObject(error);
    }];
}

// sql语句查询
- (void)findObjectWithCql:(NSString *)cql,...{
    va_list ap;
    unsigned int count = 0;
    for (int i = 0; i < cql.length; i++) {
        if ([cql characterAtIndex:i] == '?') {
            count++;
        }
    }
    NSMutableArray *array = [NSMutableArray array];
    va_start(ap, cql);
    while (count != 0) {
        id pv = va_arg(ap, id);
        count--;
        [array addObject:pv];
    }
    va_end(ap);
    [AVQuery doCloudQueryInBackgroundWithCQL:cql pvalues:array callback:^(AVCloudQueryResult *result, NSError *error) {
        if (!error) self.returnResult(result.results);
        else self.returnResult(error);
    }];
}

//------------------- 用户操作 --------------------
// 登录
+ (void)loginWithKey:(LoginType)type Value:(NSString *)value Pwd:(NSString *)pwd CallBack:(ReturnObject)callback{
    if (type == PhoneNumber) {
        [AVUser logInWithMobilePhoneNumberInBackground:value password:pwd block:^(AVUser *user, NSError *error) {
            if (!error) callback(user);
            else callback(error);
        }];
    }else if (type == UserName){
        [AVUser logInWithUsernameInBackground:value password:pwd block:^(AVUser *user, NSError *error) {
            if (!error) callback(user);
            else callback(error);
        }];
    }
}

@end
