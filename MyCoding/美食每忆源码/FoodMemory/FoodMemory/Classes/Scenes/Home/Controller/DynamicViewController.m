//
//  DynamicViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/4.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "DynamicViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "AppDelegate.h"
#import "DynamicViewCell.h"
#import "LoginViewController.h"
#import "ReportViewController.h"
#import "CommentTableViewController.h"
@interface DynamicViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int currentPage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *uploding;

@end

@implementation DynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"DynamicViewCell" bundle:nil] forCellReuseIdentifier:@"dynamicCell"];
    self.currentPage = 1;
    [self setupLeftMenuButton];
    [self addHeaderRefrashView];
    [self addFooterLoaderView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewDynamic:) name:@"newDynamic" object:nil];
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    [appdelegate.mmdVC toggleDrawerSide:(MMDrawerSideLeft) animated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AVObject *obj = self.dataArray[indexPath.row];
    NSArray *array = [NSArray arrayWithArray:[obj objectForKey:@"imgArray"]];
    CGFloat collHeight = 0.0f;
    if (array.count > 0 && array.count <= 3) {
        collHeight = (kWindowWidth - 60) / 3.0 + 10;
    } else if (array.count > 3 && array.count <= 6){
        collHeight = (kWindowWidth - 60) / 3.0 * 2 + 15;
    } else if (array.count > 6 && array.count <= 9){
        collHeight = (kWindowWidth - 60) / 3.0 * 3 + 20;
    } else if (array.count == 0){
        collHeight = 0;
    }
    return kDynamicBaseHeight + collHeight + [self getTextHeight:[obj objectForKey:@"content"]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dynamicCell" forIndexPath:indexPath];
    AVObject *obj = self.dataArray[indexPath.row];
    cell.dynamic = obj;
    __weak typeof(self)vc = self;
    cell.report = ^(AVObject *obj){
        ReportViewController *repVC = [vc.storyboard instantiateViewControllerWithIdentifier:@"repVC"];
        repVC.dynamicObj = obj;
        [vc.navigationController pushViewController:repVC animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AVObject *obj = self.dataArray[indexPath.row];
    CommentTableViewController *com = [CommentTableViewController new];
    com.dynamic = obj;
    [self.navigationController pushViewController:com animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView headerBeginRefreshing];
}

#pragma mark -customMethod

// 获取文本高度
- (CGFloat)getTextHeight:(NSString *)str{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(kWindowWidth - 40, 10000)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
                                    context:nil];
    return rect.size.height;
}

// 添加头部下拉刷新视图
- (void)addHeaderRefrashView{
    __weak typeof(self)vc = self;
    // 先从缓存中获取数据
    AVQuery *query = [AVQuery queryWithClassName:@"dynamic"];
    if ([query hasCachedResult]) {
        [LeanCloudDBHelper findAllCachesWithClassName:@"dynamic" HasArrayKey:nil Return:^(id result) {
            [vc.dataArray setArray:result];
            [vc.tableView reloadData];
        }];
    }
    
    [self.tableView addHeaderWithCallback:^{
        [LeanCloudDBHelper findObjectByPageWithClassName:@"dynamic" HasArrayKey:@"imgArray" PageSize:20 Page:1 Return:^(id result) {
            [vc.dataArray setArray:result];
            [vc.tableView reloadData];
            [vc.tableView headerEndRefreshing];
        }];
    }];
    [self.tableView headerBeginRefreshing];
}

// 添加上拉加载视图
- (void)addFooterLoaderView{
    __weak typeof(self)vc = self;
    [self.tableView addFooterWithCallback:^{
        [LeanCloudDBHelper findObjectByPageWithClassName:@"dynamic" HasArrayKey:@"imgArray" PageSize:20 Page:vc.currentPage + 1 Return:^(id result) {
            if ([(NSArray *)result count] == 0) {
                LCPLog(@"没有啦");
            }else{
                for (AVObject *obj in result) {
                    [vc.dataArray addObject:obj];
                }
                vc.currentPage++;
            }
            [vc.tableView reloadData];
            [vc.tableView footerEndRefreshing];
        }];
    }];
}

// 设置左抽屉按钮
-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

// 展示自己新发布的动态
-(void)getNewDynamic:(NSNotification *)info{
    if ([info.object integerValue] == 0) {
        [self.uploding setImage:[[UIImage imageNamed:@"iconfont-uploding"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
    }else{
        [self.uploding setImage:nil];
        [self.tableView headerBeginRefreshing];
    }
}

// 发布动态判断是否登录
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        AVUser *user = [AVUser currentUser];
        if (user == nil) {
            LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
            __weak typeof(self)vc = self;
            loginVC.backhandel = ^(){
                [vc.tabBarController setSelectedIndex:0];
            };
            [self presentViewController:loginVC animated:YES completion:nil];
            return;
        }
    }
}

#pragma mark -lazyLoad

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
