//
//  LCPSpinnerView.m
//  FoodMemory
//
//  Created by morplcp on 15/12/11.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "LCPSpinnerView.h"

@implementation LCPSpinnerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        MMMaterialDesignSpinner *spiner = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        spiner.center = self.center;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        spiner.lineWidth = 1.5f;
        spiner.tintColor = [UIColor cyanColor];
        [spiner startAnimating];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self addSubview:spiner];
        });
        [self addSubview:spiner];
        self.alpha = 0;
    }
    return self;
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
