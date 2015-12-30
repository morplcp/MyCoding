//
//  CommentTableViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/14.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "CommentTableViewController.h"
#import "CommentViewCell.h"
#import "TableViewCell.h"
#import "DynamicCollViewCell.h"
#import "AppDelegate.h"
#import "PhotoBoardViewController.h"
#import "PostCommentViewController.h"
@interface CommentTableViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)UIView *viewTableHeader; // 评论列表头视图
@property(nonatomic, strong)UIImageView *imgUserPic; // 用户头像
@property(nonatomic, strong)UILabel *lblUserNickName; // 用户昵称
@property(nonatomic, strong)UILabel *lblPostDate; // 动态发布时间
@property(nonatomic, strong)UIButton *btnLike; // 赞按钮
@property(nonatomic, strong)UILabel *lblContent; // 动态内容
@property(nonatomic, strong)UICollectionView *collPicView; // 图片展示的集合视图
@property(nonatomic, strong)UILabel *lblLocationName; // 位置名
@property(nonatomic, strong)UILabel *lblCommentCount; // 评论个数
@property(nonatomic, strong)UITableView *tableComment; // 评论列表

@property(nonatomic, strong)NSMutableArray *commentArray;
@property(nonatomic, strong)NSMutableArray *imgHArray;
@property(nonatomic, strong)NSMutableArray *imgArray;

@end

static NSString *collCellIdent = @"imgCell";
@implementation CommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentViewCell" bundle:nil] forCellReuseIdentifier:@"commentCell"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"动态详情";
    UIBarButtonItem *postComment = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-pinglun"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = postComment;
    AVUser *user = [AVUser currentUser];
    if ([[self.dynamic objectForKey:@"uId"] isEqualToString:user.objectId]) {
        [postComment setImage:nil];
    }else{
        [postComment setImage:[UIImage imageNamed:@"iconfont-pinglun"]];
    }
    // 页面布局
    [self setupView];
}

- (void)setupView{
    // 设置头视图
    CGFloat dynamicContentHeight = [self getTextHeight:[self.dynamic objectForKey:@"content"]];
    CGFloat collHeight = 0.0f;
    NSArray *imgArray = [self.dynamic objectForKey:@"imgArray"];
    if (imgArray.count > 0 && imgArray.count <= 3) {
        collHeight = (kWindowWidth - 30) / 3.0 + 10;
    }else if (imgArray.count > 3 && imgArray.count <= 6){
        collHeight = (kWindowWidth - 30) / 3.0 * 2 + 16;
    }else if (imgArray.count > 6 && imgArray.count <= 9){
        collHeight = ((kWindowWidth - 30) / 3.0) * 3 + 20;
    }else{
        collHeight = 0.0f;
    }
    CGFloat viewHeight = 60 + dynamicContentHeight + collHeight + 65;
    self.viewTableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, viewHeight)];
    NSArray *array = [self.dynamic objectForKey:@"imgArray"];
    self.imgUserPic = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
    _imgUserPic.layer.masksToBounds = YES;
    _imgUserPic.layer.cornerRadius = 25;
    self.lblUserNickName = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, kWindowWidth - 75, 20)];
    self.lblPostDate = [[UILabel alloc] initWithFrame:CGRectMake(_lblUserNickName.frame.origin.x, 35, _lblUserNickName.frame.size.width, 20)];
    _lblPostDate.font = [UIFont systemFontOfSize:15];
    _lblPostDate.textColor = [UIColor darkGrayColor];
    self.lblContent = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, kWindowWidth - 20, dynamicContentHeight)];
    // 创建布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collPicView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, _lblContent.frame.origin.y + _lblContent.frame.size.height + 10, kWindowWidth - 10, collHeight) collectionViewLayout:flowLayout];
    self.lblLocationName = [[UILabel alloc] initWithFrame:CGRectMake(10, self.viewTableHeader.frame.size.height - 50, kWindowWidth - 20, 20)];
    self.lblCommentCount = [[UILabel alloc] initWithFrame:CGRectMake(5, self.viewTableHeader.frame.size.height - 30, kWindowWidth - 10, 30)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    _lblPostDate.text =  [dateFormatter stringFromDate:_dynamic.createdAt];
    _lblContent.text = [self.dynamic objectForKey:@"content"];
    _collPicView.delegate = self;
    _collPicView.dataSource = self;
    _collPicView.backgroundColor = [UIColor whiteColor];
    [_collPicView registerNib:[UINib nibWithNibName:@"DynamicCollViewCell" bundle:nil] forCellWithReuseIdentifier:collCellIdent];
    _lblLocationName.text = [self.dynamic objectForKey:@"location_name"];
    _lblLocationName.font = [UIFont systemFontOfSize:13];
    _lblLocationName.textColor = [UIColor darkGrayColor];
    for (AVFile *file in array) {
        [self.imgHArray addObject:file.url];
        NSString *urlStr = [file getThumbnailURLWithScaleToFit:YES width:200 height:200];
        [self.imgArray addObject:urlStr];
    }
    __weak typeof(self)vc = self;
    AVQuery *query = [AVUser query];
    [query whereKey:@"objectId" equalTo:[self.dynamic objectForKey:@"uId"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error != nil) {
            ;
        }else {
            vc.lblUserNickName.text = [[objects lastObject] objectForKey:@"userNickName"];
            AVFile *file = [[objects lastObject] objectForKey:@"userPic"];
            [file getThumbnail:YES width:100 height:100 withBlock:^(UIImage *image, NSError *error) {
                vc.imgUserPic.image = image;
            }];
        }
    }];
    [self.viewTableHeader addSubview:_imgUserPic];
    [self.viewTableHeader addSubview:_lblUserNickName];
    [self.viewTableHeader addSubview:_lblPostDate];
    [self.viewTableHeader addSubview:_lblContent];
    [self.viewTableHeader addSubview:_collPicView];
    [self.viewTableHeader addSubview:_lblLocationName];
    [self.viewTableHeader addSubview:_lblCommentCount];
    self.tableView.tableHeaderView = _viewTableHeader;
}

// 发送评论
- (void)rightItemClick{
    AVUser *user = [AVUser currentUser];
    if (user == nil) {
        [self alertNoAction:@"请先登录" Duration:1];
    }else{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PostCommentViewController *postVC = [sb instantiateViewControllerWithIdentifier:@"postCommentVC"];
        postVC.dynamicId = self.dynamic.objectId;
        [self.navigationController pushViewController:postVC animated:YES];
    }
}

// 获取文本高度
- (CGFloat)getTextHeight:(NSString *)str{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(kWindowWidth - 40, 10000)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
                                    context:nil];
    return rect.size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 查询所有的评论
    __weak typeof(self)vc = self;
    LeanCloudDBHelper *lean = [LeanCloudDBHelper new];
    [lean findObjectWithCql:@"select * from Comment where dynamicId = ?",self.dynamic.objectId];
    lean.returnResult = ^(id result){
        [vc.commentArray setArray:result];
        [vc.tableView reloadData];
    };
    [LeanCloudDBHelper findObjectWithClassName:@"dynamic" ConditionKey:@"objectId" ConditionValue:self.dynamic.objectId HasArrayKey:nil Return:^(id result) {
        AVObject *obj = [result lastObject];
        LCPLog(@"%@",[obj objectForKey:@"comments_count"]);
        vc.lblCommentCount.text = [NSString stringWithFormat:@"评论(%@)",[obj objectForKey:@"comments_count"]];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    cell.commentObj = self.commentArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AVObject *obj = self.commentArray[indexPath.row];
    return 74 + [self getTextHeight:[obj objectForKey:@"commentContent"]];
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DynamicCollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collCellIdent forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.imgArray[indexPath.row]]];
    cell.imgIndex = indexPath.row;
    __weak typeof(self)vc = self;
    cell.showImage = ^(NSInteger index){
        AppDelegate *dele = [UIApplication sharedApplication].delegate;
        PhotoBoardViewController *photoVC = [PhotoBoardViewController new];
        photoVC.currentPhoto = index;
        photoVC.imgArray = vc.imgHArray;
        [dele.mmdVC presentViewController:photoVC animated:YES completion:nil];
    };
    return cell;
}
#pragma mark -UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kWindowWidth - 30) / 3.0, (kWindowWidth - 30) / 3.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2.5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

#pragma mark -laztLoad
- (NSMutableArray *)commentArray{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (NSMutableArray *)imgHArray{
    if (!_imgHArray) {
        _imgHArray = [NSMutableArray array];
    }
    return _imgHArray;
}

- (NSMutableArray *)imgArray{
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
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
