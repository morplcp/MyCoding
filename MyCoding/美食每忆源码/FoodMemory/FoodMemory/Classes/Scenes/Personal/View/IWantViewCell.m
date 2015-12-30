//
//  IWantViewCell.m
//  FoodMemory
//
//  Created by morplcp on 15/12/15.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "IWantViewCell.h"

@implementation IWantViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDynamicId:(NSString *)dynamicId{
    _dynamicId = dynamicId;
    __weak typeof(self)vc = self;
    [LeanCloudDBHelper findObjectWithClassName:@"dynamic" ConditionKey:@"objectId" ConditionValue:dynamicId HasArrayKey:@"imgArray" Return:^(id result) {
        AVObject *dynamic = [result lastObject];
        NSArray *imgArray = [dynamic objectForKey:@"imgArray"];
        if (imgArray.count > 0) {
            AVFile *file = imgArray[0];
            [file getThumbnail:YES width:110 height:80 withBlock:^(UIImage *image, NSError *error) {
                vc.imgPicture.image = image;
            }];
        }else{
            AVQuery *query = [AVUser query];
            [query whereKey:@"objectId" equalTo:[dynamic objectForKey:@"uId"]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                AVUser *user = [objects lastObject];
                AVFile *file = [user objectForKey:@"userPic"];
                [file getThumbnail:YES width:110 height:80 withBlock:^(UIImage *image, NSError *error) {
                    vc.imgPicture.image = image;
                }];
            }];
        }
        vc.labWantEat.text = [dynamic objectForKey:@"location_name"];
    }];
}

- (void)setDynamic:(NSString *)dynamicId{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
