//
//  MusicListCell.h
//  FoodMemory
//
//  Created by morplcp on 15/12/4.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Music.h"
@interface MusicListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblSongName;
@property (weak, nonatomic) IBOutlet UILabel *lblSingerName;
@property (nonatomic, strong) Music * music;

@end
