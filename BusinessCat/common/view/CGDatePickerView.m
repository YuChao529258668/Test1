//
//  CGDatePickerView.m
//  CGKnowledge
//
//  Created by mochenyang on 2017/5/27.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGDatePickerView.h"

#define margin 40
#define pickerHeight 216
#define whiteViewHeight (pickerHeight + margin + 20)

@interface CGDatePickerView()

@property(nonatomic,copy)CGDatePickerViewBlock block;
@property(nonatomic,copy)CGDatePickerViewCancel cancel;
@property(nonatomic,retain)UIDatePicker *picker;
@property(nonatomic,retain)UIView *whiteView;
@property(nonatomic,retain)UIButton *okBtn;
@property(nonatomic,retain)UIButton *cancelBtn;

@end

@implementation CGDatePickerView

-(instancetype)initWithFrame:(CGRect)frame block:(CGDatePickerViewBlock)block cancel:(CGDatePickerViewCancel)cancel{
    self = [super initWithFrame:frame];
    if(self){
        self.block = block;
        self.cancel = cancel;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        self.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
        [self addGestureRecognizer:tap];
        
        self.whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, whiteViewHeight)];
        self.whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.whiteView];
        
        self.okBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, margin)];
        [self.okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.okBtn setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
        [self.whiteView addSubview:self.okBtn];
        [self.okBtn addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-70, 0, 70, margin)];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.whiteView addSubview:self.cancelBtn];
        [self.cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.picker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.okBtn.frame),frame.size.width,pickerHeight)];
        self.picker.locale = [NSLocale currentLocale];
        self.picker.timeZone = [NSTimeZone systemTimeZone];
        self.picker.datePickerMode = UIDatePickerModeDate;
        [self.whiteView addSubview: self.picker];
        
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:-10];//设置最小时间为：当前时间前推十年
        NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        self.picker.minimumDate = minDate;
    }
    return self;
}

-(void)setMaxDateLimit:(NSDate *)date{
  if (date) {
    long second = [date timeIntervalSince1970];
    second -= 60*60*8;
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:second];
    self.picker.maximumDate = newDate;
    self.picker.date = newDate;
  }else{
    self.picker.maximumDate = nil;
    self.picker.date = [NSDate date];
  }
}

-(void)okBtnAction{
    if(self.block){
        NSDate *current = self.picker.date;
        self.block([current dateByAddingTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMTForDate:current]]);
    }
    [self close];
}

-(void)cancelBtnAction{
    if(self.cancel){
        self.cancel();
    }
    [self close];
}

-(void)showInView:(UIView *)view{
    [view addSubview:self];
    __weak typeof(self) weakSelf = self;
    CGRect whiteRect = self.whiteView.frame;
    whiteRect.origin.y = self.frame.size.height-whiteViewHeight;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8
          initialSpringVelocity:3 options:UIViewAnimationOptionAllowUserInteraction animations:^{
              weakSelf.whiteView.frame = whiteRect;
              weakSelf.alpha = 1;
          }completion:^(BOOL finished) {
              
          }];
}

-(void)close{
    __weak typeof(self) weakSelf = self;
    CGRect whiteRect = self.whiteView.frame;
    whiteRect.origin.y = self.frame.size.height;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8
          initialSpringVelocity:3 options:UIViewAnimationOptionAllowUserInteraction animations:^{
              weakSelf.whiteView.frame = whiteRect;
              weakSelf.alpha = 0;
          }completion:^(BOOL finished) {
              [weakSelf removeFromSuperview];
              if(self.cancel){
                  self.cancel();
              }
          }];
}

@end
