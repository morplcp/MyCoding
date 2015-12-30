//
//  MusicListViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/3.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "MusicListViewController.h"
#import "Music.h"
#import "MusicListCell.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "LeftSettingViewController.h"
#import "LCPSpinnerView.h"
@interface MusicListViewController ()

@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)NSDictionary * dict;
@property (nonatomic, strong)UIImageView * imgView;

@end

@implementation MusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicListCell" bundle:nil] forCellReuseIdentifier:@"musicListCell"];
    LCPSpinnerView *sp = [[LCPSpinnerView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
    [self.view.window addSubview:sp];
    [sp show];
    __weak typeof(self)vc = self;
    [DataManager shareaManager].callBack = ^(){
        vc.dataArray = [[DataManager shareaManager].allMusic mutableCopy];
        [vc setTopView];
        [vc.tableView reloadData];
    };
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.dataArray = [[DataManager shareaManager].allMusic mutableCopy];
    [self setTopView];
}

- (void)setTopView{
    self.tableView.contentInset = UIEdgeInsetsMake(kWindowHeight/3.0, 0, 0, 0);
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleToFill;
    NSString *url = [DataManager shareaManager].imgURL;
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    self.imgView = imageView;
    [self.tableView addSubview:_imgView];
    [self scrollViewDidScroll:self.tableView];
    self.tableView.delegate = self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGRect f = scrollView.frame;
    f.origin.x = yOffset/3.0;
    f.origin.y = yOffset;
    f.size.height = -yOffset;
    f.size.width = -yOffset + kWindowWidth;
    self.imgView.frame = f;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"musicListCell" forIndexPath:indexPath];
    Music * music = _dataArray[indexPath.row];
    cell.music = music;
    cell.labNumber.text = [NSString stringWithFormat:@"%ld", indexPath.row+1];
    cell.labNumber.textColor = [UIColor magentaColor];
    cell.labNumber.font = [UIFont systemFontOfSize:30];
    if (indexPath.row > 2) {
        cell.labNumber.font = [UIFont systemFontOfSize:18];
        cell.labNumber.textColor = [UIColor blackColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // Music * msc = _dataArray[indexPath.row];
    LeftSettingViewController *leftVC = [LeftSettingViewController sharedPlayingPVC];
    leftVC.playIndex = indexPath.row;
    leftVC.mode = 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (IBAction)btnBack:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
