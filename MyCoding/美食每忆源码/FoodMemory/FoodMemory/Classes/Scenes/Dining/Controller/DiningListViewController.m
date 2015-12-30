//
//  DiningListViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/3.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "DiningListViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "AppDelegate.h"
@interface DiningListViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *musicW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *musicH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storyW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storyH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newsW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newsH;

@end

@implementation DiningListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftMenuButton];
    [self layoutSubViews];
}

- (void)layoutSubViews{
    if (IsiPhone4) {
        self.musicW.constant = 70;
        self.musicH.constant = 70;
        self.storyW.constant = 70;
        self.storyH.constant = 70;
        self.newsW.constant = 70;
        self.newsH.constant = 70;
    }else if (IsiPhone5){
        self.musicW.constant = 85;
        self.musicH.constant = 85;
        self.storyW.constant = 85;
        self.storyH.constant = 85;
        self.newsW.constant = 85;
        self.newsH.constant = 85;
    }else{
        self.musicW.constant = 96;
        self.musicH.constant = 96;
        self.storyW.constant = 96;
        self.storyH.constant = 96;
        self.newsW.constant = 96;
        self.newsH.constant = 96;
    }
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    [appdelegate.mmdVC toggleDrawerSide:(MMDrawerSideLeft) animated:YES completion:nil];
}
// 设置左抽屉按钮
-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
