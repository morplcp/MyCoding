//
//  FeedBackViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/9.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *txtContent;

- (IBAction)actionCommit:(UIButton *)sender;

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtContent.delegate = self;
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)actionCommit:(UIButton *)sender {
    AVObject *feed = [AVObject objectWithClassName:@"feed"];
    AVUser *user = [AVUser currentUser];
    [feed setObject:@"uId" forKey:user.objectId];
    [feed setObject:self.txtContent.text forKey:@"feedContent"];
    __weak typeof(self)vc = self;
    [feed saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [vc alertNoAction:@"亲，我们已收到您的建议，感谢您的支持！" Duration:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [vc.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [vc alertNoAction:[NSString stringWithFormat:@"提交失败：%@",error] Duration:1];
        }
    }];
}
@end
