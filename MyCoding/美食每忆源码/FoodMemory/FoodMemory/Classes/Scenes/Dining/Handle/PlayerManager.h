//
//  PlayerManager.h
//  0834MusicPlayer
//
//  Created by morplcp on 15/11/5.
//  Copyright © 2015年 李成鹏.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayerManagerDelegate <NSObject>

- (void)playerDidPlayEnd;

@end

@interface PlayerManager : NSObject
// 是否正在播放
@property(nonatomic, assign) BOOL  isPlaying;
@property(nonatomic, assign) id<PlayerManagerDelegate> delegate;
/**
 *  单例方法
 */
+ (instancetype)sharedManager;

/**
 *  给一个连接进行播放
 *
 *  @param urlStr 连接
 */
- (void)playWithUrlString:(NSString *)urlStr;

// 播放
- (void)play;
// 暂停
- (void)pause;
// 改变进度
- (void)seekToTime:(NSTimeInterval)time;
// 改变声音
- (void)seekToVolum:(CGFloat)volum;
- (CGFloat)volume;
@end
