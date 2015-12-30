//
//  SelectLocationController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/8.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "SelectLocationController.h"
#import <MapKit/MapKit.h>

@interface SelectLocationController ()<BMKPoiSearchDelegate,CLLocationManagerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) BMKPoiSearch *search;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign)CLLocationCoordinate2D location;

@property (nonatomic, strong) UITextField *txtSearch;

@property (nonatomic, strong) UITextField *txtLocation;

@property (nonatomic, strong) CLLocationManager *manager;
@end
static NSString *locationCell = @"locationCell";
@implementation SelectLocationController

// 懒加载
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (CLLocationManager *)manager{
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager.delegate = self;
    
    self.search = [[BMKPoiSearch alloc] init];
    self.search.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:locationCell];
    self.view.backgroundColor = RgbColor(231, 231, 231);
    [self setupView];
}

- (void)setupView{
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 120)];
    searchView.backgroundColor = [UIColor whiteColor];
    self.txtSearch = [[UITextField alloc] initWithFrame:CGRectMake(5, 30, kWindowWidth - 100, 30)];
    UIButton *btnSearch = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [btnSearch setTitle:@"搜索" forState:(UIControlStateNormal)];
    btnSearch.frame = CGRectMake(kWindowWidth - 105, 30, 100, 30);
    btnSearch.backgroundColor = RgbColor(45, 153, 255);
    [btnSearch setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [btnSearch addTarget:self action:@selector(searchClick)
        forControlEvents:(UIControlEventTouchUpInside)];
    _txtSearch.placeholder = @"查找位置";
    _txtSearch.borderStyle = UITextBorderStyleRoundedRect;
    _txtSearch.delegate = self;
    _txtSearch.text = @"美食";
    self.txtLocation = [[UITextField alloc]initWithFrame:CGRectMake(5, 75, kWindowWidth - 100, 30)];
    _txtLocation.placeholder = @"您可以手动输入位置";
    _txtLocation.borderStyle = UITextBorderStyleRoundedRect;
    UIButton *btnLocation = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [btnLocation setTitle:@"确定" forState:(UIControlStateNormal)];
    btnLocation.frame = CGRectMake(kWindowWidth - 105, 75, 100, 30);
    btnLocation.backgroundColor = RgbColor(45, 153, 255);
    [btnLocation setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [btnLocation addTarget:self action:@selector(selectClick)
        forControlEvents:(UIControlEventTouchUpInside)];
    
    [searchView addSubview:_txtLocation];
    [searchView addSubview:_txtSearch];
    [searchView addSubview:btnSearch];
    [searchView addSubview:btnLocation];
    self.tableView.tableHeaderView = searchView;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = locations.lastObject;
    self.location = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
   // [self.manager stopUpdatingLocation];
    [self searchClick];
}

- (void)searchClick{
    // 清除之前的数据
    [self.dataArray removeAllObjects];
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageCapacity = 20;
    option.sortType = BMK_POI_SORT_BY_DISTANCE;
    option.location = self.location;
    option.keyword = self.txtSearch.text;
    BOOL flag = [_search poiSearchNearBy:option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
    
}

// 自己选择位置
- (void)selectClick{
    if ([self.txtLocation.text isEqualToString:@""] || self.txtLocation.text == nil) {
        [self alertNoAction:@"您输入的位置不能为空" Duration:1];
        return;
    }
    self.locationname(self.txtLocation.text);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    if (errorCode == BMK_OPEN_NO_ERROR) {
        for (BMKPoiInfo *info in poiResult.poiInfoList) {
            [self.dataArray addObject:info.name];
        }
        [self.manager stopUpdatingLocation];
        [self.tableView reloadData];
    }else{
        NSLog(@"检索错了");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:locationCell forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

// 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *selectKey = self.dataArray[indexPath.row];
    self.locationname(selectKey);
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.manager startUpdatingLocation];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
