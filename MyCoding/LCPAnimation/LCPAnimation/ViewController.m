//
//  ViewController.m
//  LCPAnimation
//
//  Created by morplcp on 15/10/30.
//  Copyright © 2015年 李成鹏.com. All rights reserved.
//

#import "ViewController.h"
#import "LCPAnimation.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)gogo:(UIButton *)sender {
    
    LCPAnimation *lcp = [LCPAnimation new];
    [lcp setViewAnimationWithAnimationType:RippleEffect Duration:0.7 View:self.view];
    
    
    static int i = 0;
    if (i == 0) {
        self.view.backgroundColor = [UIColor yellowColor];
        i = 1;
    }else{
        self.view.backgroundColor = [UIColor redColor];
        i = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
