//
//  ShowHDImage.m
//  FoodMemory
//
//  Created by morplcp on 15/12/10.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "ShowHDImage.h"

@interface ShowHDImage ()

@property(nonatomic, strong)UIImageView *imgView;
@property(nonatomic, strong)MMMaterialDesignSpinner *spiner;


@end

@implementation ShowHDImage

- (instancetype)initWithImageURL:(NSString *)url{
    self = [super init];
    if (self) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timeClick:) userInfo:nil repeats:YES];
        self.spiner = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake((kWindowWidth - 80) / 2.0, kWindowHeight / 2.0 - 40, 80, 80)];
        _spiner.lineWidth = 1.5;
        _spiner.tintColor = [UIColor cyanColor];
        self.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [self addGestureRecognizer:tap];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        __weak typeof(self)vc = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [imgView sd_setImageWithURL:[NSURL URLWithString:url]];
            vc.imgView = imgView;
            [vc addSubview:vc.imgView];
            [_spiner startAnimating];
            [timer start];
            [vc addSubview:_spiner];
        });
    }
    return self;
}

- (void)timeClick:(NSTimer *)timer{
    if (self.imgView.image != nil) {
        [self.spiner removeFromSuperview];
        [timer pause];
    }
}

- (void)show{
    [UIView transitionWithView:self duration:0.1 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        ;
    }];
}

- (void)close{
    __weak typeof(self)vc = self;
    [UIView transitionWithView:self duration:0.1 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        vc.alpha = 0;
    } completion:^(BOOL finished) {
        [vc removeFromSuperview];
    }];
}

@end
