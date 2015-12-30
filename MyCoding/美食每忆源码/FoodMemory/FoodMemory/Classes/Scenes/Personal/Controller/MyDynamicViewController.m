//
//  MyDynamicViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/15.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "MyDynamicViewController.h"
#import "MyDynamicViewCell.h"
#import "CommentTableViewController.h"
@interface MyDynamicViewController ()

@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign)int currentPage;

@end

static NSString *identifier = @"dynamicCell";
@implementation MyDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title= @"我去吃过";
    self.currentPage = 1;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyDynamicViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    [self addHeaderView];
    [self addFooterView];
}

// 添加下拉刷新
- (void)addHeaderView{
    AVUser *user = [AVUser currentUser];
    __weak typeof(self)vc = self;
    [self.tableView addHeaderWithCallback:^{
        [LeanCloudDBHelper findObjectWithClassName:@"dynamic" ConditionKey:@"uId" ConditionValue:user.objectId HasArrayKey:@"imgArray" PageSize:20 Page:1 Return:^(id result) {
            UILabel *lblNull = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 30)];
            lblNull.textAlignment = NSTextAlignmentCenter;
            vc.tableView.tableHeaderView = lblNull;
            if ([result count] == 0) {
                [vc.tableView headerEndRefreshing];
                lblNull.text = @"暂时没有数据";
            }else{
                vc.tableView.tableHeaderView = nil;
                [vc.dataArray setArray:result];
                [vc.tableView headerEndRefreshing];
                [vc.tableView reloadData];
            }
        }];
    }];
    [self.tableView headerBeginRefreshing];
}

// 添加上拉加载
- (void)addFooterView{
    AVUser *user = [AVUser currentUser];
    __weak typeof(self)vc = self;
    [self.tableView addFooterWithCallback:^{
       [LeanCloudDBHelper findObjectWithClassName:@"dynamic" ConditionKey:@"uId" ConditionValue:user.objectId HasArrayKey:@"imgArray" PageSize:20 Page:vc.currentPage++ Return:^(id result) {
           if ([result count] == 0) {
               LCPLog(@"没了");
           }else{
               for (AVObject *obj in result) {
                   [vc.dataArray addObject:obj];
               }
               [vc.tableView reloadData];
           }
       }];
    }];
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
    MyDynamicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.dynamic = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AVObject *obj = self.dataArray[indexPath.row];
    CommentTableViewController *com = [CommentTableViewController new];
    com.dynamic = obj;
    [self.navigationController pushViewController:com animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark -lazyLoad
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
