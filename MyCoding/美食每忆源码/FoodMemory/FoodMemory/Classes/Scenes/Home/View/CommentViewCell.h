//
//  CommentViewCell.h
//  FoodMemory
//
//  Created by morplcp on 15/12/14.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgUserPic;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentDate;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (nonatomic, strong)AVObject *commentObj;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@end
