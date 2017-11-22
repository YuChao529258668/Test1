//
//  YCDatePickerViewController.h
//  BusinessCat
//
//  Created by 余超 on 2017/11/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCDatePickerViewController : UIViewController
@property (nonatomic,copy) void (^onDecitdeDate)(NSDate *date);
@property (nonatomic, strong) NSDate *minimumDate;
+ (instancetype)picker;
@end
