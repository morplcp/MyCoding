//
//  NewsViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/3.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "NewsViewController.h"
#import "News.h"
#import "NewsCell.h"
#import "DetailNewsViewController.h"
@interface NewsViewController ()
// 承接新闻
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, assign)NSInteger currentDate;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:@"identCell"];
    [self addHeaderView];
    [self addFooterView];
}

-(void)requestData{
    [LCPNetWorking getNetWorkingData:kNewsURL Method:@"get" Parameter:nil CallBack:^(id object, id error) {
        if (self.dataArray.count > 0) {
            [self.dataArray removeAllObjects];
        }
        NSArray *array = object[@"stories"];
        self.currentDate = [object[@"date"] integerValue];
        // 数组遍历
        for (NSDictionary * dic in array) {
            // 初始化model
            News * new = [News new];
            [new setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:new];
        }
        [self.tableView headerEndRefreshing];
        [self.tableView reloadData];
    }];
}

// 下拉刷新
- (void)addHeaderView{
    __block typeof (self)vc = self;
    [self.tableView addHeaderWithCallback:^{
        [vc requestData];
    }];
    [self.tableView headerBeginRefreshing];
}

// 上拉加载
- (void)addFooterView{
    __block typeof (self)vc = self;
    [self.tableView addFooterWithCallback:^{
        [LCPNetWorking getNetWorkingData:[NSString stringWithFormat:@"%@%ld",kOldNews,--(vc.currentDate)] Method:@"get" Parameter:nil CallBack:^(id object, id error) {
            NSArray *array = object[@"stories"];
            // 数组遍历
            for (NSDictionary * dic in array) {
                // 初始化model
                News * new = [News new];
                [new setValuesForKeysWithDictionary:dic];
                [vc.dataArray addObject:new];
            }
            [vc.tableView footerEndRefreshing];
            [vc.tableView reloadData];
        }];
    }];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identCell" forIndexPath:indexPath];
    News * news = _dataArray[indexPath.row];
    [cell setNews:news];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailNewsViewController * detail = [[DetailNewsViewController alloc]init];
    News *model = _dataArray[indexPath.row];
    detail.sring = model.id;
    
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}



#pragma mark ----懒加载----
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

- (IBAction)btnDismiss:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
