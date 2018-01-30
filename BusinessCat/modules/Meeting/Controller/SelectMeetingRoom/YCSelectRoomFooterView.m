//
//  YCSelectRoomFooterView.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/23.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCSelectRoomFooterView.h"

@implementation YCSelectRoomFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.label.textColor = [YCTool colorOfHex:0x777777];
}

+ (float)height {
    return 30;
}

@end
