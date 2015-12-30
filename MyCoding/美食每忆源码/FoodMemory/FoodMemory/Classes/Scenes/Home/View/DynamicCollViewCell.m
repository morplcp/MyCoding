//
//  DynamicCollViewCell.m
//  FoodMemory
//
//  Created by morplcp on 15/12/6.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "DynamicCollViewCell.h"

@implementation DynamicCollViewCell

- (void)awakeFromNib {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    self.imgView.userInteractionEnabled = YES;
    [self.imgView addGestureRecognizer:tap];
}

- (void)tapClick:(UIGestureRecognizer *)sender{
    self.showImage(self.imgIndex);
}

@end
