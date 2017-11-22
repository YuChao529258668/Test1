//
//  YCSelectRoomHeaderView.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCSelectRoomHeaderView.h"

@implementation YCSelectRoomHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick {
    self.triangleBtn.selected = !self.triangleBtn.isSelected;
}

+ (instancetype)headerView {
    YCSelectRoomHeaderView *view = [[NSBundle mainBundle] loadNibNamed:@"YCSelectRoomHeaderView" owner:nil options:nil].firstObject;
    return view;
}

+ (float)headerViewHeight {
    return 44;
}

@end
