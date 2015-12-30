//
//  SelectLocationController.h
//  FoodMemory
//
//  Created by morplcp on 15/12/8.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LocationBlock)(NSString *locationName);

@interface SelectLocationController : UITableViewController

@property (nonatomic, copy)LocationBlock locationname;

@end
