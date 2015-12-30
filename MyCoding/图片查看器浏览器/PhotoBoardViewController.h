//
//  PhotoBoardViewController.h
//  HomeWork08
//
//  Created by morplcp on 15/10/9.
//  Copyright (c) 2015年 MyOClesson.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoBoardViewController : UIViewController

@property(nonatomic, assign)NSInteger currentPhoto;
@property(nonatomic, strong)NSMutableArray *imgArray;
@property(nonatomic, strong)NSMutableArray *thubArray;

@end
