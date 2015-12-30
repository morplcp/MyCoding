//
//  DynamicCollViewCell.h
//  FoodMemory
//
//  Created by morplcp on 15/12/6.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ShowImgBlock)(NSInteger index);

@interface DynamicCollViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic, assign) NSInteger imgIndex;
@property (nonatomic, copy) ShowImgBlock showImage;

@end
