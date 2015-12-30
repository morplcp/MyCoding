//
//  CommentViewCell.m
//  FoodMemory
//
//  Created by morplcp on 15/12/14.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "CommentViewCell.h"

@implementation CommentViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCommentObj:(AVObject *)commentObj{
    _commentObj = commentObj;
    __weak typeof(self)vc = self;
    AVQuery *query = [AVUser query];
    [query whereKey:@"objectId" equalTo:[commentObj objectForKey:@"userId"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error != nil) {
            ;
        }else{
            vc.lblUserName.text = [[objects lastObject] objectForKey:@"userNickName"];
            AVFile *file = [[objects lastObject] objectForKey:@"userPic"];
            [file getThumbnail:YES width:100 height:100 withBlock:^(UIImage *image, NSError *error) {
                vc.imgUserPic.image = image;
            }];
        }
    }];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    _lblCommentDate.text = [dateFormatter stringFromDate:commentObj.createdAt];
    _lblContent.text = [commentObj objectForKey:@"commentContent"];
    self.contentHeight.constant = [self getTextHeight:[commentObj objectForKey:@"commentContent"]];
}

// 获取文本高度
- (CGFloat)getTextHeight:(NSString *)str{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(kWindowWidth - 40, 10000)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
                                    context:nil];
    return rect.size.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
