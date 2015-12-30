//
//  LeftSettingViewController.h
//  FoodMemory
//
//  Created by morplcp on 15/12/4.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "BasePageController.h"

@interface LeftSettingViewController : BasePageController

@property(nonatomic, strong)UIButton *btnLast;
@property(nonatomic, strong)UIButton *btnPlayOrPause;
@property(nonatomic, strong)UIButton *btnNext;
@property(nonatomic, strong)NSArray *musicArray;
// 要播放第几首歌曲
@property(nonatomic, assign) NSInteger playIndex;
@property(nonatomic, assign)int mode;

+ (instancetype)sharedPlayingPVC;

@end
