//
//  Dynamic.m
//  FoodMemory
//
//  Created by morplcp on 15/12/3.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "Dynamic.h"
#import <objc/message.h>
@implementation Dynamic

//- (instancetype)initWithAvObject:(AVObject *)obj{
//    self = [super init];
//    if (self) {
//        unsigned int propertyCount = 0;
//        objc_property_t *propertys = class_copyPropertyList([obj class], &propertyCount);
//        for (int i = 0; i < propertyCount; i++) {
//            objc_property_t property = propertys[i];
//            const char * key = property_getName(property);
//            id value = [obj valueForKey:[NSString stringWithUTF8String:key]];
//            [self setValue:value forKey:[NSString stringWithUTF8String:key]];
//        }
//    }
//    return self;
//}
//
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
//
//}
//
//+ (instancetype)dynamicWithAvObject:(AVObject *)obj{
//    Dynamic *dynamic = [[Dynamic alloc] initWithAvObject:obj];
//    return dynamic;
//}

@end
