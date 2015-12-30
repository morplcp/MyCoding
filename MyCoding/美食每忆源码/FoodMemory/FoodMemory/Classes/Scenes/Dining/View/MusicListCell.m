//
//  MusicListCell.m
//  FoodMemory
//
//  Created by morplcp on 15/12/4.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "MusicListCell.h"

@implementation MusicListCell

- (void)setMusic:(Music *)music{
    self.lblSongName.text = music.title;
    self.lblSingerName.text = music.singer;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
