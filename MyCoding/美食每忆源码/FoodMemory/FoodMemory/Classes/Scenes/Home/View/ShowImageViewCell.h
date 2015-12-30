//
//  ShowImageViewCell.h
//  FoodMemory
//
//  Created by morplcp on 15/12/4.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CloseBlock)(UIImage *deleImg);
@interface ShowImageViewCell : UICollectionViewCell

@property (nonatomic, copy) CloseBlock closeImg;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic, assign)UIImage *deleImg;


- (IBAction)actionClose:(UIButton *)sender;

@end
