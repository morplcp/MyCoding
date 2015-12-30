//
//  ReportViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/14.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblPoster;
@property (weak, nonatomic) IBOutlet UILabel *lblPostContent;
@property (weak, nonatomic) IBOutlet UITextView *txtReportContent;
- (IBAction)actionSubmit:(UIButton *)sender;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lblPoster.text = [self.dynamicObj objectForKey:@""];
    AVQuery *query = [AVUser query];
    [query whereKey:@"objectId" equalTo:[self.dynamicObj objectForKey:@"uId"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error != nil) {
            ;
        }else {
            self.lblPoster.text = [[objects lastObject] objectForKey:@"userNickName"];
        }
    }];
    self.lblPostContent.text = [NSString stringWithFormat:@"%@...",[self.dynamicObj objectForKey:@"content"]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"信息举报";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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

// 提交举报
- (IBAction)actionSubmit:(UIButton *)sender {
    __weak typeof(self)vc = self;
    AVQuery *query = [AVQuery queryWithClassName:@"Report"];
    [query whereKey:@"dynamicId" equalTo:self.dynamicObj.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0) {
            [vc alert:@"此条动态已经被人举报过，我们正在处理。谢谢！"];
        }else{
            AVObject *obj = [AVObject objectWithClassName:@"Report"];
            [obj setObject:self.dynamicObj.objectId forKey:@"dynamicId"];
            [obj setObject:self.txtReportContent.text forKey:@"reportContent"];
            [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error != nil) {
                    [vc alertNoAction:[NSString stringWithFormat:@"上传失败：error:%@",error] Duration:1];
                }else{
                    [vc alertNoAction:@"您的举报信息已经提交，我们将尽快处理，谢谢！" Duration:1];
                }
            }];
        }
    }];
}
@end
