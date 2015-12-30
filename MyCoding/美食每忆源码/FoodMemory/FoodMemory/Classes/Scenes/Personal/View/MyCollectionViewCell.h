//
//  MyCollectionViewCell.h
//  FoodMemory
//
//  Created by morplcp on 15/12/15.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgPicture;

@property (weak, nonatomic) IBOutlet UILabel *labLocation;

@property (weak, nonatomic) IBOutlet UILabel *labTime;
@end
