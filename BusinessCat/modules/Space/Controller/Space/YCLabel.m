//
//  YCLabel.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/30.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCLabel.h"

@implementation YCLabel
//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    self = [super initWithCoder:coder];
//    NSLog(@"%@", self.textColor);
//
//    if (self) {
//        NSLog(@"%@", self.textColor);
//    }
//    return self;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    NSLog(@"%@", self.textColor);
//
//    if (self) {
//        NSLog(@"%@", self.textColor);
//
//    }
//    return self;
//}
- (void)awakeFromNib {
//    NSLog(@"%@", self.textColor);
//    NSLog(@"%@", [UIColor blackColor]);
//    self.textColor = [UIColor blueColor];
    self.textColor = self.textColor;

    [super awakeFromNib];
//    NSLog(@"%@", self.textColor);
//    NSLog(@"%@", [UIColor blackColor]);
//    self.textColor = [UIColor blueColor];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"%@", self.textColor);
//
//    });
}
@end
