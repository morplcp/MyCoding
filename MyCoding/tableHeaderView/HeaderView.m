//
//  HeaderView.m
//  tabelHeader
//
//  Created by morplcp on 15/12/19.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "HeaderView.h"
#import "UIImage+ImageEffects.h"
@interface HeaderView ()

@property (nonatomic, strong) UIScrollView *imageScrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *bluredImageView;

@end

#define FRAME_DEFAULT CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)

static CGFloat PARALLAX = 0.5f;

@implementation HeaderView

+ (id)headerViewWithImage:(UIImage *)image forSize:(CGSize)headerSize{
    HeaderView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    headerView.headerImage = image;
    [headerView setupView];
    return headerView;
}
+ (id)headerViewWithCGSize:(CGSize)headerSize{
    HeaderView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    [headerView setupView];
    return headerView;
}

- (void)setHeaderImage:(UIImage *)headerImage{
    _headerImage = headerImage;
    self.imageView.image = headerImage;
    [self refreshBlurViewWithNewImage];
}

- (void)layoutHeaderViewWithScrollViewOffset:(CGPoint)offset{
    CGRect frame = self.imageScrollView.frame;
    if (offset.y > 0) {
        frame.origin.y = MAX(offset.y * PARALLAX, 0);
        self.imageScrollView.frame = frame;
        self.bluredImageView.alpha = 1 / FRAME_DEFAULT.size.height * offset.y * 2;
        self.clipsToBounds = YES;
    }else{
        CGFloat delta = 0.0f;
        CGRect rect = FRAME_DEFAULT;
        delta = fabs(MIN(0.0f, offset.y));
        rect.origin.y -= delta;
        rect.size.height += delta;
        self.imageScrollView.frame = rect;
        self.clipsToBounds = NO;
    }
}

- (void)setupView{
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.imageView = [[UIImageView alloc] initWithFrame:_imageScrollView.bounds];
    //
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.image = self.headerImage;
    [self.imageScrollView addSubview:_imageView];
    
    self.bluredImageView = [[UIImageView alloc] initWithFrame:self.imageView.frame];
    _bluredImageView.autoresizingMask = _imageView.autoresizingMask;
    _bluredImageView.alpha = 0.0f;
    [self.imageScrollView addSubview:_bluredImageView];
    [self addSubview:_imageScrollView];
    [self refreshBlurViewWithNewImage];
    
}

- (UIImage *)screenShotOfView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(FRAME_DEFAULT.size, YES, 0.0f);
    [self drawViewHierarchyInRect:FRAME_DEFAULT afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)refreshBlurViewWithNewImage{
    UIImage *screenShot = [self screenShotOfView:self];
    screenShot = [screenShot applyBlurWithRadius:5 tintColor:[UIColor colorWithWhite:0.6 alpha:0.2] saturationDeltaFactor:1.0 maskImage:nil];
    self.bluredImageView.image = screenShot;
}

@end
