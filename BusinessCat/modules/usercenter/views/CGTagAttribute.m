//
//  CGTagAttribute.m
//  CGSays
//
//  Created by zhu on 2016/11/28.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGTagAttribute.h"

@implementation CGTagAttribute

- (instancetype)init
{
  self = [super init];
  if (self) {
    _borderWidth = 0.7f;
    _borderColor = CTCommonLineBg;
    _selectBorderColor = CTThemeMainColor;
    _cornerRadius = 3.0f;
    _normalBackgroundColor = [UIColor whiteColor];
    _selectedBackgroundColor = [UIColor whiteColor];
    _titleSize = 14;
    _textColor = [UIColor grayColor];
    _selectTextColor = CTThemeMainColor;
    _keyColor = [UIColor redColor];
    _tagSpace = 20;
  }
  return self;
}
@end
