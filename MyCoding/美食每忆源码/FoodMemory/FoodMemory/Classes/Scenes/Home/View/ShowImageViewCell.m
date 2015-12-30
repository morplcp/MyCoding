//
//  ShowImageViewCell.m
//  FoodMemory
//
//  Created by morplcp on 15/12/4.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "ShowImageViewCell.h"

@implementation ShowImageViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)actionClose:(UIButton *)sender {
    self.closeImg(self.deleImg);
}
@end
