//
//  CGDatePickerView.h
//  CGKnowledge
//
//  Created by mochenyang on 2017/5/27.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CGDatePickerViewBlock)(NSDate *date);
typedef void(^CGDatePickerViewCancel)(void);

@interface CGDatePickerView : UIView

-(instancetype)initWithFrame:(CGRect)frame block:(CGDatePickerViewBlock)block cancel:(CGDatePickerViewCancel)cancel;

-(void)setMaxDateLimit:(NSDate *)date;

-(void)showInView:(UIView *)view;

@end
