//
//  PhotoScrollView.m
//  HomeWork08
//
//  Created by morplcp on 15/10/9.
//  Copyright (c) 2015年 MyOClesson.com. All rights reserved.
//

#import "PhotoScrollView.h"

@interface PhotoScrollView ()

@property(nonatomic, strong)MMMaterialDesignSpinner *sp;

@end

@implementation PhotoScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    
    }
    return self;
}

- (void)timeClick:(NSTimer *)timer{
    if (self.imgView.image != nil) {
        [_sp removeFromSuperview];
        [timer stop];
    }
}

// 重写imgView的set方法
- (void)setImgView:(UIImageView *)imgView{
    if (_imgView != imgView) {
        _imgView = imgView;
        [self setPhotoScrollView:self];
        [self addSubview:_imgView];
    }
    
}
// 设置相框
- (void)setPhotoScrollView:(UIScrollView *)photoVC{
    photoVC.contentSize = self.frame.size;
    photoVC.minimumZoomScale = 0.5;
    photoVC.maximumZoomScale = 2;
    photoVC.delegate = self;
}

// 缩放结束后，设置图片居中
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if (scrollView.zoomScale <= 1) {
        _imgView.center = CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y);
    }
}
// 实现缩放代理,返回当前imgView
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imgView;
}

@end
