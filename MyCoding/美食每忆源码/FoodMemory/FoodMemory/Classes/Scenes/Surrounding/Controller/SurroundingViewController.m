//
//  SurroundingViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/10.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "SurroundingViewController.h"
#import "AppDelegate.h"
#import "CateDetailViewController.h"
#import "CateViewController.h"
#import "ShopViewController.h"
#import "DIYViewController.h"
#import "MMDrawerBarButtonItem.h"

@interface SurroundingViewController ()<BMKPoiSearchDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) BMKPoiSearch *search;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) CateViewController *cateVC;
@property (nonatomic, strong) ShopViewController *shopVC;
@property (nonatomic, strong) DIYViewController *diyVC;
// segmentController的标题
@property (nonatomic, strong) NSArray *segmentNameArray;
// 用于接收详情页面所需要的信息
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

// 重用标识符
static NSString *viewIdentifier = @"viewCell";

@implementation SurroundingViewController

// 懒加载
- (BMKPoiSearch *)search{
    if (!_search) {
        _search = [[BMKPoiSearch alloc] init];
    }
    return _search;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (NSArray *)segmentNameArray{
    if (!_segmentNameArray) {
        _segmentNameArray = [NSArray array];
    }
    return _segmentNameArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化位置管理器
    AppDelegate * mydelegate = [UIApplication sharedApplication].delegate;
    mydelegate.locationManager.delegate = self;
    self.search.delegate = self;
    [self setupLeftMenuButton];
    // 初始化并且添加为子视图
    self.cateVC = [[CateViewController alloc] init];
    self.shopVC = [[ShopViewController alloc] init];
    self.diyVC = [[DIYViewController alloc] init];
    [self addChildViewController:_cateVC];
    [self addChildViewController:_shopVC];
    [self addChildViewController:_diyVC];
    [self.view addSubview:_cateVC.view];
    // UISegmentedControl 的简单设置
    self.segmentNameArray= @[@"附近美食", @"休闲娱乐", @"吃货之家"];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:_segmentNameArray];
    //修改字体的默认颜色与选中颜色
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:18],NSFontAttributeName ,nil];
    [self.segmentedControl setTitleTextAttributes:dic forState:UIControlStateSelected];
    _segmentedControl.frame = CGRectMake(30, 67, kWindowWidth-60, 35);
    _segmentedControl.tintColor = [UIColor orangeColor];
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventValueChanged];
    [_cateVC.view addSubview:_segmentedControl];
    // UITableView的初始化、代理和数据源、注册、添加到视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, kWindowWidth, kWindowHeight - 49 - 64 - 40)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:viewIdentifier];
    [_cateVC.view addSubview:_tableView];
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    [appdelegate.mmdVC toggleDrawerSide:(MMDrawerSideLeft) animated:YES completion:nil];
}
// 设置左抽屉按钮
-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

// UISegmentedControl点击事件
- (void)changeView:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        if ([sender.superview isEqual:_shopVC.view]) {
            [self transitionFromViewController:_shopVC toViewController:_cateVC duration:0.5 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
                
            } completion:^(BOOL finished) {
                
            }];
        } else {
            [self transitionFromViewController:_diyVC toViewController:_cateVC duration:0.5 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
                
            } completion:^(BOOL finished) {
                
            }];
        }
        [_cateVC.view addSubview:sender];
    } else if (sender.selectedSegmentIndex == 1) {
        if ([sender.superview isEqual:_cateVC.view]) {
            [self transitionFromViewController:_cateVC toViewController:_shopVC duration:0.5 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
                
            } completion:^(BOOL finished) {
                
            }];
        } else {
            [self transitionFromViewController:_diyVC toViewController:_shopVC duration:0.5 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
                
            } completion:^(BOOL finished) {
                
            }];
        }
        [_shopVC.view addSubview:sender];
    } else if (sender.selectedSegmentIndex == 2) {
        if ([sender.superview isEqual:_cateVC.view]) {
            [self transitionFromViewController:_cateVC toViewController:_diyVC duration:0.5 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
                
            } completion:^(BOOL finished) {
                
            }];
        } else {
            [self transitionFromViewController:_shopVC toViewController:_diyVC duration:0.5 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
                
            } completion:^(BOOL finished) {
                
            }];
        }
        [_diyVC.view addSubview:sender];
    }
}

// 当定位到用户位置时就会调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = locations.lastObject;
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc] init];
    option.pageCapacity = 30;
    option.location = location.coordinate;
//    option.location = CLLocationCoordinate2DMake(39.915, 116.404); // 模拟器测试
    option.keyword = @"附近美食";
    BOOL flag = [_search poiSearchNearBy:option];
    if (flag) {
        NSLog(@"检索成功");
        //检索成功后就停止定位
        [manager stopUpdatingLocation];
    }else{
        NSLog(@"检索失败");
    }
}

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    if (errorCode == BMK_OPEN_NO_ERROR) {
        for (BMKPoiInfo *info in poiResult.poiInfoList) {
            NSLog(@"%@",info.name);
        }
        // 接收所有数据
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:viewIdentifier forIndexPath:indexPath];
    BMKPoiInfo *info = self.dataArray[indexPath.row];
    cell.textLabel.text = info.name;
    return cell;
}
// 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BMKPoiInfo *info = self.dataArray[indexPath.row];
    CateDetailViewController *detail = [CateDetailViewController new];
    detail.info = info;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
