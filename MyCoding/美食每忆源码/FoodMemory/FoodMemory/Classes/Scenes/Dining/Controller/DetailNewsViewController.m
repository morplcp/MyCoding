//
//  DetailNewsViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/3.
//  Copyright © 2015年 morplcp. All rights reserved.

#import "DetailNewsViewController.h"
#import "News.h"
#define NAVBAR_CHANGE_POINT 50
@interface DetailNewsViewController ()<UIWebViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIView *view1;
@property (strong, nonatomic) UIImageView *img;
@property (strong, nonatomic) UIWebView *bodyWab;
@property (strong, nonatomic) UILabel *lab4title;
@property (strong, nonatomic) UILabel *lab4source;

@end

@implementation DetailNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBodyView];
    [self requestCell];
}

- (void)setBodyView {
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:scrollView];
    UIView *view1 = [[UIView alloc] initWithFrame:self.view.frame];
//    view1.backgroundColor = [UIColor clearColor];
    
    
    self.img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight/3.0)];
    self.lab4title = [[UILabel alloc]initWithFrame:CGRectMake(30, kWindowHeight/5.0, kWindowWidth- 60, 50)];
    _lab4title.textColor = [UIColor whiteColor];
    _lab4title.font = [UIFont systemFontOfSize:20];
    _lab4title.numberOfLines = 0;
    self.lab4source = [[UILabel alloc]initWithFrame:CGRectMake(kWindowWidth-150, kWindowHeight/3.0 - 25, 130, 20)];
    _lab4source.textColor = [UIColor whiteColor];
    _lab4source.font = [UIFont systemFontOfSize:15];
    [self.img addSubview:_lab4title];
    [self.img addSubview:_lab4source];
    self.bodyWab = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
    self.bodyWab.delegate = self;
    self.bodyWab.scrollView.delegate = self;
    self.bodyWab.scrollView.bounces = NO;
    self.bodyWab.scrollView.contentInset = UIEdgeInsetsMake(kWindowHeight/3.0, 0, 0, 0);
    self.view1 = view1;
    [_view1 addSubview:_bodyWab];
    [_view1 addSubview:_img];
    
    [scrollView addSubview:_view1];
}

//
- (void)requestCell{
    // 拼接字符串
    NSString * str = [NSString stringWithFormat:@"%@%@",kCellURL,self.sring];;
    NSString *headPath = [[NSBundle mainBundle] pathForResource:@"head2" ofType:@"html"];
    NSString *footPath = [[NSBundle mainBundle] pathForResource:@"foot" ofType:@"html"];
    NSString *strHead = [NSString stringWithContentsOfFile:headPath encoding:NSUTF8StringEncoding error:nil];
    NSString *strFoot = [NSString stringWithContentsOfFile:footPath encoding:NSUTF8StringEncoding error:nil];
    
    [LCPNetWorking getNetWorkingData:str Method:@"get" Parameter:nil CallBack:^(id object, id error) {
        News *new =[News new];
        [new setValuesForKeysWithDictionary:object];
        [self.img sd_setImageWithURL:[NSURL URLWithString:new.image]];
         NSString *html = [NSString stringWithFormat:@"%@%@%@",strHead,new.body,strFoot];
        self.lab4title.text = new.title;
        self.lab4source.text  = new.image_source;
        [self.bodyWab loadHTMLString:html baseURL:nil];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGRect rect = _img.frame;
    rect.origin.y = -offsetY - kWindowHeight/3.0;
    self.img.frame = rect;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
