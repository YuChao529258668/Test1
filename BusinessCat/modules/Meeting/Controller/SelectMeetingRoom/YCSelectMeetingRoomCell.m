//
//  YCSelectMeetingRoomCell.m
//  BusinessCat
//
//  Created by 余超 on 2018/3/14.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCSelectMeetingRoomCell.h"

@interface YCSelectMeetingRoomCell()<UIGestureRecognizerDelegate>
@end

@implementation YCSelectMeetingRoomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setupSingleClickGesture];
    [self setupDoubleClickGesture];
}

- (void)setupSingleClickGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleClick:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)setupDoubleClickGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleClick:)];
    tap.numberOfTapsRequired = 2;
//    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)handleSingleClick:(UITapGestureRecognizer *)tap {
    NSLog(@"单击");
    [[NSNotificationCenter defaultCenter]postNotificationName:[self.class notificationNameOfSingleClick] object:self];
}

- (void)handleDoubleClick:(UITapGestureRecognizer *)tap {
    NSLog(@"双击");
    [[NSNotificationCenter defaultCenter]postNotificationName:[self.class notificationNameOfDoubleClick] object:self];
}


+ (NSString *)notificationNameOfSingleClick {
    return @"YCSelectMeetingRoomCellSingleClickNotification";
}

+ (NSString *)notificationNameOfDoubleClick {
    return @"YCSelectMeetingRoomCellDoubleClickNotification";
}

// 没用
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return NO;
//}

// 前者失效。后者失败了，前者才会触发。解决单击和双击冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

// 没用
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    if (touch.tapCount == 2) {
//        return NO;
//    }
//    return YES;
//}


@end
