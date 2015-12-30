//
//  RegiesterViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/9.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "RegiesterViewController.h"
#import "LCPAlertView.h"

@interface RegiesterViewController ()

@property(nonatomic, strong)LCPAlertView *alertView;

@end

@implementation RegiesterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackView];
    [self addControl];
}

// 设置背景相关
- (void)addBackView{
    UIImageView *imgBack = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * -2, 0, self.view.frame.size.width * 3, self.view.frame.size.height)];
    imgBack.image = [UIImage imageNamed:@"loginbackground.jpg"];
    [self.view addSubview:imgBack];
    [self setFilterView];
    // 设置logo
    UIImageView *imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    imgLogo.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight / 2.5);
    imgLogo.bounds = CGRectMake(100, 100, 200, 50);
    [self.view addSubview:imgLogo];
}

// 添加注册相关控件
- (void)addControl{
    for (int i = 0; i < 3; i++) {
        NSArray * array = [NSArray arrayWithObjects:@"用户名",@"登录密码",@"密码确认", nil];
        UITextField * TF = [[UITextField alloc]initWithFrame:CGRectMake(50, kWindowHeight / 3.0 + 45 * i, kWindowWidth - 100, 30)];
        TF.borderStyle = UITextBorderStyleRoundedRect;
        TF.placeholder = array[i];
        TF.tag = 1000 + i;

        TF.layer.masksToBounds = YES;
        TF.layer.cornerRadius = 5;
        TF.font = [UIFont systemFontOfSize:13];
        [self.view addSubview:TF];
    }
    
    UIButton *btnReg = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btnReg.frame = CGRectMake(kWindowWidth / 2.0 + 10, kWindowHeight / 3.0 + 145, kWindowWidth / 2.0 - 65 , 30);
    btnReg.backgroundColor = RgbColor(104, 201, 254);
    btnReg.layer.masksToBounds = YES;
    btnReg.layer.cornerRadius = 5;
    [btnReg setTitle:@"注册" forState:(UIControlStateNormal)];
    btnReg.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnReg setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [btnReg setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateHighlighted)];
    [btnReg addTarget:self action:@selector(regClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btnReg];
    
    
    UIButton *btnCancel = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btnCancel.frame = CGRectMake(55, kWindowHeight / 3.0 + 145, kWindowWidth / 2.0 - 65 , 30);
    btnCancel.backgroundColor = RgbColor(104, 201, 254);
    btnCancel.layer.masksToBounds = YES;
    btnCancel.layer.cornerRadius = 5;
    [btnCancel setTitle:@"取消" forState:(UIControlStateNormal)];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [btnCancel setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateHighlighted)];
    [btnCancel addTarget:self action:@selector(cancelClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btnCancel];
    
    self.alertView = [[LCPAlertView alloc] initWithFrame:CGRectMake((kWindowWidth - 200) / 2.0, kWindowHeight - 130, 200, 30)];
    _alertView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_alertView];
    
}

// 添加过滤图层
- (void)setFilterView{
    UIView *filterView = [[UIView alloc] initWithFrame:self.view.frame];
    filterView.backgroundColor = [UIColor whiteColor];
    filterView.alpha = 0.3;
    [self.view addSubview:filterView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// 注册
- (void)regClick{
    UITextField *txtUserName = (UITextField *)[self.view viewWithTag:1000];
    UITextField *txtPwd = (UITextField *)[self.view viewWithTag:1001];
    UITextField *txtPwdAgain = (UITextField *)[self.view viewWithTag:1002];
    
    if ([txtPwd.text isEqualToString:@""] || [txtUserName.text isEqualToString:@""] || ![txtPwd.text isEqualToString:txtPwdAgain.text]) {
        self.alertView.message = @"您输入的信息有误，请检查";
        [self.alertView show];
        return;
    }
    
    NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"defualt.jpg"]);
    AVFile *file = [AVFile fileWithData:data];
    [file saveInBackground];
    AVUser *user = [AVUser user];
    user.username = txtUserName.text;
    user.password = txtPwd.text;
    [user setObject:file forKey:@"userPic"];
    [user setObject:@"F" forKey:@"gender"];
    [user setObject:@"这吃货很懒，什么都没写。" forKey:@"sign"];
    [user setObject:[NSString stringWithFormat:@"U%d",arc4random_uniform(10000)] forKey:@"userNickName"];
    [user setObject:@"" forKey:@"uName"];
    [user setObject:@"" forKey:@"hobby"];
    [user setObject:@"" forKey:@"add"];
    [user setObject:@"" forKey:@"collectionDIY"];
    [user setObject:@"" forKey:@"like_dynamic"];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)[self dismissViewControllerAnimated:YES completion:nil];
        else LCPLog(@"注册失败%@",error);
    }];
}

// 取消注册
- (void)cancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
