//
//  YCUserTaskView.m
//  BusinessCat
//
//  Created by 余超 on 2018/3/19.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import "YCUserTaskView.h"

@implementation YCUserTaskView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"YCUserTaskCell" bundle:nil] forCellWithReuseIdentifier:@"YCUserTaskCell"];
}

+ (float)height {
    return 109;
}

+ (instancetype)view {
    YCUserTaskView *view = [[NSBundle mainBundle] loadNibNamed:@"YCUserTaskView" owner:nil options:nil].firstObject;
    return view;
}

@end
