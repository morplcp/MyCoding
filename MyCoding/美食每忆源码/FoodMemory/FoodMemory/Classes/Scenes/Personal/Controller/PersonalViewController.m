//
//  PersonalViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/8.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "PersonalViewController.h"
#import "LoginViewController.h"
#import "ShowHDImage.h"
#import "MyDynamicViewController.h"
#import "IWantViewController.h"

@interface PersonalViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblUnickName;
@property (weak, nonatomic) IBOutlet UILabel *lblSign;
@property (weak, nonatomic) IBOutlet UIImageView *imgUPic;
@property (weak, nonatomic) IBOutlet UIImageView *imgUGender;
@property (nonatomic, strong) NSArray *menuArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnClearCaches;

@end

static NSString *perCellIdent = @"perCell";
@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:perCellIdent];
    self.menuArray = @[@"我去吃过",@"我想去吃"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    self.tableHeight.constant = self.menuArray.count * 40;
    [self getCachesSize];
    self.imgUPic.userInteractionEnabled = YES;
    self.imgUPic.layer.masksToBounds = YES;
    self.imgUPic.layer.cornerRadius = 26;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHDImage)];
    [self.imgUPic addGestureRecognizer:tap];
    
}

- (void)showHDImage{
    AVUser *user = [AVUser currentUser];
    AVFile *file = [user objectForKey:@"userPic"];
    ShowHDImage *showImg = [[ShowHDImage alloc] initWithImageURL:file.url];
    [self.view.window addSubview:showImg];
    [showImg show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _menuArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:perCellIdent forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _menuArray[indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"iconfont-chidacan"];
    }else if (indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"iconfont-zan"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LCPLog(@"%@",_menuArray[indexPath.row]);
    if (indexPath.row == 0) {
        MyDynamicViewController *dynamic = [[MyDynamicViewController alloc]init];
        [self.navigationController pushViewController:dynamic animated:YES];
    }else if (indexPath.row == 1){
        IWantViewController *iWant = [[IWantViewController alloc]init];
        [self.navigationController pushViewController:iWant animated:YES];
    }
}

- (IBAction)actionSignOut:(UIButton *)sender {
    [self confim:@"确定要退出吗？" Handel:^(BOOL result) {
        if (result) {
            [AVUser logOut];
            [self.tabBarController setSelectedIndex:0];
        }else ;
    }];
}

- (IBAction)actionAboutUs:(UIButton *)sender {
    [self alert:@"吃货大人您好，我们是您忠诚的饭奴~，您想吃什么，请跟我们说。我们将为您提供优质的服务\n快召唤我们为您提供服务吧 \n 邮箱：dzxylcp@163.com\n 电话:18315915926"];
}

- (IBAction)clearCaches:(UIButton *)sender {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    CGFloat size = [self folderSizeAtPath:cachesPath];
    NSString *cachesSize;
    if (size >= 1) {
        cachesSize = [NSString stringWithFormat:@"%.2fM",size];
    }else{
        cachesSize = [NSString stringWithFormat:@"%.2fK",size * 1024.0];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除缓存" message:@"确定清除缓存？" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *determine = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self clearCaches];
    }];
    [alert addAction:cancel];
    [alert addAction:determine];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AVUser *user = [AVUser currentUser];
    // 如果当前用户不是登录状态，则跳转至登录界面
    if (user == nil) {
        LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        __weak typeof(self)vc = self;
        loginVC.backhandel = ^(){
            [vc.tabBarController setSelectedIndex:0];
        };
        [self presentViewController:loginVC animated:YES completion:nil];
        return;
    }else{
        // 个人信息界面
        [self getCachesSize];
        AVFile *file = [user objectForKey:@"userPic"];
        [file getThumbnail:YES width:100 height:100 withBlock:^(UIImage *image, NSError *error) {
            self.imgUPic.image = image;
        }];
        self.lblUnickName.text = [user objectForKey:@"userNickName"];
        self.lblSign.text = [user objectForKey:@"sign"];
        if ([[user objectForKey:@"gender"] isEqualToString:@"F"]) {
            self.imgUGender.image = [UIImage imageNamed:@"btn_gender_F"];
        }else{
            self.imgUGender.image = [UIImage imageNamed:@"btn_gender_M"];
        }
    }
}

- (void)getCachesSize{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    CGFloat size = [self folderSizeAtPath:cachesPath];
    NSString *cachesSize;
    if (size >= 1) {
        cachesSize = [NSString stringWithFormat:@"%.2fM",size];
    }else{
        cachesSize = [NSString stringWithFormat:@"%.2fK",size * 1024.0];
    }
    [self.btnClearCaches setTitle:[NSString stringWithFormat:@"清除缓存(%@)",cachesSize] forState:(UIControlStateNormal)];
}

// 计算单个文件的大小
- (long long)fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

// 遍历文件夹获取文件大小
- (CGFloat)folderSizeAtPath:(NSString *)folderPath{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

// 清除缓存
- (void)clearCaches{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        NSLog(@"files :%ld",[files count]);
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
}
-(void)clearCacheSuccess
{
    [self getCachesSize];
    NSLog(@"清理成功");
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
