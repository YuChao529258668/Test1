//
//  YCDatePickerViewController.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/20.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCDatePickerViewController.h"

@interface YCDatePickerViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation YCDatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.minimumDate) {
        self.datePicker.minimumDate = self.minimumDate;
    }
    if (self.currentDate) {
        self.datePicker.date = self.currentDate;
    }
}

- (IBAction)decideBtnClick:(id)sender {
    if (self.onDecitdeDate) {
        self.onDecitdeDate(self.datePicker.date);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

+ (instancetype)picker {
    YCDatePickerViewController *vc = [YCDatePickerViewController new];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    return vc;
}

@end
