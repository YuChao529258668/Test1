//
//  YCMeetingPayCell.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/24.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCMeetingPayCell.h"

@implementation YCMeetingPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.hintLabel1.textColor = [YCTool colorOfHex:0xff3e3e];
    self.hintLabel2.textColor = [YCTool colorOfHex:0xb4b4b4];
}

@end
