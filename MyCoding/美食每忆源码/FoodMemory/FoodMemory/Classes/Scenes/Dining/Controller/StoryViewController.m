//
//  DiningListViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/3.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "StoryViewController.h"

@interface StoryViewController ()<UIScrollViewDelegate,UIWebViewDelegate>

@property(nonatomic, strong)UIView *view1;
@property(nonatomic, strong)UIView *view2;
@property(nonatomic, strong)UIWebView *webView1;
@property(nonatomic, strong)UIWebView *webView2;
@property(nonatomic, strong)UILabel *lblDate;
@property(nonatomic, strong)UILabel *lblTitle;
@property(nonatomic, strong)UIButton *btnBack;
@property(nonatomic, strong)UIView *topView;

@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBodyView];
}

- (void)setBodyView{
    UIScrollView *scrolleView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrolleView.pagingEnabled = YES;
    scrolleView.contentSize = CGSizeMake(kWindowWidth * 4, kWindowHeight);
    scrolleView.showsHorizontalScrollIndicator = NO;
    scrolleView.delegate = self;
    scrolleView.bounces = NO;
    scrolleView.contentOffset = CGPointMake(kWindowWidth, 0);
    [self.view addSubview:scrolleView];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(kWindowWidth * 1, 0, self.view.frame.size.width, self.view.frame.size.height)];
    view1.backgroundColor = RgbColor(231, 231, 231);
    self.webView1 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 100, kWindowWidth, kWindowHeight - 100)];
    self.webView1.delegate = self;
    self.webView1.scrollView.bounces = NO;
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(kWindowWidth * 2, 0, kWindowWidth, kWindowHeight)];
    view2.backgroundColor = RgbColor(231, 231, 231);
    self.webView2 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 100, kWindowWidth, kWindowHeight - 100)];
    self.webView2.delegate = self;
    self.webView2.scrollView.bounces = NO;
    UIView *view1_2 = [[UIView alloc] initWithFrame:CGRectMake(kWindowWidth * 3, 0, kWindowWidth, kWindowHeight)];
    view1_2.backgroundColor = RgbColor(231, 231, 231);
    UIView *view2_2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
    view2_2.backgroundColor = RgbColor(231, 231, 231);
    UIActivityIndicatorView *activityInd1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    activityInd1.center = CGPointMake(kWindowWidth / 2.0, kWindowHeight / 2.0);
    [activityInd1 startAnimating];
    [view1 addSubview:activityInd1];
    UIActivityIndicatorView *activityInd2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    activityInd2.center = CGPointMake(kWindowWidth / 2.0, kWindowHeight / 2.0);
    [activityInd2 startAnimating];
    [view2 addSubview:activityInd2];
    UIActivityIndicatorView *activityInd3 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    activityInd3.center = CGPointMake(kWindowWidth / 2.0, kWindowHeight / 2.0);
    [activityInd3 startAnimating];
    [view1_2 addSubview:activityInd3];
    UIActivityIndicatorView *activityInd4 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    activityInd4.center = CGPointMake(kWindowWidth / 2.0, kWindowHeight / 2.0);
    [activityInd4 startAnimating];
    [view2_2 addSubview:activityInd4];
    self.view1 = view1;
    self.view2 = view2;
    [scrolleView addSubview:view2_2];
    [scrolleView addSubview:_view1];
    [scrolleView addSubview:_view2];
    [scrolleView addSubview:view1_2];
    [self setTopView];
}

- (void)setTopView{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 120)];
    _topView.backgroundColor = RgbColor(255, 255, 255);
    self.btnBack = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _btnBack.frame = CGRectMake(0, 0, kWindowWidth, 40);
    [_btnBack setTitle:@"返回" forState:(UIControlStateNormal)];
    _btnBack.titleLabel.textAlignment = NSTextAlignmentLeft;
    _btnBack.titleEdgeInsets = UIEdgeInsetsMake(50, -_btnBack.frame.size.width/2.0-90, 50, 30);
    [_btnBack addTarget:self action:@selector(turnBack) forControlEvents:(UIControlEventTouchUpInside)];
    [_btnBack setTitleColor:RgbColor(255, 255, 255) forState:(UIControlStateNormal)];
    [_btnBack setBackgroundColor:RgbColor(96, 196, 253)];
    self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, kWindowWidth - 10, 20)];
    _lblDate.textColor = RgbColor(50, 50, 50);
    _lblDate.font = [UIFont systemFontOfSize:15];
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 65, kWindowWidth - 10, 50)];
    _lblTitle.font = [UIFont systemFontOfSize:24];
    _lblTitle.numberOfLines = 0;
    [_topView addSubview:_btnBack];
    [_topView addSubview:_lblDate];
    [_topView addSubview:_lblTitle];
}

- (void)turnBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int currentPage = (int)scrollView.contentOffset.x / kWindowWidth;
    if (currentPage == 0) {
        [scrollView setContentOffset:CGPointMake(kWindowWidth * 2, 0) animated:NO];
        currentPage = 2;
    }
    if (currentPage == 3) {
        [scrollView setContentOffset:CGPointMake(kWindowWidth * 1, 0) animated:NO];
        currentPage = 1;
    }
    [self loadWebView:currentPage];
}

int currentPage = 0;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    currentPage = 0;
    [self loadWebView:1];
}
- (void)loadWebView:(int)page{
    if (currentPage == page) {
        return;
    }
    NSString *headPath = [[NSBundle mainBundle] pathForResource:@"head" ofType:@"html"];
    NSString *footPath = [[NSBundle mainBundle] pathForResource:@"foot" ofType:@"html"];
    NSString *strHead = [NSString stringWithContentsOfFile:headPath encoding:NSUTF8StringEncoding error:nil];
    NSString *strFoot = [NSString stringWithContentsOfFile:footPath encoding:NSUTF8StringEncoding error:nil];
    if (page == 1) {
        [LCPNetWorking getNetWorkingData:ARTICAL_URL Method:@"get" Parameter:nil CallBack:^(id object, id error) {
            NSString *html = [NSString stringWithFormat:@"%@%@%@",strHead,object[@"body"],strFoot];
            NSArray *array = [self.view1 subviews];
            for (int i = 0; i< array.count; i++) {
                [array[i] removeFromSuperview];
            }
            self.lblDate.text = object[@"date_created"];
            self.lblTitle.text = object[@"title"];
            [self.webView1 loadHTMLString:html baseURL:nil];
            
        }];
    }else if (page == 2){
        [LCPNetWorking getNetWorkingData:ARTICAL_URL Method:@"get" Parameter:nil CallBack:^(id object, id error) {
            NSString *html = [NSString stringWithFormat:@"%@%@%@",strHead,object[@"body"],strFoot];
            NSArray *array = [self.view1 subviews];
            for (int i = 0; i< array.count; i++) {
                [array[i] removeFromSuperview];
            }
            self.lblDate.text = object[@"date_created"];
            self.lblTitle.text = object[@"title"];
            [self.webView2 loadHTMLString:html baseURL:nil];
            
        }];
    }
    currentPage = page;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([webView isEqual:self.webView1]) {
        [self.view1 addSubview:self.webView1];
        [self.view1 addSubview:self.topView];
        [self.webView2 removeFromSuperview];
    }else{
        [self.view2 addSubview:self.webView2];
        [self.view2 addSubview:self.topView];
        [self.webView1 removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
