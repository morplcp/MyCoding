//
//  DIYViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/10.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "DIYViewController.h"
#import "WebViewJavascriptBridge.h"
#import "DIYDetailViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface DIYViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *web;

@property WebViewJavascriptBridge *bridge;

@end

@implementation DIYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // 初始化一个webview并添加到视图
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 104, kWindowWidth, kWindowHeight - 49 - 64 - 40)];
    [self.view addSubview:_web];
    // 注册相关js方法
    [self registerMethod];
}

- (void)registerMethod{
    NSURL *url = [NSURL URLWithString:kFoodURL];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.web loadRequest:req];
    self.web.delegate = self;
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.web handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"Right back atcha");
    }];
    [self.bridge registerHandler:@"openURLFunc" handler:^(id data, WVJBResponseCallback responseCallback) {
        LCPLog(@"%@",data);
        NSString *url = data[@"url"];
        DIYDetailViewController *test2 = [[DIYDetailViewController alloc] init];
        test2.title = data[@"title"];
        test2.url = url;
        [self.navigationController pushViewController:test2 animated:YES];
    }];
    [self.bridge registerHandler:@"isLoginedFunc" handler:^(id data, WVJBResponseCallback responseCallback) {
        AVUser *user = [AVUser currentUser];
        if (user == nil) {
            responseCallback(NULL);
            AppDelegate *dele = [UIApplication sharedApplication].delegate;
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginVC = [sb instantiateViewControllerWithIdentifier:@"loginVC"];
            loginVC.backhandel = ^(){
                [dele.mmdVC.tabBarController setSelectedIndex:0];
            };
            [dele.mmdVC presentViewController:loginVC animated:YES completion:nil];
            return;
        }else{
            responseCallback(@"yes");
        }
    }];
    [self.bridge registerHandler:@"loginFunc" handler:^(id data, WVJBResponseCallback responseCallback) {
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
