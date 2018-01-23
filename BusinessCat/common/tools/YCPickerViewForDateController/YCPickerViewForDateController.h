//
//  YCPickerViewForDateController.h
//  BusinessCat
//
//  Created by 余超 on 2018/1/20.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCPickerViewForDateController : UIViewController

//@property (nonatomic, strong) NSDate *date;        // default is current date when picker created. Ignored in countdown timer mode. for that mode, picker starts at 0:00
//@property (nonatomic, strong) NSDate *maximumDate; // default is nil.



@property (weak, nonatomic) IBOutlet UILabel *titleLabel; // 不要直接设置 text，设置 hint 属性
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) NSString *hint; // titleLabel 显示的文字

@property (nonatomic, assign) UIDatePickerMode mode; // time, date

@property (nonatomic, strong) NSDate *minimumDate; // 默认是今天。如果设置的日期是今天，而且时间已经超过23:45，会被修改为明天

@property (nonatomic,copy) void (^onSelectItemBlock)(NSDate *date);

@end
