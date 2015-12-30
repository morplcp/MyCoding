//
//  MyDynamicViewCell.m
//  FoodMemory
//
//  Created by morplcp on 15/12/15.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "MyDynamicViewCell.h"

@implementation MyDynamicViewCell

- (void)awakeFromNib {
    self.imgPicture.layer.masksToBounds = YES;
    self.imgPicture.layer.cornerRadius = 35;
}

- (void)setDynamic:(AVObject *)dynamic{
    _dynamic = dynamic;
    AVUser *user = [AVUser currentUser];
    AVFile *file = [user objectForKey:@"userPic"];
    __weak typeof(self)vc = self;
    [file getThumbnail:YES width:100 height:100 withBlock:^(UIImage *image, NSError *error) {
        vc.imgPicture.image = image;
    }];
    self.labRestaurant.text = [self.dynamic objectForKey:@"location_name"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    self.labTime.text = [dateFormatter stringFromDate:dynamic.createdAt];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
