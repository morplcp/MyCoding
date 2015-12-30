//
//  PhotoBoardScrollView.m
//  HomeWork08
//
//  Created by morplcp on 15/10/9.
//  Copyright (c) 2015年 MyOClesson.com. All rights reserved.
//

#import "PhotoBoardScrollView.h"

@implementation PhotoBoardScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.photoScrollArray = [NSMutableArray array];
    }
    return self;
}

// 重写set方法
-(void)setImgArray:(NSArray *)imgArray{
    if (_imgArray != imgArray) {
        _imgArray = imgArray;
        self.contentSize = CGSizeMake(self.frame.size.width * _imgArray.count, self.frame.size.height);
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.alwaysBounceVertical = NO;
        [self loadPhotoBoard];
    }
}

// 加载相册
- (void)loadPhotoBoard{
    for (int i = 0; i < _imgArray.count; i++) {
        PhotoScrollView *photoVC = [[PhotoScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        photoVC.imgView = _imgArray[i];
        [self addSubview:photoVC];
        [self addPhotoScrollArray:photoVC];
    }
}
// 设置相框数组
- (void)addPhotoScrollArray:(PhotoScrollView *)scroll{
    [_photoScrollArray addObject:scroll];
}


@end
