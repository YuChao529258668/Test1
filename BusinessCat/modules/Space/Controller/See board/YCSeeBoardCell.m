//
//  YCSeeBoardCell.m
//  BusinessCat
//
//  Created by 余超 on 2018/1/29.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCSeeBoardCell.h"

@implementation YCSeeBoardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    // 下划线
    NSString *textStr = [self.joinBtn titleForState:UIControlStateNormal];
    NSDictionary *attribtDic = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName: [YCTool colorWithRed:253 green:129 blue:128 alpha:1]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
    NSRange range = [textStr rangeOfString:@"加入" options:NSBackwardsSearch];
    [attribtStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range: range];
    [self.joinBtn setAttributedTitle:attribtStr forState:UIControlStateNormal];
    [self.joinBtn setAttributedTitle:attribtStr forState:UIControlStateHighlighted];
}

- (IBAction)clickJoinBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:[self.class notificationName] object:nil];
}

+ (NSString *)notificationName {
    return @"YCSeeBoardCellClickJoinBtnNotification";
}

@end
