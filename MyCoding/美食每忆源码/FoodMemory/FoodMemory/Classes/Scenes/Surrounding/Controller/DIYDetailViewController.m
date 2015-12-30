//
//  DIYDetailViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/10.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "DIYDetailViewController.h"
#import "WebViewJavascriptBridge.h"
#import "DIYMoreDetailViewController.h"
@interface DIYDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong)UIWebView *web;

@property WebViewJavascriptBridge* bridge;

@end

@implementation DIYDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化一个webview
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.web loadRequest:req];
    self.web.scrollView.bounces = NO;
    [self.view addSubview:_web];
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.web handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"Right back atcha");
    }];
    [self.bridge registerHandler:@"openAppUrlFunc" handler:^(id data, WVJBResponseCallback responseCallback) {
        LCPLog(@"%@",data);
        NSString *url = data[@"url"];
        DIYMoreDetailViewController *test3 = [[DIYMoreDetailViewController alloc] init];
        test3.url = url;
        test3.title = data[@"title"];
        [self.navigationController pushViewController:test3 animated:YES];
    }];
    [self.bridge registerHandler:@"submit_pl_new" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"");
    }];
    [self.bridge registerHandler:@"isLoginedFunc" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"undef");
    }];
    [self.bridge registerHandler:@"Mylike_get" handler:^(id data, WVJBResponseCallback responseCallback) {
        LCPLog(@"123");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
