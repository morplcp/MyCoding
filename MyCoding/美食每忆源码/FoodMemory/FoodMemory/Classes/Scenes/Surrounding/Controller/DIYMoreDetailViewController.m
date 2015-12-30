//
//  DIYMoreDetailViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/11.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "DIYMoreDetailViewController.h"
#import "WebViewJavascriptBridge.h"
@interface DIYMoreDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong)UIWebView *web;

@property (nonatomic, strong)MMMaterialDesignSpinner *sp;

@property WebViewJavascriptBridge* bridge;

@end

@implementation DIYMoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.sp = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake((kWindowWidth - 80) / 2.0, kWindowHeight / 2.0 - 40, 80, 80)];
    _sp.lineWidth = 2.0;
    _sp.tintColor = [UIColor cyanColor];
    // 初始化一个webview
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.web.delegate = self;
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.web loadRequest:req];
    self.web.scrollView.bounces = NO;
    [self.view addSubview:_web];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.view addSubview:_sp];
    [_sp startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_sp removeFromSuperview];
    [_sp stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
