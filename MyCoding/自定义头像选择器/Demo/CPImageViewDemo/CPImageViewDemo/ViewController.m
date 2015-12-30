//
//  ViewController.m
//  CPImageViewDemo
//
//  Created by morplcp on 15/12/30.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "ViewController.h"
#import "LCPImageView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    LCPImageView *image = [[LCPImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 80) / 2.0, 70, 80, 80)];
    [self.view addSubview:image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
