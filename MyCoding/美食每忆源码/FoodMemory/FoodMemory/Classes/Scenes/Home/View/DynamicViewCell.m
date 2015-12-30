//
//  DynamicViewCell.m
//  FoodMemory
//
//  Created by morplcp on 15/12/6.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "DynamicViewCell.h"
#import "DynamicCollViewCell.h"
#import "AppDelegate.h"
#import "PhotoBoardViewController.h"
#import "LoginViewController.h"
#import "CommentTableViewController.h"
@interface DynamicViewCell ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)NSMutableArray *placehoderArray;
@property(nonatomic, strong)AVUser *user;

@end

@implementation DynamicViewCell

static NSString *collCellIdent = @"imgColllCell";

- (void)awakeFromNib {
    self.user = [AVUser currentUser];
    [self.collView registerNib:[UINib nibWithNibName:@"DynamicCollViewCell" bundle:nil] forCellWithReuseIdentifier:collCellIdent];
    self.collView.delegate = self;
    self.collView.dataSource = self;
    self.collView.backgroundColor = RgbColor(255, 255, 255);
    self.collView.bounces = NO;
    [self setBodyHeight];
}

- (void)setDynamic:(AVObject *)dynamic{
    if (self.imgArray.count > 0) {
        [self.imgArray removeAllObjects];
    }
    if (self.imgHArray.count > 0) {
        [self.imgHArray removeAllObjects];
    }
    AVUser *user = [AVUser currentUser];
    NSString *like_dynamic = [user objectForKey:@"like_dynamic"];
    NSArray *strArray = [like_dynamic componentsSeparatedByString:@","];
    BOOL isLike = NO;
    for (NSString *str in strArray) {
        if ([str isEqualToString:dynamic.objectId]) {
            isLike = YES;
        }
    }
    if (isLike) {
        [self.btnZan setImage:[UIImage imageNamed:@"iconfont-zan"] forState:(UIControlStateNormal)];
    }else{
        [self.btnZan setImage:[UIImage imageNamed:@"iconfont-nozan"] forState:(UIControlStateNormal)];
    }
    _dynamic = dynamic;
    _lblContent.text = [dynamic objectForKey:@"content"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    self.contentHeight.constant = [self getTextHeight:_lblContent.text];
    [dateFormatter setDateFormat:@"MM-dd"];
    _lblPostDate.text = [dateFormatter stringFromDate:dynamic.createdAt];
    _lblLocationName.text = [dynamic objectForKey:@"location_name"];
    [_btnZan setTitle:[NSString stringWithFormat:@"%@",[dynamic objectForKey:@"praise_count"]] forState:(UIControlStateNormal)];
    [_btnCommend setTitle:[NSString stringWithFormat:@"%@",[dynamic objectForKey:@"comments_count"]] forState:(UIControlStateNormal)];
    _imgUserPic.layer.masksToBounds = YES;
    _imgUserPic.layer.cornerRadius = 23;
    AVQuery *query = [AVUser query];
    [query whereKey:@"objectId" equalTo:[dynamic objectForKey:@"uId"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error != nil) {
            ;
        }else {
            self.lblUserNick.text = [[objects lastObject] objectForKey:@"userNickName"];
            AVFile *file = [[objects lastObject] objectForKey:@"userPic"];
            __weak typeof(self)vc = self;
            [file getThumbnail:YES width:100 height:100 withBlock:^(UIImage *image, NSError *error) {
                vc.imgUserPic.image = image;
            }];
        }
    }];
    NSArray *array = [dynamic objectForKey:@"imgArray"];
    for (AVFile *file in array) {
        [self.imgHArray addObject:file.url];
        NSString *urlStr = [file getThumbnailURLWithScaleToFit:YES width:200 height:200];
        [self.imgArray addObject:urlStr];
    }
    [self getCollHeight:self.imgArray];
}

// 设置图片展示view的高度
- (void)getCollHeight:(NSArray *)array{
    if (array.count > 0 && array.count <= 3) {
        self.collHeight.constant = (kWindowWidth - 60) / 3.0 + 10;
    }else if (array.count > 3 && array.count <= 6){
        self.collHeight.constant = (kWindowWidth - 60) / 3.0 * 2 + 16;
    }else if (array.count > 6 && array.count <= 9){
        self.collHeight.constant = (kWindowWidth - 60) / 3.0 * 3 + 20;
    } else if (array.count == 0){
        self.collHeight.constant = 0;
    }
    [self setBodyHeight];
    [self.collView reloadData];
}

// 获取文本高度
- (CGFloat)getTextHeight:(NSString *)str{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(kWindowWidth - 40, 10000)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
                                    context:nil];
    return rect.size.height;
}

// 设置动态展示view的高度
- (void)setBodyHeight{
    if (self.collHeight.constant == 0) {
        self.bodyViewHeight.constant = self.contentHeight.constant + 8;
    }
    self.bodyViewHeight.constant = [self getTextHeight:_lblContent.text] + self.collHeight.constant + 16;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
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

#pragma maek -UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kWindowWidth - 60) / 3.0, (kWindowWidth - 60) / 3.0);
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

#pragma mark -lazyLoad

- (NSMutableArray *)imgArray{
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}

- (NSMutableArray *)imgHArray{
    if (!_imgHArray) {
        _imgHArray = [NSMutableArray array];
    }
    return _imgHArray;
}

- (NSMutableArray *)placehoderArray{
    if (!_placehoderArray) {
        _placehoderArray = [NSMutableArray array];
    }
    return _placehoderArray;
}

- (IBAction)actionZan:(UIButton *)sender {
    
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser == nil) {
        AppDelegate *dele = [UIApplication sharedApplication].delegate;
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = [sb instantiateViewControllerWithIdentifier:@"loginVC"];
        loginVC.backhandel = ^(){
            [dele.mmdVC.tabBarController setSelectedIndex:0];
        };
        [dele.mmdVC presentViewController:loginVC animated:YES completion:nil];
        return;
    }
    
    NSString *like = [currentUser objectForKey:@"like_dynamic"];
    if (like == nil) {
        like = @"";
    }
    NSArray *strArray = [like componentsSeparatedByString:@","];
    BOOL isLike = NO;
    for (NSString *str in strArray) {
        if ([str isEqualToString:self.dynamic.objectId]) {
            isLike = YES;
        }
    }
    if (isLike) {
        NSMutableString *str = [NSMutableString stringWithString:like];
        NSRange range = [str rangeOfString:[NSString stringWithFormat:@"%@%@",self.dynamic.objectId,@","]];
        [str deleteCharactersInRange:range];
        NSString *newStr = [NSString stringWithString:str];
        [currentUser setObject:newStr forKey:@"like_dynamic"];
        [currentUser saveInBackground];
        [self.btnZan setImage:[UIImage imageNamed:@"iconfont-nozan"] forState:(UIControlStateNormal)];
        NSInteger count = [self.btnZan.titleLabel.text integerValue];
        count--;
        [self.btnZan setTitle:[NSString stringWithFormat:@"%ld",count] forState:(UIControlStateNormal)];
        [self.dynamic setObject:[NSNumber numberWithInteger:count]forKey:@"praise_count"];
        [self.dynamic saveInBackground];
    }else{
        NSString *newStr = [NSString stringWithFormat:@"%@%@,",like,self.dynamic.objectId];
        [currentUser setObject:newStr forKey:@"like_dynamic"];
        [self.dynamic incrementKey:@"praise_count"];
        [self.dynamic saveInBackground];
        [self.btnZan setImage:[UIImage imageNamed:@"iconfont-zan"] forState:(UIControlStateNormal)];
        NSInteger count = [self.btnZan.titleLabel.text integerValue];
        count++;
        [self.btnZan setTitle:[NSString stringWithFormat:@"%ld",count] forState:(UIControlStateNormal)];
        [currentUser saveInBackground];
    }
}

// 评论
- (IBAction)actionCommend:(UIButton *)sender {
    CommentTableViewController *com = [CommentTableViewController new];
    UITableViewController *tbVC = (UITableViewController *)[self viewController:self];
    com.dynamic = self.dynamic;
    [tbVC.navigationController pushViewController:com animated:YES];
}
- (UIViewController*)viewController:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
// 举报
- (IBAction)actionReport:(UIButton *)sender {
    self.report(self.dynamic);
}



@end
