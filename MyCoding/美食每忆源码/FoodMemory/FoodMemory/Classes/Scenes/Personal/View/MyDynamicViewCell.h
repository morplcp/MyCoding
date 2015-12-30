//
//  MyDynamicViewCell.h
//  FoodMemory
//
//  Created by morplcp on 15/12/15.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDynamicViewCell : UITableViewCell

@property(nonatomic, strong)AVObject *dynamic;

@property (weak, nonatomic) IBOutlet UIImageView *imgPicture;

@property (weak, nonatomic) IBOutlet UILabel *labRestaurant;
@property (weak, nonatomic) IBOutlet UILabel *labTime;


@end
