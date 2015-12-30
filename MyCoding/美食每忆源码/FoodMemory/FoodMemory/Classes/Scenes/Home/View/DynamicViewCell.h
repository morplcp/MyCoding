//
//  DynamicViewCell.h
//  FoodMemory
//
//  Created by morplcp on 15/12/6.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dynamic.h"
typedef void (^ReportBlock)(AVObject *dynamic);
@interface DynamicViewCell : UITableViewCell
@property (nonatomic, copy)ReportBlock report;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserPic;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNick;
@property (weak, nonatomic) IBOutlet UILabel *lblPostDate;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UICollectionView *collView;
@property (weak, nonatomic) IBOutlet UILabel *lblLocationName;
@property (weak, nonatomic) IBOutlet UIButton *btnZan;
@property (weak, nonatomic) IBOutlet UIButton *btnCommend;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) NSMutableArray *imgHArray;
@property (nonatomic, strong) AVObject *dynamic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bodyViewHeight;


@end
