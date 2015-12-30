//
//  LCPAlertView.m
//  FoodMemory
//
//  Created by morplcp on 15/12/8.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "LCPAlertView.h"

@interface LCPAlertView ()

@property(nonatomic, strong)UILabel *lblShowMsg;

@end

@implementation LCPAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0;
        self.lblShowMsg = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _lblShowMsg.numberOfLines = 1;
        _lblShowMsg.textColor = RgbColor(255, 255, 255);
        _lblShowMsg.textAlignment = NSTextAlignmentCenter;;
        _lblShowMsg.font = [UIFont systemFontOfSize:15];
        [self addSubview:_lblShowMsg];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3;
    }
    return self;
}

-(void)setMessage:(NSString *)message{
    _message = message;
    _lblShowMsg.text = message;
}

// 显示
- (void)show{
    [UIView transitionWithView:self duration:0.5 options:(UIViewAnimationOptionBeginFromCurrentState) animations:^{
        self.alpha = 0.7;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.alpha = 0;
        });
    }];
}

@end
