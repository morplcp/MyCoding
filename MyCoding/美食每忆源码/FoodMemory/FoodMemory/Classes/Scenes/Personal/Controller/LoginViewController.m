//
//  LoginViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/9.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "LoginViewController.h"
#import "LCPAlertView.h"
#import "RegiesterViewController.h"
#import "PersonalViewController.h"
@interface LoginViewController ()

@property (nonatomic, strong) UITextField *txtUserName;
@property (nonatomic, strong) UITextField *txtPwd;
@property (nonatomic, strong) LCPAlertView *alert;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * -1.2, 0, self.view.frame.size.width * 3, self.view.frame.size.height)];
    imgView.image = [UIImage imageNamed:@"loginbackground.jpg"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setAnimation:imgView];
    });
    [self.view addSubview:imgView];
    [self setFilterView];
    [self addControl];
}

// 添加控件
- (void)addControl{
    UIButton *btnBack = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [btnBack setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:(UIControlStateNormal)];
    [btnBack setTitle:@"返回" forState:(UIControlStateNormal)];
    [btnBack setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    btnBack.frame = CGRectMake(10, 20, 80, 30);
    btnBack.titleLabel.font = [UIFont systemFontOfSize:19];
    btnBack.tintColor = [UIColor whiteColor];
    [btnBack addTarget:self action:@selector(backClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btnBack];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight / 2.0 - 75, kWindowWidth, 195)];
    self.txtUserName = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, kWindowWidth - 40, 40)];
    _txtUserName.borderStyle = UITextBorderStyleRoundedRect;
    _txtUserName.placeholder = @"用户名/邮箱";
    self.txtPwd = [[UITextField alloc] initWithFrame:CGRectMake(20, 50, kWindowWidth - 40, 40)];
    _txtPwd.borderStyle = UITextBorderStyleRoundedRect;
    _txtPwd.placeholder = @"密码";
    _txtPwd.secureTextEntry = YES;
    UIButton *btnLogin = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btnLogin.frame = CGRectMake(20, 100, kWindowWidth - 40, 40);
    btnLogin.backgroundColor = RgbColor(247, 159, 13);
    [btnLogin setTitle:@"登录" forState:(UIControlStateNormal)];
    [btnLogin setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [btnLogin setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateHighlighted)];
    [btnLogin addTarget:self action:@selector(loginClick) forControlEvents:(UIControlEventTouchUpInside)];
    self.alert = [[LCPAlertView alloc] initWithFrame:CGRectMake((kWindowWidth - 200) / 2.0, 150, 200, 40)];
    _alert.backgroundColor = [UIColor blackColor];
    [view addSubview:_alert];
    [view addSubview:_txtUserName];
    [view addSubview:_txtPwd];
    [view addSubview:btnLogin];
    [self.view addSubview:view];
    
    // 底部控件
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake((kWindowWidth - 165) / 2.0, kWindowHeight - 50, 162, 40)];
    UIButton *btnForgetPwd = [UIButton buttonWithType:(UIButtonTypeSystem)];
    btnForgetPwd.frame = CGRectMake(0, 0, 80, 40);
    [btnForgetPwd setTitle:@"找回密码" forState:(UIControlStateNormal)];
    [btnForgetPwd setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
    [btnForgetPwd addTarget:self action:@selector(findPwdClick) forControlEvents:(UIControlEventTouchUpInside)];
    UILabel *lblLine = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 5, 40)];
    lblLine.text = @"|";
    lblLine.textColor = [UIColor whiteColor];
    lblLine.font = [UIFont systemFontOfSize:20];
    UIButton *btnRegiester = [UIButton buttonWithType:(UIButtonTypeSystem)];
    btnRegiester.frame = CGRectMake(85, 0, 80, 40);
    [btnRegiester setTitle:@"注册账号" forState:(UIControlStateNormal)];
    [btnRegiester setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
    [btnRegiester addTarget:self action:@selector(regiesterClick) forControlEvents:(UIControlEventTouchUpInside)];
    [footerView addSubview:btnForgetPwd];
    [footerView addSubview:lblLine];
    [footerView addSubview:btnRegiester];
    [self.view addSubview:footerView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

// 返回继续浏览
- (void)backClick{
    self.backhandel();
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 添加过滤图层
- (void)setFilterView{
    UIView *filterView = [[UIView alloc] initWithFrame:self.view.frame];
    filterView.backgroundColor = [UIColor whiteColor];
    filterView.alpha = 0.3;
    [self.view addSubview:filterView];
}

// 设置背景动画
- (void)setAnimation:(UIView *)view{
    [UIView beginAnimations:@"gogo" context:nil];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationDuration:20];
    [UIView setAnimationRepeatCount:15];
    view.center = CGPointMake(self.view.frame.size.width *1.2, self.view.center.y);
    [UIView commitAnimations];
}

// 登录事件
- (void)loginClick{
    [self.view endEditing:YES];
    if ([_txtUserName.text isEqualToString:@""] || _txtUserName.text == nil || [_txtPwd.text isEqualToString:@""] || _txtPwd.text == nil) {
        self.alert.message = @"用户/密码不能为空";
        [_alert show];
    }
    else {
        [LeanCloudDBHelper loginWithKey:(UserName) Value:self.txtUserName.text Pwd:self.txtPwd.text CallBack:^(id result) {
            if ([result isKindOfClass:[NSError class]]) {
                self.alert.message = @"用户或密码错误";
                [_alert show];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

// 找回密码
- (void)findPwdClick{
    
}

// 注册账号
-(void)regiesterClick{
    RegiesterViewController *regVC = [self.storyboard instantiateViewControllerWithIdentifier:@"regVC"];
    [self presentViewController:regVC animated:YES completion:nil];
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
