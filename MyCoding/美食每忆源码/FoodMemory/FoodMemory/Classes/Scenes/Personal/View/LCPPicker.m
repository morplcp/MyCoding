//
//  LCPPicker.m
//  FoodMemory
//
//  Created by morplcp on 15/12/10.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "LCPPicker.h"

@interface LCPPicker ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong)UIPickerView *picker;
@property (nonatomic, strong)NSArray *cityArray;
@property (nonatomic, strong)NSArray *city2Array;
@property (nonatomic, strong)NSArray *city3Array;


@end

@implementation LCPPicker

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

// 字典初始化
- (instancetype)initWithDictionary:(NSArray *)cityArray{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.frame = CGRectMake(0, 0, kWindowWidth, 0);
        self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kWindowHeight / 2.0 - 100, kWindowWidth, 200)];
        _picker.delegate = self;
        _picker.dataSource = self;
        _picker.backgroundColor = [UIColor whiteColor];
        _picker.layer.masksToBounds = YES;
        _picker.layer.cornerRadius = 3;
        UIButton *btnClose = [UIButton buttonWithType:(UIButtonTypeSystem)];
        btnClose.frame = CGRectMake(0, kWindowHeight / 2.0 + 100, kWindowWidth, 40);
        [btnClose setTitle:@"确定" forState:(UIControlStateNormal)];
        [btnClose setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        btnClose.backgroundColor = RgbColor(116, 195, 255);
        btnClose.titleLabel.font = [UIFont systemFontOfSize:19];
        [btnClose addTarget:self action:@selector(close) forControlEvents:(UIControlEventTouchUpInside)];
        self.cityArray = cityArray;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self addSubview:_picker];
            [self addSubview:btnClose];
        });
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.cityArray.count;
    }else if(component == 1){
        NSInteger row = [pickerView selectedRowInComponent:0];
        self.city2Array = self.cityArray[row][@"city"];
        return _city2Array.count;
    }else if (component == 2){
        NSInteger row = [pickerView selectedRowInComponent:1];
        self.city3Array = self.city2Array[row][@"area"];
        return _city3Array.count;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self.picker reloadAllComponents];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return self.cityArray[row][@"name"];
    }else if (component == 1){
        return self.city2Array[row][@"name"];
    }else{
        return self.city3Array[row];
    }
}

// 显示
- (void)show{
    [UIView transitionWithView:self duration:0.1 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        self.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight);
    } completion:^(BOOL finished) {
        ;
    }];
}

- (void)close{
    __weak typeof(self)vc = self;
    [UIView transitionWithView:self duration:0.1 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        vc.frame = CGRectMake(0, 0, kWindowWidth, 0);
    } completion:^(BOOL finished) {
        
        NSString *province = vc.cityArray[[vc.picker selectedRowInComponent:0]][@"name"];
        NSString *city = vc.city2Array[[vc.picker selectedRowInComponent:1]][@"name"];
        NSString *area = vc.city3Array[[vc.picker selectedRowInComponent:2]];
        vc.selectCity([NSString stringWithFormat:@"%@ %@ %@",province,city,area]);
        [vc removeFromSuperview];
    }];
}

@end
