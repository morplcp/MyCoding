//
//  IWantViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/15.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "IWantViewController.h"
#import "IWantViewCell.h"
#import "CommentTableViewController.h"
@interface IWantViewController ()
@property(nonatomic, strong)NSMutableArray *dataArray;
@end

static NSString *identifier = @"iWantCell";
@implementation IWantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"我想去吃";
    [self.tableView registerNib:[UINib nibWithNibName:@"IWantViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    [self addHeaderView];
}

// 添加下拉刷新
- (void)addHeaderView{
    __weak typeof(self)vc = self;
    [self.tableView addHeaderWithCallback:^{
        if (vc.dataArray.count > 0) {
            [vc.dataArray removeAllObjects];
        }
        AVUser *user = [AVUser currentUser];
        NSString *like = [user objectForKey:@"like_dynamic"];
        NSMutableArray *array = [[like componentsSeparatedByString:@","] mutableCopy];
        // 去除空元素
        [array removeLastObject];
        for (NSString *dynamicId in array) {
            [vc.dataArray addObject:dynamicId];
        }
        [vc.tableView reloadData];
        [vc.tableView headerEndRefreshing];
    }];
    [self.tableView headerBeginRefreshing];
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
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IWantViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.dynamicId = self.dataArray[indexPath.row];
   // cell.dynamic = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [LeanCloudDBHelper findObjectWithClassName:@"dynamic" ConditionKey:@"objectId" ConditionValue:self.dataArray[indexPath.row] HasArrayKey:@"imgArray" Return:^(id result) {
        AVObject *obj = [result lastObject];
        CommentTableViewController *com = [CommentTableViewController new];
        com.dynamic = obj;
        [self.navigationController pushViewController:com animated:YES];
    }];
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
