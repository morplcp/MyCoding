//
//  PlayerManager.m
//  0834MusicPlayer
//
//  Created by morplcp on 15/11/5.
//  Copyright © 2015年 李成鹏.com. All rights reserved.
//

#import "PlayerManager.h"
#import <AVFoundation/AVFoundation.h>
@interface PlayerManager ()
// 播放器 -> 全局唯一，因为如果有两个avplayer的话，就会同时播放两个音乐。
@property(nonatomic, strong) AVPlayer *player;
@property(nonatomic, retain) NSTimer *timer; // 计时器

@end

@implementation PlayerManager

static PlayerManager *manager = nil;
// 单例方法
+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [PlayerManager new];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 添加通知，当音乐播放完成之后执行playerDidPlayEnd方法
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playingWithSeconds) userInfo:nil repeats:YES];
    }
    return self;
}

// 开始播放
- (void)playWithUrlString:(NSString *)urlStr{
    //子线程中播放
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 切换歌曲的时候移除观察者
        if (self.player.currentItem) {
            [self.player.currentItem removeObserver:self forKeyPath:@"status"];
        }
        // 创建item
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlStr]];
        // 给item添加观察者
        [item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
        // 替换当前正在播放的音乐。
        [self.player replaceCurrentItemWithPlayerItem:item];
        [self play];
    });
}

- (void)play{
    // 如果正在播放，就不播放了，直接返回
    [self.timer setFireDate:[NSDate date]];
    [self.player play];
    // 开始播放后标记一下
    _isPlaying = YES;
    
}

- (void)playingWithSeconds{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(playerPlayWithTime:)]) {
//        // 计算播放器当前播放时间
//       //  NSTimeInterval time = self.player.currentTime.value / self.player.currentTime.timescale;
//       // [self.delegate playerPlayWithTime:time];
//    }
    
}

- (void)pause{
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.player pause];
    _isPlaying = NO;
}

- (void)seekToTime:(NSTimeInterval)time{
    // 先暂停
    [self pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
        if (finished) {
            [self play];
        }
    }];
}

- (void)seekToVolum:(CGFloat)volum{
    [self.player setVolume:volum];
}

- (void)playerDidPlayEnd{
    if ([self.delegate respondsToSelector:@selector(playerDidPlayEnd)]) {
        [self.delegate playerDidPlayEnd];
    }
}

- (CGFloat)volume{
    return self.player.volume;
}

#pragma mark --lazyLoad
- (AVPlayer *)player{
    if (!_player) {
        _player = [AVPlayer new];
    }
    return _player;
}

#pragma mark - 观察者响应事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"%@",keyPath);
    NSLog(@"%@",change);
    // 状态变化之后的新值
    AVPlayerItemStatus status = [change[@"new"] integerValue];
    switch (status) {
        case AVPlayerItemStatusFailed:
            NSLog(@"加载失败！");
            break;
        case AVPlayerItemStatusUnknown:
            NSLog(@"资源不对！");
            break;
        case AVPlayerItemStatusReadyToPlay:
            NSLog(@"可以播放！");
            // 开始播放
            [self play];
            break;
        default:
            break;
    }
}

@end
