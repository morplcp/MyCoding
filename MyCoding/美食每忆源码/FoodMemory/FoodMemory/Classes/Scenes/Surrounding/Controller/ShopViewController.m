//
//  ShopViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/10.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "ShopViewController.h"
#import "ShopDetailViewController.h"

@interface ShopViewController ()<BMKPoiSearchDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) BMKPoiSearch *search;
@property (nonatomic, strong) UITableView *tableView;
// 用于接收零食铺子所有的信息
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign)CLLocationCoordinate2D location;

@end

// 重用标识符
static NSString *shopIdentifier = @"shopCell";

@implementation ShopViewController

// 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // UITableView的初始化、代理和数据源、注册、添加到视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, kWindowWidth, kWindowHeight - 49 - 64 - 40)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:shopIdentifier];
    [self.view addSubview:_tableView];
    
    self.locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // 初始化并设置代理
    self.search = [[BMKPoiSearch alloc] init];
    self.search.delegate = self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = locations.lastObject;
    self.location= CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    [self startSearch];
}

- (void)startSearch{
    // 周边零食铺子检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc] init];
    option.pageCapacity = 30;
    option.location = self.location;
    //    option.location = CLLocationCoordinate2DMake(39.915, 116.404); // 模拟器测试
    option.keyword = @"休闲娱乐";
    BOOL flag = [_search poiSearchNearBy:option];
    if (flag) {
        NSLog(@"检索成功");
        [self.locationManager stopUpdatingLocation];
    }else{
        NSLog(@"检索失败");
    }
}

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    if (errorCode == BMK_OPEN_NO_ERROR) {
        for (BMKPoiInfo *info in poiResult.poiInfoList) {
            NSLog(@"%@", info.name);
        }
        // 用于接收所有数据
        self.dataArray = (NSMutableArray *)poiResult.poiInfoList;
        // 刷新数据
        [self.tableView reloadData];
    }else{
        NSLog(@"检索错了");
    }
}

#pragma mark - tableview
// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shopIdentifier forIndexPath:indexPath];
    BMKPoiInfo *info = self.dataArray[indexPath.row];
    cell.textLabel.text = info.name;
    return cell;
}
// 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BMKPoiInfo *info = self.dataArray[indexPath.row];
    ShopDetailViewController *shopVC = [[ShopDetailViewController alloc] init];
    shopVC.info = info;
    [self.navigationController pushViewController:shopVC animated:YES];
}
// 界面开始出现的时候更新用户位置
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.locationManager startUpdatingLocation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
