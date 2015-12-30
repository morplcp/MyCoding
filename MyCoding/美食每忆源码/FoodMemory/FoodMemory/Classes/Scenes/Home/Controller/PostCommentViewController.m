//
//  PostCommentViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/14.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "PostCommentViewController.h"

@interface PostCommentViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *txtComment;
@property (weak, nonatomic) IBOutlet UITextView *txtBackground;

@end

@implementation PostCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAction) target:self action:@selector(saveComment)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.txtComment.delegate = self;
}

- (void)saveComment{
    self.navigationItem.hidesBackButton = YES;
    AVUser *user = [AVUser currentUser];
    AVObject *comment = [AVObject objectWithClassName:@"Comment"];
    [comment setObject:self.txtComment.text forKey:@"commentContent"];
    [comment setObject:user.objectId forKey:@"userId"];
    [comment setObject:self.dynamicId forKey:@"dynamicId"];
    __weak typeof(self)vc = self;
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error != nil) {
            [vc alertNoAction:[NSString stringWithFormat:@"保存失败：%@",error] Duration:1];
            
        }else{
            [vc alertNoAction:@"评论成功" Duration:1];
            self.navigationItem.hidesBackButton = NO;
            [LeanCloudDBHelper findObjectWithClassName:@"dynamic" ConditionKey:@"objectId" ConditionValue:self.dynamicId HasArrayKey:nil Return:^(id result) {
                AVObject *obj = [result lastObject];
                [obj incrementKey:@"comments_count"];
                [obj saveInBackground];
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [vc.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

#pragma mark -UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![text isEqualToString:@""]) {
        [_txtBackground setHidden:YES];
    }
    if ([text isEqualToString:@""] && range.length == 1 && range.location == 0){
        [_txtBackground setHidden:NO];
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
