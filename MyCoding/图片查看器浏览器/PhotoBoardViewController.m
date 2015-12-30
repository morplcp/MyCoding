//
//  PhotoBoardViewController.m
//  HomeWork08
//
//  Created by morplcp on 15/10/9.
//  Copyright (c) 2015年 MyOClesson.com. All rights reserved.
//

#import "PhotoBoardViewController.h"
#import "PhotoBoardScrollView.h"
@interface PhotoBoardViewController ()<UIScrollViewDelegate>

@property(nonatomic, retain) PhotoBoardScrollView *photoBoardView;
@property(nonatomic, retain) UIPageControl *pageControl;

@end

@implementation PhotoBoardViewController

// 加载动画使用了MMMaterialDesignSpinner第三方
- (void)viewDidLoad {
    [super viewDidLoad];
    MMMaterialDesignSpinner *sp = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake((kWindowWidth - 80) / 2.0, kWindowHeight / 2.0 - 40, 80, 80)];
    sp.lineWidth = 2.0;
    sp.tintColor = [UIColor cyanColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sp startAnimating];
        [self.view addSubview:sp];
        [self loadPhotoBoard];
        [self loadPageControl];
    });
}

// 加载相册
- (void)loadPhotoBoard{
    self.view.backgroundColor = [UIColor grayColor];
    self.photoBoardView = [[PhotoBoardScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismisVC:)];
    [self.view addGestureRecognizer:tap];
    _photoBoardView.delegate = self;
    [_photoBoardView setImgArray:[self loadImageArray]];
    [self setOffset:_photoBoardView];
    [self.view addSubview:_photoBoardView];
    [self.photoBoardView.imgArray[self.currentPhoto] sd_setImageWithURL:self.imgArray[self.currentPhoto]];
}

- (void)dismisVC:(UIGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 加载图片数组
- (NSArray *)loadImageArray{
    NSMutableArray *photoArray = [NSMutableArray array];
    for (int i = 0; i < self.imgArray.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
         imgView.contentMode = UIViewContentModeScaleAspectFit;
        [photoArray addObject:imgView];
    }
    return photoArray;
}
// 设置偏移量
- (void)setOffset:(UIScrollView *)sender{
    sender.contentOffset = CGPointMake(self.view.frame.size.width * self.currentPhoto, 0);
}
// 加载PageControl
- (void)loadPageControl{
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200) / 2.0, (self.view.frame.size.height - 100), 200, 30)];
    _pageControl.numberOfPages = self.imgArray.count;
    _pageControl.currentPage = _currentPhoto;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    [self.view addSubview:_pageControl];
}

// 减速结束后将拖拽前缩放过的图片还原
- (void)scrollViewDidEndDecelerating:(PhotoBoardScrollView *)scrollView{
    _pageControl.currentPage = _photoBoardView.contentOffset.x / self.view.frame.size.width;
    [self.photoBoardView.imgArray[_pageControl.currentPage] sd_setImageWithURL:self.imgArray[_pageControl.currentPage]];
    // 将所有图片缩放比例置为1
    for (PhotoScrollView *psc in _photoBoardView.photoScrollArray) {
        [psc setZoomScale:1];
    }
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
