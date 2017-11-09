//
//  CGUserLevelView.m
//  CGSays
//
//  Created by mochenyang on 2017/3/18.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGUserLevelView.h"

@interface CGUserLevelView()

@property(nonatomic,retain)UILabel *title;

@end

@implementation CGUserLevelView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
    }
    return self;
}

-(UILabel *)title{
    if(!_title){
        _title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
        _title.font = [UIFont systemFontOfSize:13];
        _title.textColor = [UIColor grayColor];
    }
    return _title;
}


-(void)setLevelName{
    NSString *title = [ObjectShareTool sharedInstance].currentUser.gradeName;
    NSString *descStr = nil;
    
    if([ObjectShareTool sharedInstance].currentUser.isVip == 1){//是vip
        if([ObjectShareTool sharedInstance].currentUser.vipDays > 0 && [ObjectShareTool sharedInstance].currentUser.vipDays < 30){
            descStr = [NSString stringWithFormat:@"(%d天后过期)",[ObjectShareTool sharedInstance].currentUser.vipDays];
        }
    }else if([ObjectShareTool sharedInstance].currentUser.vipDays < 0){
        descStr = [NSString stringWithFormat:@"(会员已过期)"];
    }
    if(descStr){
        int start = (int)title.length;
        int length = (int)descStr.length;
        title = [title stringByAppendingString:descStr];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(start,length)]; //设置字体颜色
        self.title.attributedText = str;
    }else{
        self.title.text = title;
    }
    CGRect levelNameRect = self.title.frame;
    [self.title sizeToFit];
    levelNameRect.size.width = self.title.frame.size.width;
    self.title.frame = levelNameRect;
    [self addSubview:self.title];
}

@end
