//
//  UILabel+TextColor.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/30.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "UILabel+TextColor.h"

// 解决故事板、xib 设置 textColor 无效的问题。
// 看板界面，cell 按钮的文字颜色会自动设置成黑色。。。。


@implementation UILabel (TextColor)

+ (void)load {
    [super load];
    Method originalMethod = class_getInstanceMethod([self class], @selector(awakeFromNib));
    Method swizzledMethod = class_getInstanceMethod([self class], @selector(yc_awakeFromNib));
    method_exchangeImplementations(originalMethod, swizzledMethod);
    
    Method originalMethod2 = class_getInstanceMethod([self class], @selector(setTextColor:));
    Method swizzledMethod2 = class_getInstanceMethod([self class], @selector(yc_setTextColor:));
    method_exchangeImplementations(originalMethod2, swizzledMethod2);
}

- (void)yc_awakeFromNib {
    if ([self respondsToSelector:@selector(yc_awakeFromNib)]) {
        [self yc_awakeFromNib];
    }
    if ([self isKindOfClass:[UILabel class]]) {
        self.textColor = self.textColor;
    }
}

// 看板界面，cell 按钮的文字颜色会自动设置成黑色。。。。
- (void)yc_setTextColor:(UIColor *)textColor {
    if ([self.attributedText.string isEqualToString:@"您未加入共享，请加入"]) {
//        NSLog(@"%@", self.attributedText.string);
        textColor = [YCTool colorWithRed:253 green:129 blue:128 alpha:1];
    }
    [self yc_setTextColor:textColor];
}


@end
