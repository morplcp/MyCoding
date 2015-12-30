//
//  IWantViewCell.h
//  FoodMemory
//
//  Created by morplcp on 15/12/15.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IWantViewCell : UITableViewCell

@property (nonatomic, strong)NSString *dynamicId;
@property (weak, nonatomic) IBOutlet UILabel *labWantEat;
@property (weak, nonatomic) IBOutlet UIImageView *imgPicture;

@end
