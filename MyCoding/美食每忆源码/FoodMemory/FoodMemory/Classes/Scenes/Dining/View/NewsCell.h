//
//  NewsCell.h
//  FoodMemory
//
//  Created by morplcp on 15/12/3.
//  Copyright © 2015年 morplcp. All rights reserved.

#import <UIKit/UIKit.h>
#import "News.h"
@interface NewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lab4title;
@property (weak, nonatomic) IBOutlet UIImageView *imgview;

@property (nonatomic, strong)News * news;

@end
