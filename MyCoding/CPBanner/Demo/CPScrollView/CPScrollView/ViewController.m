//
//  ViewController.m
//  CPScrollView
//
//  Created by morplcp on 15/12/28.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "ViewController.h"
#import "CPBannerView.h"
#import "DetailViewController.h"
@interface ViewController ()<CPBannerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str1 = @"1.jpg";
    NSString *str2 = @"2.jpg";
    NSString *str3 = @"3.jpg";

    CPBannerView *bView = [[CPBannerView alloc] initWithBannerSource:@[str1,str2,str3].mutableCopy ImageTitle:@[@"妹子1",@"妹子2",@"妹子3"].mutableCopy Frame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bView.delegate = self;
    
    [self.view addSubview:bView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -BannerViewDelegate
- (void)bannerView:(CPBannerView *)banner bannerDidSelectIndex:(NSInteger)index{
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",index + 1]];
    [self presentViewController:detailVC animated:YES completion:nil];
}

@end
