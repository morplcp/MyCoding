//
//  ViewController.m
//  CPCityPicker
//
//  Created by morplcp on 15/12/30.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "ViewController.h"
#import "LCPPicker.h"


@interface ViewController ()
- (IBAction)selectCity:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectCity:(UIButton *)sender {
    LCPPicker *picker = [[LCPPicker alloc] initWithDictionary:[CityDataManager sharedDataManager].cityArray];
    [self.view.window addSubview:picker];
    [picker show];
    picker.selectCity = ^(NSString *city){
        [sender setTitle:city forState:(UIControlStateNormal)];
    };
}
@end
