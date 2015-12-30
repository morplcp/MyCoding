//
//  EditViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/9.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "EditViewController.h"
#import "LCPImageView.h"
#import "LCPPicker.h"
#import "CityDataManager.h"
@interface EditViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewForUPic;
@property (weak, nonatomic) IBOutlet UITextField *txtSign;
@property (nonatomic, strong) LCPImageView *imgUPic;
@property (weak, nonatomic) IBOutlet UITextField *txtNickName;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UIPickerView *pickGender;
@property (weak, nonatomic) IBOutlet UITextField *txtHobby;
@property (weak, nonatomic) IBOutlet UILabel *lblAdd;
@property (weak, nonatomic) IBOutlet UIView *viewSelectCity;
@property (weak, nonatomic) IBOutlet UIView *viewPick;
@property (nonatomic, assign) BOOL changePic;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.imgUPic = [[LCPImageView alloc] initWithFrame:CGRectMake((kWindowWidth - 100) / 2.0, 10, 100, 100)];
    [self.viewForUPic addSubview:_imgUPic];
    self.changePic = NO;
    // 给各个控件赋值
    AVUser *user = [AVUser currentUser];
    self.txtSign.text = [user objectForKey:@"sign"];
    AVFile *file = [user objectForKey:@"userPic"];
    [file getThumbnail:YES width:100 height:100 withBlock:^(UIImage *image, NSError *error) {
        self.imgUPic.image = image;
    }];
    self.txtNickName.text = [user objectForKey:@"userNickName"];
    self.txtName.text = [user objectForKey:@"uName"];
    self.txtHobby.text = [user objectForKey:@"hobby"];
    self.lblAdd.text = [user objectForKey:@"add"];
    __weak typeof(self)vc = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[user objectForKey:@"gender"] isEqualToString:@"F"]) {
            [vc.pickGender selectRow:1 inComponent:0 animated:YES];
        }else{
            [vc.pickGender selectRow:0 inComponent:0 animated:YES];
        }
    });
    // 设置其他控件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCity)];
    [self.viewSelectCity addGestureRecognizer:tap];
    self.pickGender.delegate = self;
    self.pickGender.dataSource = self;
    UITapGestureRecognizer *tapPick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickClick)];
    self.pickGender.userInteractionEnabled = NO;
    [self.viewPick addGestureRecognizer:tapPick];
}

- (IBAction)actionSave:(UIBarButtonItem *)sender {
    LCPSpinnerView *spinner = [[LCPSpinnerView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
    [self.view.window addSubview:spinner];
    [spinner show];
    AVUser *user = [AVUser currentUser];
    if ([self.pickGender selectedRowInComponent:0] == 0) {
        [user setObject:@"M" forKey:@"gender"];
    }else{
        [user setObject:@"F" forKey:@"gender"];
    }
    [user setObject:self.txtSign.text forKey:@"sign"];
    [user setObject:self.txtNickName.text forKey:@"userNickName"];
    [user setObject:self.txtName.text forKey:@"uName"];
    [user setObject:self.txtHobby.text forKey:@"hobby"];
    [user setObject:self.lblAdd.text forKey:@"add"];
    [user setObject:@"" forKey:@"collectionDIY"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [spinner close];
            [self alertNoAction:@"修改成功" Duration:1];
        }else{
            [spinner close];
            [self alertNoAction:@"修改失败" Duration:1];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark -UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}

#pragma mark -UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (row == 0) {
        return @"男";
    }else{
        return @"女";
    }
}

#pragma mark -customMethod

- (void)pickClick{
    if ([self.pickGender selectedRowInComponent:0] == 0) {
        [self.pickGender selectRow:1 inComponent:0 animated:YES];
    }else{
        [self.pickGender selectRow:0 inComponent:0 animated:YES];
    }
}

- (void)selectCity{
    LCPPicker *pick = [[LCPPicker alloc] initWithDictionary:[CityDataManager sharedDataManager].cityArray];
    [self.view.window addSubview:pick];
    [pick show];
    pick.selectCity = ^(NSString *city){
        self.lblAdd.text = city;
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
