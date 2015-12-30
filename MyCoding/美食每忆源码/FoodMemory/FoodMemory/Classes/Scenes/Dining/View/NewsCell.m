//
//  NewsCell.m
//  FoodMemory
//
//  Created by morplcp on 15/12/3.
//  Copyright © 2015年 morplcp. All rights reserved.

#import "NewsCell.h"
@implementation NewsCell

- (void)setNews:(News *)news{
    
    self.lab4title.text = news.title;
    [self.imgview sd_setImageWithURL:[NSURL URLWithString:[news.images lastObject]] placeholderImage:nil];
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
