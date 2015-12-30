//
//  Music.h
//  FoodMemory
//
//  Created by morplcp on 15/12/3.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Music : NSObject
//@property (nonatomic, assign)NSInteger groupcode;   // 组织代码
@property (nonatomic, strong)NSString * icon;       // 偶像图标
@property (nonatomic, strong)NSString * img;        // 图片
@property (nonatomic, assign)NSInteger pagecount;   // 页数
@property (nonatomic, strong)NSString * publishTime;// 发表日期
@property (nonatomic, strong)NSString * shareLink;  // 分享链接
@property (nonatomic, strong)NSString * shareTitle; // 分享的标题
@property (nonatomic, strong)NSArray * songs;       // 所有歌曲
@property (nonatomic, strong)NSString * summary;    // 模块标题
@property (nonatomic, assign)NSNumber * totalcount; // 歌曲总数

// 音乐
@property (nonatomic, strong)NSString * album;      // 唱片集
@property (nonatomic, strong)NSString * albumIcon;  // 专辑图标
@property (nonatomic, strong)NSString * albumid;    // 专辑的id
@property (nonatomic, strong)NSString * albumImg;   // 专辑图片
@property (nonatomic, strong)NSString * contentid;  // 内容id
@property (nonatomic, strong)NSString * singer;     // 歌手
@property (nonatomic, strong)NSString * singerIcon; // 歌手图标
@property (nonatomic, strong)NSString * singerid;   // 歌手id
@property (nonatomic, strong)NSString * singerImg;  // 歌手图片
@property (nonatomic, strong)NSString * title;      // 歌曲名
@property (nonatomic, strong)NSString * hqFlag;


@end
