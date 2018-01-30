//
//  UILabel+TextColor.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/30.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "UILabel+TextColor.h"

// 解决故事板、xib 设置 textColor 无效的问题。


@implementation UILabel (TextColor)

+ (void)load {
    [super load];
    Method originalMethod = class_getInstanceMethod([self class], @selector(awakeFromNib));
    Method swizzledMethod = class_getInstanceMethod([self class], @selector(yc_awakeFromNib));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)yc_awakeFromNib {
    if ([self respondsToSelector:@selector(yc_awakeFromNib)]) {
        [self yc_awakeFromNib];
    }
    if ([self isKindOfClass:[UILabel class]]) {
        self.textColor = self.textColor;
    }
}


@end
