//
//  CPBannerView.m
//  CPScrollView
//
//  Created by morplcp on 15/12/29.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "CPBannerView.h"

#define BASE_TAG 1000

@interface CPBannerView ()<UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSMutableArray *bannerSource;
@property(nonatomic, strong) NSMutableArray *titleArray;
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation CPBannerView

#pragma mark -initMethod

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:({
            self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
            _scrollView.delegate = self;
            _scrollView.showsHorizontalScrollIndicator = NO;
            _scrollView.showsVerticalScrollIndicator = NO;
            _scrollView.pagingEnabled = YES;
            _scrollView;
        })];
        // 构建轮播图
        [self buildBanner];
        [self startTimer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame bannerSource:(NSMutableArray *)bannerSource{
    if (bannerSource) {
        self.bannerSource = bannerSource;
        self = [self initWithFrame:frame];
        return self;
    }
    return nil;
}

- (instancetype)initWithBannerSource:(NSMutableArray *)bannerSource ImageTitle:(NSMutableArray *)titleArray Frame:(CGRect)frame{
    if (bannerSource && titleArray) {
        self.bannerSource = bannerSource;
        self.titleArray = titleArray;
        self = [self initWithFrame:frame];
        return self;
    }
    return nil;
}

#pragma mark -BannerMethod

// 创建轮播图
- (void)buildBanner{
    if (_titleArray) {
        id firstTitle = self.titleArray.firstObject;
        [self.titleArray insertObject:self.titleArray.lastObject atIndex:0];
        [self.titleArray addObject:firstTitle];
    }
    // 将数组第一个元素取出
    id firstObject = self.bannerSource.firstObject;
    
    // 将数组最后一个复制一份插入到数组第一个位置
    [self.bannerSource insertObject:self.bannerSource.lastObject atIndex:0];
    
    // 将第一个元素复制一份添加到最后一个
    [self.bannerSource addObject:firstObject];
    
    // 设置滚动视图
    NSInteger imageCount = self.bannerSource.count;
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * imageCount, self.frame.size.height);
    
    for (int i = 0; i < imageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        if (_titleArray) {
            if (_titleArray[i]) {
                UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40)];
                titleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
                UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleView.frame.size.width, titleView.frame.size.height)];
                lblTitle.textColor = [UIColor whiteColor];
                lblTitle.text = _titleArray[i];
                [titleView addSubview:lblTitle];
                [imageView addSubview:titleView];
            }
        }
        // 判断资源是什么类型
        id item = self.bannerSource[i];
        if ([item isKindOfClass:[UIImage class]]) {
            
            imageView.image = item;
            
        }else if([item isKindOfClass:[NSURL class]]){
            // 子线程中加载网络图片数据
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:item];
                // 加载完成后回到主线程更新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *image = [UIImage imageWithData:data];
                    imageView.image = image;
                });
            });
        }else if ([item isKindOfClass:[NSString class]]){
            // 判断是否是本地图片资源
            UIImage *imageWithName = [UIImage imageNamed:item];
            if (imageWithName) {
                imageView.image = imageWithName;
            }else{
                // 子线程中加载网络图片数据
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:item]];
                    // 加载完成后回到主线程更新UI
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImage *image = [UIImage imageWithData:data];
                        imageView.image = image;
                    });
                });
            }
        }else{
            NSAssert(0, @"没有匹配的数据类型!");
        }
        CGRect frame = _scrollView.frame;
        imageView.frame = CGRectMake(frame.size.width * i, 0, frame.size.width, frame.size.height);
        [_scrollView addSubview:imageView];
        // 给每一张图片添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
        imageView.userInteractionEnabled = YES;
        // 让第一张图片的tag为1000
        [imageView setTag:BASE_TAG + i - 1];
        [imageView addGestureRecognizer:tap];
    }
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
}

// 处理轮播图点击手势
- (void)clickImageView:(UITapGestureRecognizer *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(bannerView:bannerDidSelectIndex:)]) {
        // 让计时器重新计时
        [self stopTimer];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startTimer];
        });
        // 设置偏移量为当前点击的图片
        NSInteger currentPage = sender.view.tag - BASE_TAG;
        if (currentPage == _bannerSource.count - 2) {
            currentPage = 0;
        }
        _scrollView.contentOffset = CGPointMake(self.frame.size.width * (currentPage + 1), 0);
        [_delegate bannerView:self bannerDidSelectIndex:(currentPage)];
    }
}

// 滑动到下一个imageView
- (void)scrollNextImageView{
    CGPoint currentOffset = _scrollView.contentOffset;
    currentOffset.x += self.scrollView.frame.size.width;
    [_scrollView setContentOffset:currentOffset animated:YES];
    [self scrollViewDidEndDecelerating:_scrollView];
}

#pragma mark -UIScrollViewDelegate
// 滑动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    NSInteger imageCount = _bannerSource.count;
    if (point.x == scrollView.frame.size.width * (imageCount - 1)) {
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    }else if(point.x == 0){
        [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width * (imageCount - 2), 0) animated:NO];
    }
}

// 手动拖拽时停止自动滚动
// 即将拖拽的时候
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

// 拖拽结束的时候
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}

#pragma mark -timerMethod

- (void)startTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollNextImageView) userInfo:nil repeats:YES];
}

- (void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}



@end
