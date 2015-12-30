//
//  CPBannerView.h
//  CPScrollView
//
//  Created by morplcp on 15/12/29.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPBannerView;

@protocol CPBannerViewDelegate <NSObject>

- (void)bannerView:(CPBannerView *)banner bannerDidSelectIndex:(NSInteger)index;

@end

@interface CPBannerView : UIView
// 代理
@property (nonatomic, weak) id<CPBannerViewDelegate> delegate;
// 通过资源初始化
- (instancetype)initWithFrame:(CGRect)frame bannerSource:(NSMutableArray *)bannerSource;
// 带标题初始化
- (instancetype)initWithBannerSource:(NSMutableArray *)bannerSource ImageTitle:(NSMutableArray *)titleArray Frame:(CGRect)frame;

@end
