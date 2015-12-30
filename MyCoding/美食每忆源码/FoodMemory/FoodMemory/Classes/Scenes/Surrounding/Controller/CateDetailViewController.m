//
//  CateDetailViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/10.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "CateDetailViewController.h"
#import "UIImageView+WebCache.h"
#import <MapKit/MapKit.h>
#import "Annotation.h"

@interface CateDetailViewController ()<BMKPoiSearchDelegate,MKMapViewDelegate>

@property (nonatomic,strong) BMKPoiSearch * search;
@property (nonatomic,strong) UIImageView * imageview;
// 店的名字、地址和联系方式
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addAndPhoLabel;
@property (nonatomic, strong) UILabel *anyLabel;
// 声明地图属性
@property (nonatomic, strong) MKMapView *mapView;
// 声明一个button,在地图上返回用户当前位置
@property (nonatomic, strong) UIButton *userCurrentLocation;

@end

@implementation CateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _info.name;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addMap];
}

- (void)addMap{
    // 设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 地图的初始化
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, kWindowHeight - 300)];
    // 设置代理
    self.mapView.delegate = self;
    self.mapView.userLocation.coordinate = CLLocationCoordinate2DMake(39, 116);
    self.mapView.userLocation.title = @"您当前位置";
    // 设置追踪模式
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    [self.view addSubview:_mapView];
    
    // 设置地图显示的中心位置
    CLLocationDegrees latitude = self.mapView.userLocation.coordinate.latitude;
    CLLocationDegrees longitude = self.mapView.userLocation.coordinate.longitude;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
    // 设置地图显示的跨度
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [self.mapView setRegion:region animated:YES];
    
    // 在搜索内容上添加大头针
    Annotation *annotation = [[Annotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(_info.pt.latitude, _info.pt.longitude);
    annotation.title = _info.name;
    [self.mapView addAnnotation:annotation];
    
    // 初始化button
    self.userCurrentLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    _userCurrentLocation.frame = CGRectMake(10, self.mapView.frame.size.height - 50, 40, 40);
    [_userCurrentLocation setBackgroundImage:[UIImage imageNamed:@"22"] forState:UIControlStateNormal];
    [_userCurrentLocation addTarget:self action:@selector(backToUserLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:_userCurrentLocation];
    
    // 美食名字
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.mapView.frame.origin.y + self.mapView.frame.size.height + 20, kWindowWidth - 20, 50)];
    _nameLabel.numberOfLines = 0;
    _nameLabel.text = [NSString stringWithFormat:@"店铺名字：%@", _info.name];
    [self.view addSubview:_nameLabel];
    // 美食地址和电话
    self.addAndPhoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.mapView.frame.origin.y + self.mapView.frame.size.height + 50, kWindowWidth - 20, 100)];
    _addAndPhoLabel.numberOfLines = 0;
    NSString *address = _info.address;
    NSString *phone = _info.phone;
    _addAndPhoLabel.text = [NSString stringWithFormat:@"地址：%@\n电话：%@", address, phone];
    [self.view addSubview:_addAndPhoLabel];
    
    [self goSearch];
}

- (void)goSearch{
    CLLocationCoordinate2D loca;
    loca.latitude = _info.pt.latitude;
    loca.longitude = _info.pt.longitude;
    
    MKPlacemark *mkplack = [[MKPlacemark alloc] initWithCoordinate:loca addressDictionary:nil];
    MKMapItem *sourceItem = [[MKMapItem alloc] initWithPlacemark:mkplack];
    
    MKMapItem *destItem = [MKMapItem mapItemForCurrentLocation];
    [self findDirectionsForm:destItem  to:sourceItem];
}

- (void)findDirectionsForm:(MKMapItem *)source to:(MKMapItem *)destination{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = source;
    request.destination = destination;
    request.requestsAlternateRoutes = NO;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error:%@", error);
        } else {
            MKRoute *route = response.routes[0];
            [self.mapView addOverlay:route.polyline];
        }
    }];
}

// 对路线的设置
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor greenColor];
    renderer.lineWidth = 2.0;
    return  renderer;
}

#pragma mark - 释放地图内存
//释放地图内存
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    [self.mapView removeFromSuperview];
    [self.view addSubview:_mapView];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.mapView.showsUserLocation = NO;
    self.mapView.delegate = nil;
    [self.mapView removeFromSuperview];
    self.mapView = nil;
}

// uibutton的点击事件，返回用户当前位置
- (void)backToUserLocation{
    CLLocationCoordinate2D center = self.mapView.userLocation.location.coordinate;
    [self.mapView setCenterCoordinate:center animated:YES];
}

// 懒加载
- (BMKPoiSearch *)search{
    if (!_search) {
        _search = [[BMKPoiSearch alloc] init];
    }
    return _search;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
