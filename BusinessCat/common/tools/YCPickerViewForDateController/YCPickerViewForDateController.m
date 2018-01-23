//
//  YCPickerViewForDateController.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/20.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCPickerViewForDateController.h"

@interface YCPickerViewForDateController ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) NSArray *datas;

@end

@implementation YCPickerViewForDateController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    if (self.mode == UIDatePickerModeTime) {
        [self createHH_MMs];
    } else {
        [self createYY_MM_DDs];
    }
    
    self.titleLabel.text = self.hint;
}


#pragma mark - UIPickerViewDelegate

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.datas[row];
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.datas.count;
}


#pragma mark -

- (void)createHH_MMs {
    NSDateFormatter *f = [NSDateFormatter new];
    int beginHour = 0;
    int beginMinute = 0;
    
    
    if (self.minimumDate) {
        NSDate *earlyDate = [self.minimumDate earlierDate:[NSDate date]];
        if (earlyDate == self.minimumDate) {
            self.minimumDate = [NSDate date];
        }
    } else {
        self.minimumDate = [NSDate date];
    }
    
    // 计算开始的小时和分钟
    f.dateFormat = @"HH";
    beginHour = [f stringFromDate:self.minimumDate].intValue;
    
    f.dateFormat = @"mm";
    beginMinute = [f stringFromDate:self.minimumDate].intValue;
    
    // 如果不加判断，就会少了 00:00 这种情况，比如日期是明天。
    if (beginHour + beginMinute != 0) {
        beginMinute = (beginMinute / 15 + 1) * 15; // 00, 15, 30, 45,
        if (beginMinute == 60) {
            // 60 进 1
            beginMinute = 0;
            beginHour ++;
            
            if (beginHour == 24) {
                beginHour = 0;
            }
        }
    }
    
    
    // 构造字符串
    NSMutableArray *hh_mms = [NSMutableArray array];
    NSString *hh_mm;
    for (int j = beginMinute; j < 46; j+=15) {
        hh_mm = [NSString stringWithFormat:@"%02d:%02d", beginHour, j];
        [hh_mms addObject:hh_mm];
    }
    beginHour ++;
    beginMinute = 0;
    
    for (int i = beginHour; i < 24; i++) {
        for (int j = beginMinute; j < 46; j+=15) {
            hh_mm = [NSString stringWithFormat:@"%02d:%02d", i, j];
            [hh_mms addObject:hh_mm];
        }
    }
    [hh_mms addObject:@"23:59"];

    self.datas = hh_mms;
}

- (void)createYY_MM_DDs {
    NSDateFormatter *f = [NSDateFormatter new];
    BOOL isToday = NO;
    
    // 判断是否今天
    if (self.minimumDate) {
        f.dateFormat = @"yyyyMMdd";
        isToday = [[f stringFromDate:[NSDate date]] isEqualToString:[f stringFromDate:self.minimumDate]];
    } else {
        self.minimumDate = [NSDate date];
        isToday = YES;
    }
    
    // 判断今天是否超过 23:45 了
    if (isToday) {
        f.dateFormat = @"HH";
        int beginHour = [f stringFromDate:self.minimumDate].intValue;
        
        f.dateFormat = @"mm";
        int beginMinute = [f stringFromDate:self.minimumDate].intValue;
        
        if (beginHour == 23 && beginMinute >= 45) {
            self.minimumDate = [self.minimumDate dateByAddingTimeInterval:24 * 60 *60];
        }
    }

    // 构造字符串
    NSDate *date = self.minimumDate;
    f.dateFormat = @"yyyy年MM月dd日 EEEE";
    NSMutableArray *yy_mm_dds = [NSMutableArray arrayWithCapacity:30];

    for (int i = 0; i < 30; i++) {
        [yy_mm_dds addObject:[f stringFromDate:date]];
        date = [date dateByAddingTimeInterval:24 * 60 * 60];
    }

    self.datas = yy_mm_dds;
}

- (IBAction)clickCancelBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickOKBtn:(id)sender {
    if (self.onSelectItemBlock) {
        NSDate *date;
        NSDateFormatter *f = [NSDateFormatter new];
        NSInteger row = [self.pickerView selectedRowInComponent:0];

        if (self.mode == UIDatePickerModeTime) {
            f.dateFormat = @"yyyy年MM月dd日";
            NSString *ymd = [f stringFromDate:self.minimumDate];
            
            NSString *hh_mm = self.datas[row];
            NSString *dateString = [NSString stringWithFormat:@"%@ %@", ymd, hh_mm];
            
            f.dateFormat = @"yyyy年MM月dd日 HH:mm";
            date = [f dateFromString:dateString];
        } else {
            NSString *dateString = self.datas[row];
            f.dateFormat = @"yyyy年MM月dd日 EEEE";
            date = [f dateFromString:dateString];
        }

        self.onSelectItemBlock(date);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
